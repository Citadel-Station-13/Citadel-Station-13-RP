/mob/living/silicon/pai/examine(mob/user)
	. = ..()
	. += "A personal AI in holochassis mode. Its master ID string seems to be [master]."

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += "<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)
			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"

	var/vor = attempt_vr(src,"examine_bellies",args) //VOREStation Edit
	if(vor)
		. += vor
	// VOREStation Edit: Start
	if(ooc_notes)
		. += "<span class='deptradio'>OOC Notes:</span> <a href='?src=[REF(src)];ooc_notes=1'>\[View\]</a>"
	// VOREStation Edit: End

	if(print_flavor_text())
		. += "[print_flavor_text()]"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "It is [pose]"
