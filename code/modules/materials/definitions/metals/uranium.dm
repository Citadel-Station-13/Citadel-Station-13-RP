/datum/material/uranium
	id = "uranium"
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#007A00"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	tgui_icon_key = "uranium"

	relative_integrity = 1.2
	relative_weight = 1
	relative_density = 2.25
	relative_conductivity = 1.5
	relative_permeability = 0
	relative_reactivity = 0.05
	regex_this_hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_HIGH
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

	material_traits = list(
		/datum/material_trait/radioactive{
			strength = 10;
		},
	)
