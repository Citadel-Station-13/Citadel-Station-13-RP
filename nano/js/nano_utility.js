// NanoUtility is the place to store utility functions
var NanoUtility = function (){ //this isn't C, this is JS
    var _urlParameters = {}; // This is populated with the base url parameters (used by all links), which is probaby just the "src" parameter

	return {
        init: function (){
			var body = $('body'); // We store data in the body tag, it's as good a place as any
			_urlParameters = body.data('urlParameters'); //i heard this contains the href too
        },
		// generate a Byond href, combines _urlParameters with parameters
		generateHref: function (parameters){
			return '?' + buildQueryString(_urlParameters) + '&'+ buildQueryString(parameters);
		},
    }
}();

if (typeof jQuery == 'undefined') {
	alert('ERROR: Javascript library (jQuery) failed to load!');
}
if (typeof doT == 'undefined') {
	alert('ERROR: Template engine (doT) failed to load!');
}

(function() {
	window._alert = window.alert;
	window.alert = function(str) { //catch alert
		window.location.href = "byond://?src="
			+ document.getElementById('data').getAttribute('data-ref')
			+ buildQueryString({"nano_err": str}); //send to backend
		_alert(str);
	};
	window.onerror = function(msg, url, line, col, error) {
		// Proper stacktrace
		var stack = error && error.stack;
		// Ghetto stacktrace
		if (!stack) {
			stack = msg + '\n   at ' + url + ':' + line;
			if (col) {
				stack += ':' + col;
			}
		}
		// Append user agent info
		stack += '\n\nUser Agent: ' + navigator.userAgent;
		// Print error to the page
		//Nope no fancy BSOD for you!
		// Send to the backend
		window.location = 'byond://?src='
			+ document.getElementById('data').getAttribute('data-ref')
			+ '&' + buildQueryString({"nano_err": stack, "fatal": 1});
		// Short-circuit further updates.
		// i don't know how to currently do this
		//NanoStateManager = function () {};
		// Prevent default action
		return true;
	};
})();


// All scripts are initialised here, this allows control of init order
$(document).ready(function() {
	NanoUtility.init();
	NanoStateManager.init();
	NanoTemplate.init();
});

$.ajaxSetup({
    cache: false
});

function buildQueryString(obj) {
  return Object.keys(obj).map(function (key) {
    return encodeURIComponent(key) + '=' + encodeURIComponent(obj[key]);
  }).join('&');
};

//<shims>
// Production steps of ECMA-262, Edition 5, 15.4.4.14
// Reference: http://es5.github.io/#x15.4.4.14
if (!Array.prototype.indexOf) {
  Array.prototype.indexOf = function(searchElement, fromIndex) {
    "use strict";
    var k;
    if (this == null) {
      throw new TypeError('"this" is null or not defined');
    }
    var o = Object(this);
    var len = o.length >>> 0;
    if (len === 0) {
      return -1;
    }
    var n = fromIndex | 0;
    if (n >= len) {
      return -1;
    }
    k = Math.max(n >= 0 ? n : len - Math.abs(n), 0);
    for (; k < len; k++) {
      if (k in o && o[k] === searchElement)
        return k;
    }
    return -1;
  };
}

// Production steps of ECMA-262, Edition 5, 15.4.4.19
// Reference: http://es5.github.com/#x15.4.4.19
if (!Array.prototype.map) {
	Array.prototype.map = function(callback, thisArg) {
		var T, A, k;
		if (this == null) {
			throw new TypeError(" this is null or not defined");
		}
		var O = Object(this);
		var len = O.length >>> 0;
		if (typeof callback !== "function") {
			throw new TypeError(callback + " is not a function");
		}
		if (thisArg) {
				T = thisArg;
		}
		A = new Array(len);
		k = 0;
		while(k < len) {
			var kValue, mappedValue;
			if (k in O) {
				kValue = O[k];
				mappedValue = callback.call(T, kValue, k, O);
				A[k] = mappedValue;
			}
			k++;
		}
		return A;
	};
}
//</shims>

if (!String.prototype.format){
    String.prototype.format = function (args) {
        var str = this;
        return str.replace(String.prototype.format.regex, function(item) {
            var intVal = parseInt(item.substring(1, item.length - 1));
            var replace;
            if (intVal >= 0) {
                replace = args[intVal];
            } else if (intVal === -1) {
                replace = "{";
            } else if (intVal === -2) {
                replace = "}";
            } else {
                replace = "";
            }
            return replace;
        });
    };
    String.prototype.format.regex = new RegExp("{-?[0-9]+}", "g");
};

Object.size = function(obj) {
    var size = 0, key;
    for (var key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};

String.prototype.toTitleCase = function () {
    var smallWords = /^(a|an|and|as|at|but|by|en|for|if|in|of|on|or|the|to|vs?\.?|via)$/i;

    return this.replace(/([^\W_]+[^\s-]*) */g, function (match, p1, index, title) {
        if (index > 0 && index + p1.length !== title.length &&
            p1.search(smallWords) > -1 && title.charAt(index - 2) !== ":" &&
            title.charAt(index - 1).search(/[^\s-]/) < 0) {
            return match.toLowerCase();
        }

        if (p1.substr(1).search(/[A-Z]|\../) > -1) {
            return match;
        }

        return match.charAt(0).toUpperCase() + match.substr(1);
    });
};

Function.prototype.inheritsFrom = function (parentClassOrObject) {
    this.prototype = new parentClassOrObject;
    this.prototype.constructor = this;
    this.prototype.parent = parentClassOrObject.prototype;
    return this;
};

if (!String.prototype.trim) {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    };
}

// Replicate the ckey proc from BYOND (if it does not exist)
if (!String.prototype.ckey) {
    String.prototype.ckey = function () {
        return this.replace(/\W/g, '').toLowerCase();
    };
}
