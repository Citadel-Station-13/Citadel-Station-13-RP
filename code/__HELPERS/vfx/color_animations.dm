/**
 * shifts something between one color and another
 * you can choose easing
 * color should be rgb or rgba, or matrices
 */
/proc/animate_color_shift(atom/A, color1 = "#ffffff", color2 = "#000000", time1 = 1 SECONDS, time2 = 1 SECONDS, easing = LINEAR_EASING, loop = -1)
	var/c1
	var/c2
	if(!islist(color1))
		c1 = color1
		c2 = color2
	else
		// assume matrix
		c1 = color1
		c2 = color2
	animate(A, color = c1, easing = easing, time = 1080 * 0.5, loop = -1)
	animate(A, color = c2, easing = easing, time = 1080 * 0.5)
