#/bin/bash

SUDO=sudo
$SUDO apt-get update
# install required tools
$SUDO apt-get install python3-pip realpath zip lzip unzip wget openjdk-8-jdk git build-essential -y
python3 -m pip install requests bs4 pytz

# setup android sdk
# download the "sdk manager"
cd #HOME
wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
unzip -q sdk-tools-linux-3859397.zip && \
yes|tools/bin/sdkmanager --licenses
tools/bin/sdkmanager "build-tools;27.0.1" "platforms;android-27" "platforms;android-16"

# make aapt visible
export PATH=$(pwd)/build-tools/27.0.1:$PATH

# git clone git@github.com:opengapps/opengapps.git
git clone https://github.com/opengapps/opengapps && cd opengapps && \
./download_sources.sh --shallow arm
make -j7
