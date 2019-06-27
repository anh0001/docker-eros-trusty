# FROM osrf/ros:indigo-desktop-full-trusty
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/ubuntu

# Set environment proxy
# ENV http_proxy=http://10.252.11.50:3128
# ENV https_proxy=https://10.252.11.50:3128

# RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

# Install ROS Indigo full desktop
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
	&& apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
	&& apt-get update && apt-get install dpkg \
	&& apt-get install -y --force-yes --no-install-recommends ros-indigo-desktop-full \
	&& sudo rosdep init && rosdep update \
	&& apt-get install -y --force-yes --no-install-recommends ros-indigo-rqt-rviz ros-indigo-joy
	
# Install dependencies
RUN apt-get install -y --force-yes --no-install-recommends libqglviewer-dev \
		libgsl0-dev \
		ros-indigo-gazebo-ros-control \
		ros-indigo-ros-controllers \
		ros-indigo-controller-manager \
		ros-indigo-rqt-controller-manager \
		v4l-utils v4l2ucp v4l-conf \
	&& add-apt-repository ppa:pj-assis/ppa \
	&& apt-get update \
	&& apt-get install guvcview
	
# Python dependencies
RUN apt-get install -y --force-yes --no-install-recommends sshpass \
	&& apt-get install python-pip python-dev build-essential \
	&& sudo pip install --upgrade pip \
	&& sudo pip install --upgrade virtualenv \
	&& sudo pip install --upgrade --no-deps --force-reinstall pexpect \
	&& sudo pip install termcolor
# ncurses library
RUN apt-get install -y --force-yes --no-install-recommends libncurses5-dev
# x264 Library:
RUN apt-get install -y --force-yes --no-install-recommends libx264-dev
# GCC ARM Compiler:
RUN apt-get install -y --force-yes --no-install-recommends gcc-arm-none-eabi
# Doxygen Documentation System:
RUN apt-get install -y --force-yes --no-install-recommends doxygen
# Utilities (optional, choose relevant ones):
RUN apt-get install -y --force-yes --no-install-recommends curl tshark ssh screen \
	gitk qgit \
	joe kwrite \
	gdb valgrind tree
		
RUN apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# built-in packages
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends software-properties-common curl \
    && sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list" \
    && curl -SL http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key | sudo apt-key add - \
    && add-apt-repository ppa:fcwu-tw/ppa \
    && apt-get update \
    && apt-get install -y --force-yes --no-install-recommends \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant libreoffice-l10n-zh-tw \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# tini for subreap                                   
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
