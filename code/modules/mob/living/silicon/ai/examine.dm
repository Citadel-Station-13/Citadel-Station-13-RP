/mob/living/silicon/ai/examine(mob/user)
	. = ..()

	if (src.stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		. += "<span class='warning'>"
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				. += "It looks slightly dented.\n"
			else
				. += "<B>It looks severely dented!</B>\n"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				. += "It looks slightly charred.\n"
			else
				. += "<B>Its casing is melted and heat-warped!</B>\n"
		if (src.getOxyLoss() && (aiRestorePowerRoutine != 0 && !APU_power))
			if (src.getOxyLoss() > 175)
				. += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(src.getOxyLoss() > 100)
				. += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>\n"
			else
				. += "It seems to be running on backup power.\n"

		if (src.stat == UNCONSCIOUS)
			. += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		. += "</span>"
		if(deployed_shell)
			. += "The wireless networking light is blinking.\n"
	. += "*---------*"
	if(hardware && (hardware.owner == src))
		. += "<br>"
		. += hardware.get_examine_desc()
	user.showLaws(src)
	return

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/observer/dead/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
