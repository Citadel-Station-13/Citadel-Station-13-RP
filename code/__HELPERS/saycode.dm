// Converts specific characters, like +, |, and _ to formatted output.
/proc/saycode_emphasis(input)
	var/static/regex/italics = regex("\\|(?=\\S)(.+?)(?=\\S)\\|", "g")
	input = replacetext_char(input, italics, "<i>$1</i>")
	var/static/regex/bold = regex("\\+(?=\\S)(.+?)(?=\\S)\\+", "g")
	input = replacetext_char(input, bold, "<b>$1</b>")
	var/static/regex/underline = regex("_(?=\\S)(.+?)(?=\\S)_", "g")
	input = replacetext_char(input, underline, "<u>$1</u>")
	var/static/regex/strikethrough = regex("~~(?=\\S)(.+?)(?=\\S)~~", "g")
	input = replacetext_char(input, strikethrough, "<s>$1</s>")
	return input

// Converts specific characters, like +, |, and _ to.. well nothing output.
/proc/saycode_emphasis_strip(input)
	var/static/regex/italics = regex("\\|(?=\\S)(.*?)(?=\\S)\\|", "g")
	input = replacetext_char(input, italics, "$1")
	var/static/regex/bold = regex("\\+(?=\\S)(.*?)(?=\\S)\\+", "g")
	input = replacetext_char(input, bold, "$1")
	var/static/regex/underline = regex("_(?=\\S)(.*?)(?=\\S)_", "g")
	input = replacetext_char(input, underline, "$1")
	var/static/regex/strikethrough = regex("~~(?=\\S)(.+?)(?=\\S)~~", "g")
	input = replacetext_char(input, strikethrough, "$1")
	return input
