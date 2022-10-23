/mob/living/silicon/pai/examine(mob/user)
	. = ..()

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)
				. += SPAN_NOTICE("It appears to be in stand-by mode.") //afk
		if(UNCONSCIOUS)
			. += SPAN_WARNING("It doesn't seem to be responding.")
		if(DEAD)
			. += SPAN_DEADSAY("It looks completely unsalvageable.")
