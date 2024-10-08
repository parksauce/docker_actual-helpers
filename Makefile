DATE=$(shell date +%Y%m%d)
PWD=$(shell pwd)
REGISTRY=docker.io
REPO=parksauce
IMAGE_NAME=actual-helpers

login-to-docker:
	docker login -u $(DOCKER_USER) -p $(DOCKER_PASS) $(REGISTRY)

setup-buildx:
	docker buildx create --name container-builder --driver docker-container --use --bootstrap

build:
	docker buildx build --load --platform amd64 -t $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64 -t $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64-$(DATE) .
	docker buildx build --load --platform arm64 -t $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64 -t $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64-$(DATE) .

push:
	docker push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64 && docker push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64
	docker push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64-$(DATE) && docker push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64-$(DATE)

create-manifest:
	docker manifest create --amend $(REGISTRY)/$(REPO)/$(IMAGE_NAME):latest $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64 $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64
	docker manifest create --amend $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(DATE) $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64-$(DATE) $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64-$(DATE)

push-manifest:
	docker manifest push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):latest
	docker manifest push $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(DATE)

publish:
	make shellcheck
	make login-to-docker
	make setup-buildx
	make build
	make push
	make create-manifest
	make push-manifest
	make cleanup

cleanup:
	docker manifest rm $(REGISTRY)/$(REPO)/$(IMAGE_NAME):latest $(REGISTRY)/$(REPO)/$(IMAGE_NAME):$(DATE)
	docker rmi -f $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64 $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64 $(REGISTRY)/$(REPO)/$(IMAGE_NAME):amd64-$(DATE) $(REGISTRY)/$(REPO)/$(IMAGE_NAME):arm64-$(DATE)

test:
	docker buildx build --load -t actual-helpers:alpha .
	docker run --name actual-helpers-test --env-file .env  actual-helpers:alpha

cleanup-test:
	docker rm -f actual-helpers-test
	docker rmi -f actual-helpers:alpha

shellcheck:
	docker run --rm -v $(PWD):/script koalaman/shellcheck:stable /script/init.sh