#/bin/bash

SUDO=sudo
$SUDO apt-get update
# install required tools
$SUDO apt-get install python3-pip realpath zip lzip unzip wget openjdk-8-jdk git build-essential -y
python3 -m pip install bs4 pytz pycrypto beautifulsoup4 html5lib protobuf requests pytz
python3 -m pip install requests --upgrade

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
git clone --depth 1 https://github.com/opengapps/apkcrawler
cp apkcrawler/aptoidecrawler.config.example apkcrawler/aptoidecrawler.config
cp apkcrawler/playstorecrawler.config.example apkcrawler/playstorecrawler.config
./report_sources.sh nosig | apkcrawler/apkcrawler.py

# not enough disk space
# make -j7
