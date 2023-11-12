/datum/material/phoron
	id = MAT_PHORON
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"

	relative_integrity = 0.5
	weight_multiplier = 0.7
	density = 8 * 3
	relative_conductivity = 0.1
	relative_permeability = 0
	relative_reactivity = 4.25
	hardness = MATERIAL_RESISTANCE_NONE
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_HIGH
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_MODERATE

// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/*
/datum/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(/datum/gas/phoron, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
*/

/datum/material/phoron/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "scientist statue", product = /obj/structure/statue/phoron/scientist, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "xenomorph statue", product = /obj/structure/statue/phoron/xeno, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "phoron floor tiles", product = /obj/item/stack/tile/phoron, amount = 4)
