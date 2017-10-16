# Bucket to store builds
resource "aws_s3_bucket" "codepipeline_build_repository" {
  bucket = "aclu-builds"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.APP_NAME}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.APP_NAME}-codepipeline-policy"
  role = "${aws_iam_role.codepipeline_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ManageArtifactsInBuildBucket",
      "Effect":"Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.codepipeline_build_repository.arn}",
        "${aws_s3_bucket.codepipeline_build_repository.arn}/*"
      ]
    },
    {
      "Sid": "AccessToCodeBuild",
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }, {
      "Sid": "AccessToCodeDeploy",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "aclu" {
  name     = "${var.APP_NAME}-codepipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline_build_repository.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["codebase"]

      configuration {
        Owner      = "${var.GITHUB_OWNER}"
        Repo       = "${var.GITHUB_REPO}"
        Branch     = "${var.GITHUB_BRANCH}"
        OAuthToken = "${var.GITHUB_TOKEN}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name              = "Build"
      category          = "Build"
      owner             = "AWS"
      provider          = "CodeBuild"
      input_artifacts   = ["codebase"]
      output_artifacts  = ["build"]
      version           = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.aclu.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build"]
      version         = "1"

      configuration {
        ApplicationName     = "${aws_codedeploy_app.aclu.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.aclu.deployment_group_name}"
      }
    }
  }
}