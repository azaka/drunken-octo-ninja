#!/bin/bash

qmake CONFIG+=debug -spec symbian-sbsv2 test.pro
make -j4 -w release-gcce
