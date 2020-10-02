//color formats
/proc/rgb2hsl(red, green, blue)
	red /= 255;green /= 255;blue /= 255;
	var/max = max(red,green,blue)
	var/min = min(red,green,blue)
	var/range = max-min

	var/hue=0;var/saturation=0;var/lightness=0;
	lightness = (max + min)/2
	if(range != 0)
		if(lightness < 0.5)
			saturation = range/(max+min)
		else
			saturation = range/(2-max-min)

		var/dred = ((max-red)/(6*max)) + 0.5
		var/dgreen = ((max-green)/(6*max)) + 0.5
		var/dblue = ((max-blue)/(6*max)) + 0.5

		if(max==red)
			hue = dblue - dgreen
		else if(max==green)
			hue = dred - dblue + (1/3)
		else
			hue = dgreen - dred + (2/3)
		if(hue < 0)
			hue++
		else if(hue > 1)
			hue--

	return list(hue, saturation, lightness)

/proc/hsl2rgb(hue, saturation, lightness)
	var/red;var/green;var/blue;
	if(saturation == 0)
		red = lightness * 255
		green = red
		blue = red
	else
		var/a;var/b;
		if(lightness < 0.5)
			b = lightness*(1+saturation)
		else
			b = (lightness+saturation) - (saturation*lightness)
		a = 2*lightness - b

		red = round(255 * hue2rgb(a, b, hue+(1/3)), 1)
		green = round(255 * hue2rgb(a, b, hue), 1)
		blue = round(255 * hue2rgb(a, b, hue-(1/3)), 1)

	return list(red, green, blue)

/proc/hue2rgb(a, b, hue)
	if(hue < 0)
		hue++
	else if(hue > 1)
		hue--
	if(6*hue < 1)
		return (a+(b-a)*6*hue)
	if(2*hue < 1)
		return b
	if(3*hue < 2)
		return (a+(b-a)*((2/3)-hue)*6)
	return a

//adapted from http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
/proc/heat2color(temp)
	return rgb(heat2color_r(temp), heat2color_g(temp), heat2color_b(temp))

/proc/heat2color_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/proc/heat2color_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221685293 * ((temp - 60) ** -0.075148492)))

/proc/heat2color_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))

/proc/color2hex(color)	//web colors
	if(!color)
		return COLOR_BLACK

	switch(color)
		if("white")
			return COLOR_WHITE
		if("black")
			return COLOR_BLACK
		if("gray")
			return COLOR_GRAY
		if("brown")
			return "#A52A2A"
		if("red")
			return COLOR_RED
		if("darkred")
			return "#8B0000"
		if("crimson")
			return "#DC143C"
		if("orange")
			return "#FFA500"
		if("yellow")
			return COLOR_YELLOW
		if("green")
			return COLOR_GREEN
		if("lime")
			return COLOR_LIME
		if("darkgreen")
			return "#006400"
		if("cyan")
			return COLOR_CYAN
		if("blue")
			return COLOR_BLUE
		if("navy")
			return COLOR_NAVY
		if("teal")
			return COLOR_TEAL
		if("purple")
			return COLOR_PURPLE
		if("indigo")
			return "#4B0082"
		else
			return COLOR_WHITE

//assumes format #RRGGBB #rrggbb
/proc/color_hex2num(A)
	if(!A || length(A) != length_char(A))
		return FALSE
	var/R = hex2num(copytext(A, 2, 4))
	var/G = hex2num(copytext(A, 4, 6))
	var/B = hex2num(copytext(A, 6, 8))
	return R+G+B

//word of warning: using a matrix like this as a color value will simplify it back to a string after being set
/proc/color_hex2color_matrix(string)
	var/length = length(string)
	if((length != 7 && length != 9) || length != length_char(string))
		return color_matrix_identity()
	var/r = hex2num(copytext(string, 2, 4))/255
	var/g = hex2num(copytext(string, 4, 6))/255
	var/b = hex2num(copytext(string, 6, 8))/255
	var/a = 1
	if(length == 9)
		a = hex2num(copytext(string, 8, 10))/255
	if(!isnum(r) || !isnum(g) || !isnum(b) || !isnum(a))
		return color_matrix_identity()
	return list(r,0,0,0, 0,g,0,0, 0,0,b,0, 0,0,0,a, 0,0,0,0)

//will drop all values not on the diagonal
/proc/color_matrix2color_hex(list/the_matrix)
	if(!istype(the_matrix) || the_matrix.len != 20)
		return "#ffffffff"
	return rgb(the_matrix[1]*255, the_matrix[6]*255, the_matrix[11]*255, the_matrix[16]*255)
