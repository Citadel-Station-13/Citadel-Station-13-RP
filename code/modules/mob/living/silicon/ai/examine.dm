/mob/living/silicon/ai/examine(mob/user)
	. = list("<span class='info'>This is [icon2html(src, user)] <EM>[src]</EM>!")

	if (src.stat == DEAD)
		. += SPAN_DEADSAY("It appears to be powered-down.")
	else
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				. += SPAN_WARNING("It looks slightly dented.")
			else
				. += SPAN_DANGER("It looks severely dented!")
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				. += SPAN_WARNING("It looks slightly charred.")
			else
				. += SPAN_DANGER("Its casing is melted and heat-warped!")

		if (src.getOxyLoss() && (aiRestorePowerRoutine != 0 && !APU_power))
			if (src.getOxyLoss() > 175)
				. += SPAN_DANGER("It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning!")
			else if(src.getOxyLoss() > 100)
				. += SPAN_WARNING("It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.")
			else
				. += SPAN_WARNING("It seems to be running on backup power.")

		if (src.stat == UNCONSCIOUS)
			. += SPAN_NOTICE("It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".")
		else if (!client)
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem...\n"

		if(deployed_shell)
			. += SPAN_NOTICE("The wireless networking light is blinking.")

	if(hardware && (hardware.owner == src))
		. += "\n"
		. += hardware.get_examine_desc()

	if(LAZYLEN(.) > 1)
		.[2] = "<hr>[.[2]]"

	. += ..()
