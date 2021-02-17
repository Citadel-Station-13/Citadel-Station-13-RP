/mob/living/silicon/robot/examine(mob/user)
	. = ..()
	. += "<span class='warning'>"
	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			. += "It looks slightly dented.\n"
		else
			. += "<B>It looks severely dented!</B>\n"
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			. += "It looks slightly charred.\n"
		else
			. += "<B>It looks severely burnt and heat-warped!</B>\n"
	. += "</span>"

	if(opened)
		. += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>\n"
	else
		. += "Its cover is closed.\n"

	if(!has_power)
		. += "<span class='warning'>It appears to be running on backup power.</span>\n"

	switch(src.stat)
		if(CONSCIOUS)
			if(shell)
				. += "It appears to be an [deployed ? "active" : "empty"] AI shell.\n"
			else if(!src.client)
				. += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)		. += "<span class='warning'>It doesn't seem to be responding.</span>\n"
		if(DEAD)			. += "<span class='deadsay'>It looks completely unsalvageable.</span>\n"
	. += attempt_vr(src,"examine_bellies_borg",args) //VOREStation Edit

	// VOREStation Edit: Start
	if(ooc_notes)
		. += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>\n"
	// VOREStation Edit: End

	. += "*---------*"

	if(print_flavor_text()) . += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "\nIt is [pose]"

	. = ..()
	user.showLaws(src)
	return
