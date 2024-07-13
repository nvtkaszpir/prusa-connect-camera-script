GIT_COMMIT := $(shell git rev-parse --short HEAD)
GIT_SOURCE := $(shell git config --get remote.origin.url)
URL := $(shell yq '.site_url' mkdocs.yml)
QUAY_REPO_USER := kaszpir
QUAY_REPO_NAME := prusa-connect-script


.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: version
version: ## show git version
	@echo GIT_COMMIT IS $(GIT_COMMIT)

.PHONY: lint-dockerfile
lint-dockerfile: ## Runs hadolint against application dockerfile
	docker run --rm -v "$(PWD):/data" -w "/data" hadolint/hadolint hadolint Dockerfile.amd64
	docker run --rm -v "$(PWD):/data" -w "/data" hadolint/hadolint hadolint Dockerfile.arm64

.PHONY: docker_config
docker_config: ## configure docker to allow multi-arch builds
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes


.PHONY: image_amd64
.PHONY: image_arm64
.PHONY: image_arm-v7
image_amd64: ARCH=amd64
image_amd64: D_ARCH=amd64
image_arm64: ARCH=arm64
image_arm64:  D_ARCH=arm64
image_arm-v7: ARCH=arm/v7
image_arm-v7: D_ARCH=arm-v7
image_amd64 image_arm64 image_arm-v7: docker_config ## build image for specific arch
	docker buildx build --load \
		--platform=linux/${ARCH} \
		-t prusa-connect-script:${GIT_COMMIT}-${D_ARCH} \
		--build-arg GIT_COMMIT=${GIT_COMMIT} \
		--build-arg GIT_SOURCE=${GIT_SOURCE} \
		--build-arg URL=${URL} \
		-f Dockerfile.${D_ARCH} .

.PHONY: image
image: ## build images
	$(MAKE) image_amd64 image_arm64 image_arm_v7

.PHONY: list_images
list_images: ## list images if they were built
	@docker image ls | grep ${GIT_COMMIT}


.PHONY: clean
clean: ## delete built images for current commit
	docker image ls | grep ${GIT_COMMIT} | awk '{print $$3}' | sort | uniq | xargs docker rmi -f || true

.PHONY: all
all: lint-dockerfile list_images ## build all

.PHONY: quay_amd64
.PHONY: quay_arm64
.PHONY: quay_arm_v7
quay_amd64: ARCH=amd64
quay_arm64: ARCH=arm64
quay_arm_v7: ARCH=arm-v7
quay_amd64 quay_arm64 quay_arm_v7: ## push image to quay.io per arch
	$(MAKE) image_${ARCH}
	docker tag prusa-connect-script:${GIT_COMMIT}-${ARCH} quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-${ARCH}
	docker push quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-${ARCH}

.PHONY: quay_multiarch
quay_multiarch:  ## create multi-arch manifest and push it
	# $(MAKE) quay_amd64 quay_arm64 quay_arm_v7
	docker manifest create \
		quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT} \
			quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-amd64 \
			quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-arm64 \
			quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-arm-v7 \
		--amend
	docker manifest push --purge quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}

	docker manifest create \
		quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:latest \
			quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-amd64 \
			quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-arm64 \
			quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:${GIT_COMMIT}-arm-v7 \
		--amend
	docker manifest push --purge quay.io/${QUAY_REPO_USER}/${QUAY_REPO_NAME}:latest

.PHONY: quay
quay: ## build images and push to quay.io
	$(MAKE) quay_amd64 quay_arm64 quay_arm_v7
