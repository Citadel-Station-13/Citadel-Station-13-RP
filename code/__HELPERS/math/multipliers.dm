/**
 * multiplied effect of an effect multiplier based on '1' being default
 */
/proc/multiply_effect_multiplier(multiplier, multiply_by)
	if(multiply_by < 0)
		multiply_by = -multiply_by
		multiplier = -multiplier
	if(multiplier > 0)
		return multiplier ** multiply_by
	else
		return -((-multiplier) ** multiply_by)
