# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-nayttamo

CONFIG += sailfishapp libcrypto

SOURCES += src/harbour-nayttamo.cpp \
    src/urldecrypt.cpp \
    src/serializer.cpp

DISTFILES += \
    rpm/harbour-nayttamo.changes.in \
    rpm/harbour-nayttamo.spec \
    rpm/harbour-nayttamo.yaml \
    translations/*.ts \
    harbour-nayttamo.desktop \
    qml/js/checkSubtitles.js \
    qml/js/getSubtitles.js \
    qml/js/http.js \
    qml/js/promise.js \
    qml/js/timeout.js \
    qml/js/yleApi.js \
    qml/main.qml \
    qml/pages/AboutPage.qml \
    qml/pages/CategoriesPage.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/PlayerPage.qml \
    qml/pages/ProgramDelegate.qml \
    qml/pages/ProgramOverviewPage.qml \
    qml/pages/ProgramsPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/SubtitlesItem.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-nayttamo.ts \
    translations/harbour-nayttamo-fi.ts \
    translations/harbour-nayttamo-sv.ts

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_BUILDNUM=\\\"$$RELEASE\\\"

!exists($$PWD/.env) {
    error( ".env needs to be defined in the project root" )
}

DOTENV = "$$cat($$PWD/.env)"
for(var, $$list($$DOTENV)) {
    DEFINES += $$var
    message($$var)
}

message($$DEFINES)

REQUIRED = $$find(DEFINES, "APP_ID") $$find(DEFINES, "APP_KEY") $$find(DEFINES, "DECRYPT_KEY")
!count(REQUIRED, 3) {
   error( "invalid env variables" )
}

HEADERS += \
    src/urldecrypt.h \
    src/serializer.h

unix: PKGCONFIG += libcrypto
