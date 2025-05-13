APP=$(shell basename$(shell git remote-url origin))
REGISTRY=itopsandrii #docker hub account
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
   CGENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -0 kbot -ldflags "-X="github.com/itopsandrii/kbot/cmd.appVersion=${VERSION}

image: 
   docker build . -t ${REGISTRY}/${APP}/${VERSION}-${TARGETARCH}

push: 
   docker puch ${REGISTRY}/${APP}/${VERSION}-${TARGETARCH}

clean: 
   rm -rf kbot 
