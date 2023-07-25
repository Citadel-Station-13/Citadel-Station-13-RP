/datum/material/diona
	id = "biomass_diona"
	name = "biomass"
	icon_colour = null
	stack_type = null
	icon_base = 'icons/turf/walls/diona.dmi'
	icon_reinf = null

	relative_integrity = 2
	relative_density = 0.8
	relative_weight = 1
	relative_conductivity = 0.2
	relative_permeability = 0.5
	relative_reactivity = 0.8
	regex_this_hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_LOW // they're half-telepaths anyways

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)
