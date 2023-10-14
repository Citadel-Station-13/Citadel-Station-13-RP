/datum/material/supermatter
	id = MAT_SUPERMATTER
	name = "supermatter"
	icon_colour = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	radioactivity = RAD_INTENSITY_MAT_SUPERMATTER
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)

/datum/material/supermatter/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "supermatter shard",
		product = /obj/machinery/power/supermatter/shard,
		cost = 30,
		time = 30 SECONDS,
	)
