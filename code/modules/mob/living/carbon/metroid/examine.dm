/mob/living/carbon/slime/examine(mob/user)
	. = list("<span class='info'>*---------*\nThis is [icon2html(src, user)] \a <EM>[src]</EM>!")
	if (src.stat == DEAD)
		. += "<span class='deadsay'>It is limp and unresponsive.</span>"
	else
		if (stat == UNCONSCIOUS) // Slime stasis
			. += "<span class='deadsay'>It appears to be alive but unresponsive.</span>"
		if (getBruteLoss())
			if (getBruteLoss() < 40)
				. += "<span class='warning'>It has some punctures in its flesh!"
			else
				. += "<span class='danger'>It has severe punctures and tears in its flesh!</span>"

		switch(powerlevel)
			if(2 to 3)
				. += "It is flickering gently with a little electrical activity."

			if(4 to 5)
				. += "It is glowing gently with moderate levels of electrical activity."

			if(6 to 9)
				. += "<span class='warning'>It is glowing brightly with high levels of electrical activity.</span>"

			if(10)
				. += "<span class='warning'><B>It is radiating with massive levels of electrical activity!</B></span>"

	. += "*---------*</span>"
