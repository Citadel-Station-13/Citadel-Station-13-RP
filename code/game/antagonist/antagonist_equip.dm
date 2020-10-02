/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)

	if(!istype(player))
		return FALSE

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			player.drop_from_inventory(thing)
			if(thing.loc != player)
				qdel(thing)
	return 1

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return FALSE
	return 1
