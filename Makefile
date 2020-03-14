build:
	docker build . -t ruizink/go-web-demo

run:
	docker run --rm -p 8080:8080 ruizink/go-web-demo

push:
	docker push ruizink/go-web-demo