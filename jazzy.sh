#!/usr/bin/env bash
set -eo pipefail

echo "Checking locale..."

if ! locale | grep -q "UTF-8"; then
    echo "UTF-8 locale not detected. Configuring locale..."
    sudo apt update && sudo apt install -y locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

locale

echo "Ubuntu Universe repository is enabled..."

sudo apt install -y software-properties-common
sudo add-apt-repository universe

echo "Installing the ros2-apt-source package..."
sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

echo "Installing ros-dev-tools"
sudo apt update && sudo apt install ros-dev-tools -y

sudo apt update
sudo apt upgrade -y
sudo apt install ros-jazzy-desktop -y

echo ""
echo "ROS 2 Jazzy installation completed."
echo ""

echo "Gazebo Necessary Tools"
sudo apt-get update
sudo apt-get install curl lsb-release gnupg -y

sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install gz-harmonic -y

source /opt/ros/jazzy/setup.bash
sudo apt install ros-jazzy-ros-gz* -y
