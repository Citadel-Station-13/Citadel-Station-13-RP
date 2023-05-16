/mob/living/silicon/robot/examine(mob/user)
	. = list("<span class='info'>This is [icon2html(src, user)] \a <EM>[src]</EM>, a [src.module.name] unit!")
	if(desc)
		. += "[desc]"

	var/obj/act_module = get_active_held_item()
	if(act_module)
		. += "It is holding [icon2html(act_module, user)] \a [act_module]."
	// var/effects_exam = status_effect_examines()
	// if(!isnull(effects_exam))
	// 	. += effects_exam
	if (getBruteLoss())
		if (getBruteLoss() < maxHealth*0.5)
			. += SPAN_WARNING("It looks slightly dented.")
		else
			. += SPAN_DANGER("It looks severely dented!")
	if (getFireLoss() || getToxLoss())
		var/overall_fireloss = getFireLoss() + getToxLoss()
		if (overall_fireloss < maxHealth * 0.5)
			. += SPAN_WARNING("It looks slightly charred.")
		else
			. += SPAN_DANGER("It looks severely burnt and heat-warped!")
	if (health < -maxHealth*0.5)
		. += SPAN_WARNING("It looks barely operational.")
	if (fire_stacks < 0)
		. += SPAN_WARNING("It's covered in water.")
	else if (fire_stacks > 0)
		. += SPAN_WARNING("It's coated in something flammable.")

	if(opened)
		. += SPAN_WARNING("Its cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += "Its cover is closed[locked ? "" : ", and looks unlocked"]."

	if(cell && cell.charge <= 0)
		. += SPAN_WARNING("Its battery indicator is blinking red!")

	// if(is_servant_of_ratvar(src) && get_dist(user, src) <= 1 && !stat) //To counter pseudo-stealth by using headlamps
	// 	. += SPAN_WARNING("Its eyes are glowing a blazing yellow!")

	switch(stat)
		if(CONSCIOUS)
			if(shell)
				. += "It appears to be an [deployed ? "active" : "empty"] AI shell."
			else if(!client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += SPAN_WARNING("It doesn't seem to be responding.")
		if(DEAD)
			. += SPAN_DEADSAY("It looks like its system is corrupted and requires a reset.")

	. += attempt_vr(src,"examine_bellies_borg",args)
	if(ooc_notes)
		. += SPAN_BOLDNOTICE("\nOOC Notes: <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>")

	if(showvoreprefs && ckey) //ckey so non-controlled mobs don't display it.
		. += SPAN_BOLDNOTICE("<a href='?src=\ref[src];vore_prefs=1'>\[Mechanical Vore Preferences\]</a>")

	if(print_flavor_text())
		. += "\n[print_flavor_text()]\n"

	if(pose)
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "\nIt is [pose]"

	if(laws && isobserver(user))
		user.showLaws(src)

	if(LAZYLEN(.) > 1)
		.[2] = "<hr>[.[2]]"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, usr, .)
