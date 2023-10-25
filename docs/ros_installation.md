## ROS Installation

These are instructions to install ROS Noetic on Ubuntu 20.04.

Install [ROS Desktop-Full Install](http://wiki.ros.org/noetic/Installation), below we provide installation instructions:
```
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

Now, you can install ROS.

```
sudo apt-get install ros-noetic-desktop-full
# Automatically source ROS for convenience:
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

Now, initialize rosdep:
```
sudo apt install python3-rosdep
sudo rosdep init
rosdep update
```

Finally, install dependencies for building packages and catkin tools:
```
sudo apt-get install build-essential python3-catkin-tools python3-rosinstall python3-rosinstall-generator python3-wstool
```
