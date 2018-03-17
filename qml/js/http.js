.import "promise.js" as Promise;

function get(url) {
    return new Promise(function(resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === xhr.DONE) {
                if (xhr.status === 200) {
                    var result;
                    try {
                        result = JSON.parse(xhr.responseText);
                    } catch(e) {
                        result = [];
                    }
                    resolve(result);
                } else if (xhr.status > 400) {
                    reject('error');
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
                    resolve(result);
                } else if (xhr.status > 400) {
                    reject('error');
                }
            }
        }
        xhr.send(body);
    });
}
