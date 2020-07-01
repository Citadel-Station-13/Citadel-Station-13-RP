// NanoBaseHelpers is where the base template helpers (common to all templates) are stored
NanoBaseHelpers = function (){
	var _baseHelpers = {
            // change ui styling to "syndicate mode"
			syndicateMode: function() {
				$('body').css("background-color","#8f1414");
				$('body').css("background-image","url('uiBackground-Syndicate.png')");
				$('body').css("background-position","50% 0");
				$('body').css("background-repeat","repeat-x");

				$('#uiTitleFluff').css("background-image","url('uiTitleFluff-Syndicate.png')");
				$('#uiTitleFluff').css("background-position","50% 50%");
				$('#uiTitleFluff').css("background-repeat", "no-repeat");

				return '';
			},
			// Generate a Byond link
			link: function( text, icon, parameters, status, elementClass, elementId) {
				var iconHtml = '';
				var iconClass = 'noIcon';
				if (typeof icon != 'undefined' && icon){
					iconHtml = '<div class="uiLinkPendingIcon"></div><div class="uiIcon16 icon-' + icon + '"></div>';
					iconClass = 'hasIcon';
				}

				if (typeof elementClass == 'undefined' || !elementClass){
					elementClass = 'link';
				}

				var elementIdHtml = '';
				if (typeof elementId != 'undefined' && elementId){
					elementIdHtml = 'id="' + elementId + '"';
				}

				if (typeof status != 'undefined' && status){
					return '<div unselectable="on" style="text-select:none;" class="link ' + iconClass + ' ' + elementClass + ' ' + status + '" ' + elementIdHtml + '>' + iconHtml + text + '</div>';
				}

				return '<div unselectable="on" style="text-select:none;" class="linkActive ' + iconClass + ' ' + elementClass + '" data-href="' + NanoUtility.generateHref(parameters) + '" ' + elementIdHtml + '>' + iconHtml + text + '</div>';
			},
			// Round a number to the nearest integer
			round: function(number) {
				return Math.round(number);
			},
			// Returns the number fixed to 1 decimal
			fixed: function(number) {
				return Math.round(number * 10) / 10;
			},
			// Round a number down to integer
			floor: function(number) {
				return Math.floor(number);
			},
			// Round a number up to integer
			ceil: function(number) {
				return Math.ceil(number);
			},
			abs: function(number) {
				return Math.abs(number);
			},
			// Format a string (~string("Hello {0}, how are {1}?", 'Martin', 'you') becomes "Hello Martin, how are you?")
			string: function() {
				if (arguments.length == 0)
				{
					return '';
				}
				else if (arguments.length == 1)
				{
					return arguments[0];
				}
				else if (arguments.length > 1)
				{
					stringArgs = [];
					for (var i = 1; i < arguments.length; i++)
					{
						stringArgs.push(arguments[i]);
					}
					return arguments[0].format(stringArgs);
				}
				return '';
			},
			formatNumber: function(x) {
				// From http://stackoverflow.com/questions/2901102/how-to-print-a-number-with-commas-as-thousands-separators-in-javascript
				var parts = x.toString().split(".");
				parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				return parts.join(".");
			},
			// Capitalize the first letter of a string. From http://stackoverflow.com/questions/1026069/capitalize-the-first-letter-of-string-in-javascript
			capitalizeFirstLetter: function(string) {
				return string.charAt(0).toUpperCase() + string.slice(1);
			},
			// Display a bar. Used to show health, capacity, etc. Use difClass if the entire display bar class should be different
			displayBar: function(value, rangeMin, rangeMax, styleClass, showText, difClass, direction) {

				if (rangeMin < rangeMax)
                {
                    if (value < rangeMin)
                    {
                        value = rangeMin;
                    }
                    else if (value > rangeMax)
                    {
                        value = rangeMax;
                    }
                }
                else
                {
                    if (value > rangeMin)
                    {
                        value = rangeMin;
                    }
                    else if (value < rangeMax)
                    {
                        value = rangeMax;
                    }
                }

				if (typeof styleClass == 'undefined' || !styleClass)
				{
					styleClass = '';
				}

				if (typeof showText == 'undefined' || !showText)
				{
					showText = '';
				}

				if (typeof difClass == 'undefined' || !difClass)
				{
					difClass = ''
				}

				if(typeof direction == 'undefined' || !direction)
				{
					direction = 'width'
				}
				else
				{
					direction = 'height'
				}

				var percentage = Math.round((value - rangeMin) / (rangeMax - rangeMin) * 100);

				return '<div class="displayBar' + difClass + ' ' + styleClass + '"><div class="displayBar' + difClass + 'Fill ' + styleClass + '" style="' + direction + ': ' + percentage + '%;"></div><div class="displayBar' + difClass + 'Text ' + styleClass + '">' + showText + '</div></div>';
			},
			// Display DNA Blocks (for the DNA Modifier UI)
			displayDNABlocks: function(dnaString, selectedBlock, selectedSubblock, blockSize, paramKey) {
			    if (!dnaString)
				{
					return '<div class="notice">Please place a valid subject into the DNA modifier.</div>';
				}

				var characters = dnaString.split('');

                var html = '<div class="dnaBlock"><div class="link dnaBlockNumber">1</div>';
                var block = 1;
                var subblock = 1;
                for (index in characters)
                {
					if (!characters.hasOwnProperty(index) || typeof characters[index] === 'object')
					{
						continue;
					}

					var parameters;
					if (paramKey.toUpperCase() == 'UI')
					{
						parameters = { 'selectUIBlock' : block, 'selectUISubblock' : subblock };
					}
					else
					{
						parameters = { 'selectSEBlock' : block, 'selectSESubblock' : subblock };
					}

                    var status = 'linkActive';
                    if (block == selectedBlock && subblock == selectedSubblock)
                    {
                        status = 'selected';
                    }

                    html += '<div class="link ' + status + ' dnaSubBlock" data-href="' + NanoUtility.generateHref(parameters) + '" id="dnaBlock' + index + '">' + characters[index] + '</div>'

                    index++;
                    if (index % blockSize == 0 && index < characters.length)
                    {
						block++;
                        subblock = 1;
                        html += '</div><div class="dnaBlock"><div class="link dnaBlockNumber">' + block + '</div>';
                    }
                    else
                    {
                        subblock++;
                    }
                }

                html += '</div>';

				return html;
			},
		};

	return {
        addHelpers: function (){
            NanoTemplate.addHelpers(_baseHelpers);
        },
		removeHelpers: function (){
			for (var helperKey in _baseHelpers){
				if (_baseHelpers.hasOwnProperty(helperKey)){
					NanoTemplate.removeHelper(helperKey);
				}
			}
        }
	};
} ();

//well, you can't use this in {{}} because on how writing shit works, so this is a global func instead. Stolen from the tgui-next department
/**
 * Creates an array of values by running each element in collection
 * thru an iteratee function. The iteratee is invoked with three
 * arguments: (value, index|key, collection).
 *
 * If collection is 'null' or 'undefined', it will be returned "as is"
 * without emitting any errors (which can be useful in some cases).
 * converted from ES6 to ES5
 */
var map = function map(iterateeFn) {
	return function (collection) {
		if (collection === null && collection === undefined) {
		  return collection;
		}
		if (Array.isArray(collection)) {
			var result = [];
			for (var i = 0; i < collection.length; i++) {
				result.push(iterateeFn(collection[i], i, collection));
			}
			return result;
		}
		if (typeof collection === 'object') {
			var hasOwnProperty = Object.prototype.hasOwnProperty;
			var result = [];
			for (var _i in collection) {
				if (hasOwnProperty.call(collection, _i)) {
					result.push(iterateeFn(collection[_i], _i, collection));
				}
			}
			return result;
		}
		throw new Error('map() can\'t iterate on type ' + (typeof collection));
	};
};

var radiomap = function(JSONobj){ //will i clean this up? nope, gonna port tgui-next-3.0 soon&trade;
	var notnice = ""
	map(function(K, V){
		var buttonpart = '<div unselectable="on" style="text-select:none;" class="link linkActive ' + V + '" data-href="' + NanoUtility.generateHref({'channel': V}) + '">' + (K ? "On" : "Off") + '</div>';
		var dat = "<div class=\"item\"><div class=\"itemLabel\">";
		dat += V.toTitleCase()
		dat += "</div><div class=\"itemContent\">";
		dat += buttonpart;
		dat += "</div></div>";
		notnice += dat;
	})(JSONobj);
	return notnice
}
