VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := ghcr.io/itopsandrii


PLATFORM ?= linux
ARCH ?= amd64

TAG := $(VERSION)-$(PLATFORM)-$(ARCH)

help:
	@echo "Available targets:"
	@echo "  help        - Show this help message"
	@echo "  format      - Format Go code"
	@echo "  lint        - Run golangci-lint on the project"
	@echo "  test        - Run unit tests"
	@echo "  get         - Sync and download dependencies"
	@echo "  build       - Build binary for target platform (default: linux/amd64)"
	@echo "  image       - Build Docker image with the prebuilt binary"
	@echo "  push        - Push Docker image to registry"
	@echo "  clean       - Remove binary and local Docker image"
	@echo "  clean_all   - Remove dangling Docker images"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build PLATFORM=linux ARCH=arm64"
	@echo "  make image PLATFORM=darwin ARCH=amd64"
	@echo "  make push PLATFORM=windows ARCH=amd64"
	@echo ""
	@echo "Configuration (can be overridden via command line):"
	@echo "  PLATFORM    - Target OS (linux, darwin, windows) [default: linux]"
	@echo "  ARCH        - Target architecture (amd64, arm64) [default: amd64]"
	@echo ""
	@echo "To override defaults, specify PLATFORM and ARCH explicitly:"
	@echo "  Example: make build PLATFORM=linux ARCH=arm64"


format:
	@gofmt -s -w ./

lint:
	@golint 

test:
	@go test -v 

get:
	@go get

docker_build_binary:
	docker build -f Dockerfile.build -t $(APP)-builder --build-arg PLATFORM=$(PLATFORM) --build-arg ARCH=$(ARCH) .
	docker create --name $(APP)-builder-container $(APP)-builder
	docker cp $(APP)-builder-container:/app/kbot-$(PLATFORM)-$(ARCH) ./kbot-$(PLATFORM)-$(ARCH)
	docker rm $(APP)-builder-container

build: format get
	@echo "Building for $(PLATFORM)/$(ARCH)"
	@GOOS=$(PLATFORM) GOARCH=$(ARCH) CGO_ENABLED=0 \
		go build -v -o kbot-$(PLATFORM)-$(ARCH) \
		-ldflags "-X=github.com/itopsandrii/kbot/cmd.appVersion=$(VERSION)"


image:
	@echo "Building Docker image $(REGISTRY)/$(APP):$(TAG)"
	@docker build -f Dockerfile \
		-t $(REGISTRY)/$(APP):$(TAG) \
		--build-arg BINARY_FILE=kbot-$(PLATFORM)-$(ARCH) .


push:
	@echo "Pushing image $(REGISTRY)/$(APP):$(TAG)"
	@docker push $(REGISTRY)/$(APP):$(TAG)


clean:
	@echo "Cleaning build artifacts and image $(REGISTRY)/$(APP):$(TAG)"
	@rm -rf kbot-$(PLATFORM)-$(ARCH)
	@docker rmi -f $(REGISTRY)/$(APP):$(TAG) || true

clean_all:
	@echo "Removing dangling images"
	@docker image prune -f


