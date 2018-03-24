DOCKER_TAG?=yoyonel/kivy-buildozer
DOCKER_VOLUMES?=-v /home/atty/Prog/__KIVY__/kivy:/buildozer/kivy \
-v /home/atty/Prog/__KIVY__/kivent:/buildozer/kivent

all: docker-build

docker-build:
	@docker build \
		-t $(DOCKER_TAG) \
		.

docker-run:
	@xhost +
	nvidia-docker run -it \
		--privileged \
		-v /dev/bus/usb:/dev/bus/usb \
		-v /dev/kvm:/dev/kvm \
		-e DISPLAY=$(DISPLAY) \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $XAUTHORITY:/home/ubuntu/.Xauthority \
		--net host \
		$(DOCKER_VOLUMES) \
		$(DOCKER_TAG) \
		bash
	xhost -