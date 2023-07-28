/datum/material/marble
	id = "marble"
	name = "marble"
	icon_colour = "#AAAAAA"
	stack_type = /obj/item/stack/material/marble
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	shard_type = SHARD_STONE_PIECE
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	tgui_icon_key = "marble"

	relative_integrity = 0.7
	relative_weight = 4
	relative_density = 1
	relative_conductivity = 0
	relative_permeability = 0.05
	relative_reactivity = 0.4
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_VULNERABLE
