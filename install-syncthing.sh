#!/bin/bash

wget https://github.com/syncthing/syncthing/releases/download/v0.14.49/syncthing-linux-amd64-v0.14.49.tar.gz
tar xzvf syncthing-linux-amd64-v0.14.49.tar.gz

cp syncthing-linux-amd64-v0.14.49/syncthing /usr/local/bin/syncthing
rm syncthing-linux-amd64-v0.14.49.tar.gz
syncthing --help
