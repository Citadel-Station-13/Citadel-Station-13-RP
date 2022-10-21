/**
 * shifts something between one color and another
 * you can choose easing
 * color should be rgb or rgba, or matrices
 */
/proc/animate_color_shift(atom/A, color1 = "#ffffff", color2 = "#000000", time1 = 1 SECONDS, time2 = 1 SECONDS, easing = LINEAR_EASING, loop = -1)
	var/original_color
	var/target_color
	if(!islist(color1))
		original_color = color1
		target_color = color2
	else
		// assume matrix
		original_color = color1
		target_color = color2
	animate(A, color = original_color, easing = easing, time = 1080 * 0.5, loop = -1)
	animate(A, color = target_color, easing = easing, time = 1080 * 0.5)
