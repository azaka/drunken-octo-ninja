QT       += core
TARGET = test
TEMPLATE = app
QMAKE_CXXFLAGS += -marm -Wno-parentheses -Wno-comment -Wno-unused-local-typedefs
DEFINES += __STDC_CONSTANT_MACROS
QMAKE_CXXFLAGS *= -Wno-unused-function -Wno-unused-variable -Wno-strict-aliasing -fno-strict-aliasing -Wno-unused-parameter -Wno-multichar -Wno-uninitialized -Wno-ignored-qualifiers -Wno-missing-field-initializers


SOURCES += main.cpp
INCLUDEPATH += $${PWD}/ffmpeg/symbian/armv6/include
LIBS += -lavutil -lavformat
