.PHONY: dev ci

dev:
	bash -c 'trap "" SIGINT SIGTERM ERR; docker-compose -p aclu up --build'

ci:
	docker-compose -p aclu up --build -d
	curl --retry 3 --max-time 5 http://localhost:5000/aloha
