/datum/material/supermatter
	id = "supermatter"
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
	relative_density = 10
	relative_weight = 1
	relative_conductivity = 0
	relative_permeability = 0
	relative_reactivity = 0
	regex_this_hardness = MATERIAL_RESISTANCE_EXTREME
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_HIGH
	absorption = MATERIAL_RESISTANCE_EXTREME
	nullification = MATERIAL_RESISTANCE_HIGH

	// you didn't think you were getting the stats for free now did you
	material_traits = list(
		/datum/material_trait/radioactive{
			strength = RAD_INTENSITY_MAT_SUPERMATTER;
		},
		/datum/material_trait/supermatter,
		/datum/material_trait/glow{

		},
	)
