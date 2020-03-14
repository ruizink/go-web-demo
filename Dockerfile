# build stage
FROM golang:1.14-stretch AS build-env

RUN apt-get update && apt-get install -y \
    xz-utils
# install UPX
ADD https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz /usr/local
RUN xz -d -c /usr/local/upx-3.96-amd64_linux.tar.xz | \
    tar -xOf - upx-3.96-amd64_linux/upx > /bin/upx && \
    chmod a+x /bin/upx
WORKDIR /go/src/app
ADD . src
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main src/main.go
# strip and compress the binary
RUN strip --strip-unneeded main
RUN upx main

# final stage
FROM scratch
WORKDIR /root
COPY --from=build-env /go/src/app/main .
ENTRYPOINT ["./main"]