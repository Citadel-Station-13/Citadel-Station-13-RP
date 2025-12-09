/mob/proc/init_typing_indicator(indicator)
	if(!indicator)
		indicator = "[speech_bubble_appearance()]_typing"
	if(typing_indicator)
		cut_overlay(typing_indicator, TRUE)
	typing = FALSE
	typing_indicator = mutable_appearance('icons/mob/talk_vr.dmi', indicator, FLOAT_LAYER)
	typing_indicator.appearance_flags |= RESET_COLOR | PIXEL_SCALE

/mob/proc/set_typing_indicator(state)
	if(!state)
		if(!typing)
			return
		cut_overlay(typing_indicator, TRUE)
		typing = FALSE
	else
		if(typing)
			return
		if(!typing_indicator)
			init_typing_indicator()
		add_overlay(typing_indicator, TRUE)
		typing = TRUE
