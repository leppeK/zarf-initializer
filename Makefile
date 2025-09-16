# Makefile
ZARF_VERSION := v0.61.2
ZARF_ARCH ?= amd64
OUTPUT_DIR := _output
ZARF_CLI := $(OUTPUT_DIR)/zarf
ZARF_INIT := $(OUTPUT_DIR)/zarf-init-$(ZARF_ARCH)-$(ZARF_VERSION).tar.zst
IMAGE_NAME := zarf-initializer
IMAGE_TAG ?= $(ZARF_VERSION)
FULL_IMAGE_NAME := ghcr.io/leppek/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: all
all: build

.PHONY: deps
deps: $(ZARF_CLI) $(ZARF_INIT)

.PHONY: build
build: docker-build

$(ZARF_CLI):
	@echo "--> Downloading Zarf CLI $(ZARF_VERSION) for $(ZARF_ARCH)..."
	@mkdir -p $(OUTPUT_DIR)
	@curl -sL "https://github.com/defenseunicorns/zarf/releases/download/$(ZARF_VERSION)/zarf_$(ZARF_VERSION)_Linux_$(ZARF_ARCH)" -o $(ZARF_CLI)
	@chmod +x $(ZARF_CLI)

$(ZARF_INIT):
	@echo "--> Downloading Zarf INIT $(ZARF_VERSION) for $(ZARF_ARCH)..."
	@mkdir -p $(OUTPUT_DIR)
	@curl -sL "https://github.com/defenseunicorns/zarf/releases/download/$(ZARF_VERSION)/zarf-init-$(ZARF_ARCH)-$(ZARF_VERSION).tar.zst" -o $(ZARF_INIT)

.PHONY: docker-build
docker-build: $(ZARF_CLI) Dockerfile
	@echo "--> Building minimal Docker image $(FULL_IMAGE_NAME)..."
	@docker build -t $(FULL_IMAGE_NAME) .

.PHONY: docker-run
docker-run:
	@echo "--> Running container $(FULL_IMAGE_NAME)..."
	@docker run --rm -it \
	  --network host \
	  -v ${HOME}/.kube:/home/nonroot/.kube \
	  -u $(shell id -u):$(shell id -g) \
	  $(FULL_IMAGE_NAME)

.PHONY: clean
clean:
	@echo "--> Cleaning up..."
	@docker rmi $(FULL_IMAGE_NAME) || true
	@rm -rf $(OUTPUT_DIR)
