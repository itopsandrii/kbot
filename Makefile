VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ghcr.io/itopsandrii#docker hub account
TARGETARCH=amd64
TARGETOS=linux

format: 
	gofmt -s -w ./

lint: 
	golint # check syntax error

test:
	go test -v # 

get:
	go get

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/itopsandrii/kbot/cmd.appVersion=${VERSION}

image: 
	@echo "Building docker image"
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .

push:
	@echo "Push Image to REGISTRY"
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean: 
	rm -rf kbot 
