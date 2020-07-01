/mob/living/silicon/ai/examine(mob/user)
	. = list("<span class='info'>*---------*\nThis is [icon2html(src, user)] <EM>[src]</EM>!")
	if (stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>"
	else
		if (getBruteLoss())
			if (getBruteLoss() < 30)
				. += "<span class='warning'>It looks slightly dented.</span>"
			else
				. += "<span class='danger'>It looks severely dented!</span>"
		if (getFireLoss())
			if (getFireLoss() < 30)
				. += "<span class='warning'>It looks slightly charred.</span>"
			else
				. += "<span class='danger'>Its casing is melted and heat-warped!</span>"
		if (getOxyLoss() && (aiRestorePowerRoutine != 0 && !APU_power))
			if (getOxyLoss() > 175)
				. += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(getOxyLoss() > 100)
				. += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>\n"
			else
				. += "It seems to be running on backup power.\n"

		if(deployed_shell)
			. += "The wireless networking light is blinking."
		else if (!client) //hurr durr no malfai thingy !shunted &&
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem..."
	. += "*---------*</span>"

	if(hardware && (hardware.owner == src))
		. += "<br>"
		. += hardware.get_examine_desc()

	// . += ..() this is showlaws when ghost examines
	user.showLaws(src)

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/observer/dead/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
