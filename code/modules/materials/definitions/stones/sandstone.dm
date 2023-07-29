/datum/material/sandstone
	id = "sandstone"
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	tgui_icon_key = "sandstone"

	relative_integrity = 0.7
	relative_weight = 4
	relative_density = 0.7
	relative_conductivity = 0
	relative_permeability = 0.05
	relative_reactivity = 0.4
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_VULNERABLE
