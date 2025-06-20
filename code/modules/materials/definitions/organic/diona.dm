/datum/prototype/material/diona
	id = "biomass_diona"
	name = "biomass"
	icon_colour = null
	stack_type = null
	icon_base = 'icons/turf/walls/diona.dmi'
	icon_reinf = null

	relative_integrity = 2
	density = 8 * 0.8
	weight_multiplier = 1
	relative_conductivity = 0.2
	relative_permeability = 0.5
	relative_reactivity = 0.8
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_LOW // they're half-telepaths anyways

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/diona/place_dismantled_product()
	return

/datum/prototype/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)
