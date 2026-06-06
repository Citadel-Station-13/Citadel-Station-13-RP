/datum/prototype/material/shell
	id = "shell"
	name = "shell"
	icon_colour = "#BCB7B5"
	stack_type = /obj/item/stack/material/shell
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "shard"
	sheet_plural_name = "shards"
	explosion_resistance = 60
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 7)
	door_icon_base = "stone"
	table_icon_base = "stone"

	relative_integrity = 0.75
	weight_multiplier = 0.75
	density = 8 * 1
	relative_conductivity = 0.1
	relative_permeability = 0.07
	relative_reactivity = 1
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_NONE

	material_constraints = MATERIAL_CONSTRAINT_RIGID
