/**
 * Convert random parts of a passed in message to stars
 *
 * * phrase - the string to convert
 * * probability - probability any character doesn't gets changed
 * * max - max characters
 *
 * This proc is dangerously laggy, avoid it or die
 * On another note this is main's but probability is reversed because RP code is stupid.
 */
/proc/stars(phrase, probability = 25, max = 4096)
	if(probability >= 100)
		return phrase
	if(probability <= 0)
		return "************************"
	if(length_char(phrase) > max)
		phrase = copytext_char(phrase, 1, max)
	probability = 100 - probability
	phrase = html_decode(phrase)
	var/leng = length(phrase)
	. = ""
	var/char = ""
	for(var/i = 1, i <= leng, i += length(char))
		char = phrase[i]
		if(char == " " || !prob(probability))
			. += char
		else
			. += "*"
	return sanitize(.)

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3) == 3)
			if(lowertext(newletter)=="o")
				newletter="u"
			if(lowertext(newletter)=="s")
				newletter="ch"
			if(lowertext(newletter)=="a")
				newletter="ah"
			if(lowertext(newletter)=="c")
				newletter="k"
		switch(rand(1,15))
			if(1, 3, 5, 8)
				newletter="[lowertext(newletter)]"
			if(2, 4, 6, 15)
				newletter="[uppertext(newletter)]"
			if(7)
				newletter+="'"
			if(9 to 14)
				newletter = newletter
			// if(9,10)
			// 	newletter="<b>[newletter]</b>"
			// if(11,12)
			// 	newletter="<big>[newletter]</big>"
			// if(13)
			// 	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	var/te = html_decode(n)
	/// Placed before the message. Not really sure what it's for.
	var/t = ""
	/// Length of the entire word.
	n = length(n)
	var/p = null
	/// 1 is the start of any word.
	p = 1

	// While P, which starts at 1 is less or equal to N which is the length.
	while(p <= n)
		// Copies text from a certain distance. In this case, only one letter at a time.
		var/n_letter = copytext(te, p, p + 1)
		if (prob(80) && (ckey(n_letter) in list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")))
			if (prob(10))
				// Replaces the current letter with this instead.
				n_letter = text("[n_letter]-[n_letter]-[n_letter]-[n_letter]")
			else
				if (prob(20))
					n_letter = text("[n_letter]-[n_letter]-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-[n_letter]")
		// Since the above is ran through for each letter, the text just adds up back to the original word.
		t = text("[t][n_letter]")
		/// For each letter p is increased to find where the next letter will be.
		p++
	return sanitize(t)

/**
 * Turn text into complete gibberish!
 *
 * t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added.
 */
/proc/Gibberish(t, p)
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext

/**
 * The difference with stutter is that this proc can stutter more than 1 letter
 * The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
 * It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
 */
/proc/ninjaspeak(n)
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return sanitize(t)
