FROM ubuntu:17.10

MAINTAINER Jens Diemer "https://github.com/jedie/kivy-buildozer-docker"

# Update ubuntu:
RUN set -x \
    && apt-get update -qq \
    && apt-get -y full-upgrade \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install needed packages for buildozer
# base is https://github.com/kivy/buildozer/blob/master/buildozer/tools/packer/scripts/additional-packages.sh
# But we need some more tools here ;)
RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get -y install \
        lib32stdc++6 lib32z1 lib32ncurses5 \
        build-essential \
        python-pip python-dev cython \
        liblzma-dev \
        unzip curl \
    && apt-get -y install git openjdk-8-jdk --no-install-recommends zlib1g-dev \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD requirements.txt /buildozer/requirements.txt

# The buildozer VM used Cython v0.25 and buildozer v0.32
RUN set -x \
    && pip install -U pip \
    && pip install -r /buildozer/requirements.txt

# KivEnt - CyMunk
RUN set -x \
    && apt update -qq \
    && apt -y install libgl1-mesa-dev mesa-common-dev python-kivy \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -x \
    && pip install \
        http://github.com/kivy/kivy/archive/master.zip \
        git+https://github.com/tito/cymunk

ADD kivent_install.sh /buildozer/kivent_install.sh
RUN set -x \
    && chmod +x /buildozer/kivent_install.sh \
    && /buildozer/kivent_install.sh


RUN set -x \
    && adduser buildozer --disabled-password --disabled-login \
    && chown -R buildozer:buildozer /buildozer/

USER buildozer

# ADD kivy_hello_world /buildozer/kivy_hello_world

# download all needed android dependencies:
# semble ne pas fonctionner (résoudre les dépendances de manières "persistantes")
# RUN set -x \
#     && cd /buildozer/kivy_hello_world \
#     && buildozer android release \
#     && cd .. \
#     && rm -rf kivy_hello_world

VOLUME /buildozer/

WORKDIR /buildozer/
