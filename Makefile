# Get config file
MAKEFILE_PATH=$(abspath $(lastword $(MAKEFILE_LIST)))
THIS_DIR=$(dir $(MAKEFILE_PATH))
CONFIG="$(THIS_DIR)/config.sh"

# Get docker image names from config
DOCKER_DEBIAN_BASE_IMAGE=$(shell . $(CONFIG); echo $$DOCKER_DEBIAN_BASE_IMAGE)
DOCKER_DEV_MASTER_IMAGE=$(shell . $(CONFIG); echo $$DOCKER_DEV_MASTER_IMAGE)
DOCKER_RPI_BUILDER_IMAGE=$(shell . $(CONFIG); echo $$DOCKER_RPI_BUILDER_IMAGE)

all:
	./create_base_image.sh			&& \
	./create_master_image.sh		&& \
	./create_rpi_builder_image.sh

env:
	docker run $(DOCKER_DEV_MASTER_IMAGE) env

publish:
	docker push $(DOCKER_DEBIAN_BASE_IMAGE)
	docker push $(DOCKER_DEV_MASTER_IMAGE)
	docker push $(DOCKER_RPI_BUILDER_IMAGE)

