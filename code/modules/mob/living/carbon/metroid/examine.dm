/mob/living/carbon/slime/examine(mob/user)
	. = ..()
	if (src.stat == DEAD)
		. += "<span class='deadsay'>It is limp and unresponsive.</span>\n"
	else
		if (src.getBruteLoss())
			. += "<span class='warning'>"
			if (src.getBruteLoss() < 40)
				. += "It has some punctures in its flesh!"
			else
				. += "<B>It has severe punctures and tears in its flesh!</B>"
			. += "</span>\n"

		switch(powerlevel)

			if(2 to 3)
				. += "It is flickering gently with a little electrical activity.\n"

			if(4 to 5)
				. += "It is glowing gently with moderate levels of electrical activity.\n"

			if(6 to 9)
				. += "<span class='warning'>It is glowing brightly with high levels of electrical activity.</span>\n"

			if(10)
				. += "<span class='warning'><B>It is radiating with massive levels of electrical activity!</B></span>\n"

	. += "*---------*"
	return
