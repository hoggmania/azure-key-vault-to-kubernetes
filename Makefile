PACKAGE = github.com/SparebankenVest/azure-keyvault-controller
DOCKER_IMAGE = dokken.azurecr.io/azure-keyvault-controller
DOCKER_WEBHOOK_IMAGE = dokken.azurecr.io/azure-keyvault-secrets-webhook
DOCKER_VAULTENV_IMAGE = dokken.azurecr.io/azure-keyvault-env
DOCKER_TAG 	 = $(shell git rev-parse --short HEAD)
DOCKER_RELEASE_IMAGE = spvest/azure-keyvault-controller
DOCKER_RELEASE_TAG 	 = $(shell git describe)
GOPACKAGES = $(shell go list ./... | grep -v /pkg/)
BUILD_DATE = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VCS_URL = https://github.com/SparebankenVest/azure-keyvault-controller
VCS_PROJECT_PATH = ./cmd/azure-keyvault-controller

build-controller:
	docker build --no-cache --build-arg PACKAGE=$(PACKAGE) --build-arg VCS_PROJECT_PATH=$(VCS_PROJECT_PATH) --build-arg VCS_REF=$(DOCKER_TAG) --build-arg BUILD_DATE=$(BUILD_DATE) --build-arg VCS_URL=$(VCS_URL) -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

build-webhook:
	docker build --build-arg VCS_REF=$(DOCKER_TAG) --build-arg BUILD_DATE=$(BUILD_DATE) --build-arg VCS_URL=$(VCS_URL) -t $(DOCKER_WEBHOOK_IMAGE):$(DOCKER_TAG) -f Dockerfile.webhook .

build-vaultenv:
	docker build --build-arg VCS_REF=$(DOCKER_TAG) --build-arg BUILD_DATE=$(BUILD_DATE) --build-arg VCS_URL=$(VCS_URL) -t $(DOCKER_VAULTENV_IMAGE):$(DOCKER_TAG) -f Dockerfile.vaultenv .

test:
	CGO_ENABLED=0 go test -v $(GOPACKAGES)

push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

push-webhook:
	docker push $(DOCKER_WEBHOOK_IMAGE):$(DOCKER_TAG)

push-vaultenv:
	docker push $(DOCKER_VAULTENV_IMAGE):$(DOCKER_TAG)

pull-release:
	docker pull $(DOCKER_IMAGE):$(DOCKER_TAG) 

tag-release:
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_RELEASE_IMAGE):$(DOCKER_RELEASE_TAG)
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_RELEASE_IMAGE):latest

push-release:
	docker push $(DOCKER_RELEASE_IMAGE):$(DOCKER_RELEASE_TAG)
	docker push $(DOCKER_RELEASE_IMAGE):latest
