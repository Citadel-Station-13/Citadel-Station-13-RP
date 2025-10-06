/datum/prototype/material/supermatter
	id = MAT_SUPERMATTER
	name = "supermatter"
	icon_colour = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	shard_type = SHARD_SHARD
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)

	relative_integrity = 3
	density = 8 * 10
	weight_multiplier = 1
	relative_conductivity = 0
	relative_permeability = 0
	relative_reactivity = 0
	hardness = MATERIAL_RESISTANCE_EXTREME
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_HIGH
	absorption = MATERIAL_RESISTANCE_EXTREME
	nullification = MATERIAL_RESISTANCE_HIGH

	worth = 200 // holy moly!

	// you didn't think you were getting the stats for free now did you
	material_traits = list(
		/datum/prototype/material_trait/radioactive = RAD_INTENSITY_MAT_SUPERMATTER,
		/datum/prototype/material_trait/supermatter,
		/datum/prototype/material_trait/glow = list("power" = 0.75, "range" = 3, "color" = "#ffff00", "sensitivity" = 0.5),
	)

/datum/prototype/material/supermatter/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "supermatter shard",
		product = /obj/machinery/power/supermatter/shard,
		cost = 30,
		time = 30 SECONDS,
	)
