/mob/living/silicon/pai/examine(mob/user)
	. = ..()

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	. += "\nIt appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)		. += "\n<span class='warning'>It doesn't seem to be responding.</span>\n"
		if(DEAD)			. += "\n<span class='deadsay'>It looks completely unsalvageable.</span>\n"
	. += attempt_vr(src,"examine_bellies",args) //VOREStation Edit

	// VOREStation Edit: Start
	if(ooc_notes)
		. += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>\n"
	// VOREStation Edit: End

	. += "\n*---------*"

	if(print_flavor_text()) . += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "\nIt is [pose]"
