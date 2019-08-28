TEMPLATE = app

TARGET = tst-harbour-nayttamo

CONFIG += qmltestcase

TARGETPATH = /usr/bin
target.path = $$TARGETPATH

DEPLOYMENT_PATH = /usr/share/$$TARGET
qml.path = $$DEPLOYMENT_PATH

extra.path = $$DEPLOYMENT_PATH
extra.files = run_tests_on_device.sh

DEFINES += DEPLOYMENT_PATH=\"\\\"\"$${DEPLOYMENT_PATH}/\"\\\"\"

SOURCES += main.cpp

HEADERS +=

INSTALLS += target qml extra

qml.files = *.qml

OTHER_FILES += \
    tst_test.qml
    
