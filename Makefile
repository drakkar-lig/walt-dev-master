IMAGE=waltplatform/dev-master

all:
	./create_image.sh

env:
	docker run $(IMAGE) env

publish:
	docker push $(IMAGE)
