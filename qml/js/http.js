.import "promise.js" as Promise;

function get(url) {
    var rawResponse = arguments[1];
    return new Promise(function(resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === xhr.DONE) {
                if (xhr.status === 200 && !rawResponse) {
                    var result;
                    try {
                        result = JSON.parse(xhr.responseText);
                    } catch(e) {
                        result = [];
                    }
                    return resolve(result);
                } else if (xhr.status === 200 && rawResponse) {
                    return resolve(xhr.responseText);
                } else if (xhr.status > 400) {
                    return reject('error');
                }
            }
        }
        xhr.send();
    });
}

function post(url, body) {
    return new Promise(function(resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === xhr.DONE) {
                if (xhr.status === 200) {
                    var result;
                    try {
                        result = JSON.parse(xhr.responseText);
                    } catch(e) {
                        result = [];
                    }
                    return resolve(result);
                } else if (xhr.status > 400) {
                    return reject('error');
                }
            }
        }
        xhr.send(body);
    });
}
