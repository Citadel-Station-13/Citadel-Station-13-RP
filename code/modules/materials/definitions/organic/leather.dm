//TODO PLACEHOLDERS:
// todo: wtf are these they need to be subtyped properly and uhh yea
/datum/material/leather
	id = "leather"
	name = "leather"
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2)
	ignition_point = T0C+300
	melting_point = T0C+300

	relative_integrity = 1
	relative_density = 0.5
	relative_weight = 1
	relative_conductivity = 0.25
	relative_permeability = 0.2
	relative_reactivity = 0.3
	regex_this_hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE
