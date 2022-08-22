/datum/mass_persistence_handler/debris
	abstract_type = /datum/mass_persistence_handler/debris

/datum/mass_persistence_handler/debris/trash

#warn just spawns items on tiles, use for everything else

/datum/mass_persistence_handler/debris/dirt

#warn impl - for /obj/effect/debris/cleanable/dirt. store alpha.

/datum/mass_persistence_handler/debris/graffiti

#warn impl - for crayons, store color, state, alpha

/datum/mass_persistence_handler/debris/blood

#warn impl - this is one type for packing
#warn color, then dir for trails, number for droplets, nothing for puddle?

/**
 * collects all debris in the game and sorts them
 *
 * current types:
 * "dirt" - dirt
 * "crayon" - crayon graffiti
 * "trash" - trash objects, use for everything else
 * "blood_trail" - blood trails
 * "blood_puddle" - blood puddles
 * "blood_drips" - blood droplets
 */
/proc/__collect_all_debris()
	. = list()


#warn impl
