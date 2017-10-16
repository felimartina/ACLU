
resource "aws_iam_role" "codebuild_role" {
  name = "${var.APP_NAME}-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.APP_NAME}-codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"
  # TODO - Restrict policy to specific ECR (receive ECR ARN from variables)
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "WriteLogsToCloudWatch",
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "arn:aws:logs:*:*:*"
    }, {
      "Sid": "ManageS3Bucket",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.FRONT_END_BUCKET_NAME}"
    }, {
      "Sid": "PublishDockerImagesToECR",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": "*", 
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "aclu-codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_codebuild_project" "aclu" {
  name          = "${var.APP_NAME}-codebuild"
  description   = "Automates build process for ACLU project."
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:1.12.1"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags {
    "project" = "${var.APP_NAME}"
    "environment" = "${var.ENV}"
  }
}