FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Detroit

#
# Dependencies from docs/ros_installation.md
#
RUN apt-get update && apt-get install --yes \
    python3-rosdep
# rosdep init might fail because the Docker image includes a source file
# already, so we use a semicolon here
RUN rosdep init ; rosdep update

RUN apt-get update && apt-get install --yes \
    build-essential \
    python3-catkin-tools \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool

#
# Dependencies from README.md
#
RUN apt-get update && apt-get install --yes --no-install-recommends \
    apt-utils

RUN apt-get update && apt-get install --yes \
    cmake \
    build-essential \
    unzip \
    pkg-config \
    autoconf \
    libboost-all-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libvtk7-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    libparmetis-dev \
    python3-wstool \
    python3-catkin-tools \
    libtool

RUN apt-get update && apt-get install --yes \
    libtbb-dev

#
# Additional dependencies not already in the Docker image
#
RUN apt-get update && apt-get install --yes \
    clang-12 \
    git

#
# Build
#
RUN mkdir -p /root/kimera_ws/src/Kimera-VIO-ROS
WORKDIR /root/kimera_ws

RUN . /opt/ros/noetic/setup.sh
RUN catkin init
RUN catkin config --cmake-args \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=14 \
    -DGTSAM_TANGENT_PREINTEGRATION=OFF
RUN catkin config --merge-devel

COPY . /root/kimera_ws/src/Kimera-VIO-ROS
# spoof the url as https just in case we're using ssh locally
WORKDIR /root/kimera_ws/src/Kimera-VIO-ROS
RUN git remote set-url origin https://github.com/fluentrobotics/Kimera-VIO-ROS-Noetic.git

WORKDIR /root/kimera_ws/src
RUN wstool init
RUN wstool merge Kimera-VIO-ROS/install/kimera_vio_ros_https.rosinstall
RUN wstool update

ARG CC=gcc
ARG CXX=g++
WORKDIR /root/kimera_ws
RUN . /opt/ros/noetic/setup.sh && catkin build -j4
