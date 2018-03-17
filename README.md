# Näyttämö

Native YLE Areena for Sailfish OS

### features

* view currently playing programs
* search
* show categories
* show programs by categories

### development

Näyttämö expects YLE API credentials (APP_ID, APP_KEY & DECRYPT_KEY) to be found from `.env` file in project root.

qmake is reading the credentials from file & passing them to C++ as DEFINES and after that they are made available for the QML application as context properties.

```
APP_ID=\"APP_ID\"
APP_KEY=\"APP_KEY\"
DECRYPT_KEY=\"DECRYPT_KEY\"
```