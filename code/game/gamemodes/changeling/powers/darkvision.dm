/datum/power/changeling/darksight
	name = "Dark Sight"
	desc = "We change the composition of our eyes, banishing the shadows from our vision."
	helptext = "We will be able to see in the dark."
	ability_icon_state = "ling_augmented_eyesight"
	genomecost = 0
	verbpath = /mob/proc/changeling_darksight

/datum/darksight/augmenting/changeling
	hard_alpha = 0

/mob/proc/changeling_darksight()
	set category = "Changeling"
	set name = "Toggle Darkvision"
	set desc = "We are able see in the dark."

	var/datum/changeling/changeling = changeling_power(0,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0

	var/now
	if(has_darksight_modifier(/datum/darksight/augmenting/changeling))
		now = FALSE
		remove_darksight_modifier(/datum/darksight/augmenting/changeling)
	else
		now = TRUE
		add_darksight_modifier(/datum/darksight/augmenting/changeling)
	to_chat(src,"You [now ? "now" : "no longer"] see darkness.")

	return 0
