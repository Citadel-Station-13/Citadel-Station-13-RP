/mob/living/silicon/pai/examine(mob/user, dist)
	. = ..()

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)
				. += span_notice("It appears to be in stand-by mode.") //afk
		if(UNCONSCIOUS)
			. += span_warning("It doesn't seem to be responding.")
		if(DEAD)
			. += span_deadsay("It looks completely unsalvageable.")
