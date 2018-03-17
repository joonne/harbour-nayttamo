/* kayhadrin/js-timeout-polyfill.js */
(function (global) {

    if (global.setTimeout ||
        global.clearTimeout ||
        global.setInterval ||
        global.clearInterval) {
        return;
    }

    var Timer = function() {
        /* https://stackoverflow.com/questions/28507619/how-to-create-delay-function-in-qml */
        return Qt.createQmlObject("import QtQuick 2.0; Timer {}", appWindow);
    }

    function toCompatibleNumber(val) {
        switch (typeof val) {
            case 'number':
                break;
            case 'string':
                val = parseInt(val, 10);
                break;
            case 'boolean':
            case 'object':
                val = 0;
                break;

        }
        return val > 0 ? val : 0;
    }

    function setTimerRequest(handler, delay, interval, args) {
        handler = handler || function () {
            };
        delay = toCompatibleNumber(delay);
        interval = toCompatibleNumber(interval);

        var applyHandler = function () {
            handler.apply(this, args);
        };

        var timer;
        if (interval > 0) {
            timer = new Timer();
            timer.interval = interval;
            timer.repeat = true;
            timer.triggered.connect(applyHandler)
            timer.start();
        } else {
            timer = new Timer();
            timer.interval = delay;
            timer.repeat = false;
            timer.triggered.connect(applyHandler)
            timer.start();
        }

        return timer;
    }

    function clearTimerRequest(timer) {
        timer.cancel();
    }

    /////////////////
    // Set polyfills
    /////////////////
    global.setInterval = function setInterval() {
        var args = Array.prototype.slice.call(arguments);
        var handler = args.shift();
        var ms = args.shift();

        return setTimerRequest(handler, ms, ms, args);
    };

    global.clearInterval = function clearInterval(timer) {
        clearTimerRequest(timer);
    };

    global.setTimeout = function setTimeout() {
        var args = Array.prototype.slice.call(arguments);
        var handler = args.shift();
        var ms = args.shift();

        return setTimerRequest(handler, ms, 0, args);
    };

    global.clearTimeout = function clearTimeout(timer) {
        clearTimerRequest(timer);
    };

    global.setImmediate = function setImmediate() {
        var args = Array.prototype.slice.call(arguments);
        var handler = args.shift();

        return setTimerRequest(handler, 0, 0, args);
    };

    global.clearImmediate = function clearImmediate(timer) {
        clearTimerRequest(timer);
    };

})(this);
