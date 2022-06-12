/mob/living/carbon/slime/examine(mob/user)
	. = list("<span class='info'>This is [icon2html(src, user)] \a <EM>[src]</EM>!")
	if (src.stat == DEAD)
		. += SPAN_DEADSAY("It is limp and unresponsive.<")
	else
		if (stat == UNCONSCIOUS) // Slime stasis
			. += SPAN_DEADSAY("It appears to be alive but unresponsive.")
		if (getBruteLoss())
			if (getBruteLoss() < 40)
				. += SPAN_WARNING("It has some punctures in its flesh!")
			else
				. += SPAN_DANGER("It has severe punctures and tears in its flesh!")

		switch(powerlevel)
			if(2 to 3)
				. += "It is flickering gently with a little electrical activity."

			if(4 to 5)
				. += "It is glowing gently with moderate levels of electrical activity."

			if(6 to 9)
				. += SPAN_WARNING("It is glowing brightly with high levels of electrical activity.")

			if(10)
				. += SPAN_DANGER("It is radiating with massive levels of electrical activity!")

	. += "</span>"
