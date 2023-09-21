/datum/material/diona
	id = "biomass_diona"
	name = "biomass"
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = 'icons/turf/walls/diona.dmi'
	icon_reinf = null

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)
