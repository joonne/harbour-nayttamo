TEMPLATE = app
TARGET = tst-harbour-nayttamo
CONFIG += warn_on qmltestcase

TARGETPATH = /usr/bin
target.path = $$TARGETPATH

DEPLOYMENT_PATH = /usr/share/$$TARGET
qml.path = $$DEPLOYMENT_PATH

DEFINES += QUICK_TEST_SOURCE_DIR=\"\\\"\"$${DEPLOYMENT_PATH}/\"\\\"\"

SOURCES += main.cpp

INSTALLS += target qml

qml.files = *.qml

OTHER_FILES += \
    tst_test.qml
