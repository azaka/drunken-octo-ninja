#!/bin/bash

git clone --depth 1 https://github.com/termux/x11-packages && cd x11-packages && ./scripts/travis-build.sh gtk2
