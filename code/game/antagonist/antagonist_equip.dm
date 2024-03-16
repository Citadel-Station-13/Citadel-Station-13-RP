/datum/antagonist/proc/equip(mob/living/carbon/human/player)

	if(!istype(player))
		return 0

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		player.delete_inventory(TRUE, TRUE)
	return 1

/datum/antagonist/proc/unequip(mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1
