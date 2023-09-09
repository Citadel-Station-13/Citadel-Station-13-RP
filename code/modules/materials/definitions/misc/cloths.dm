/datum/material/cloth //todo
	id = "cloth"
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	stack_type = /obj/item/stack/material/cloth
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	pass_stack_colors = TRUE

	relative_integrity = 0.25
	relative_density = 0.2
	relative_conductivity = 0
	relative_permeability = 0.9
	relative_reactivity = 2
	regex_this_hardness = MATERIAL_RESISTANCE_VERY_VULNERABLE
	toughness = MATERIAL_RESISTANCE_VULNERABLE
	refraction = MATERIAL_RESISTANCE_VERY_VULNERABLE
	absorption = MATERIAL_RESISTANCE_VULNERABLE
	nullification = MATERIAL_RESISTANCE_VULNERABLE

/datum/material/cloth/carpet
	id = "carpet"
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	relative_permeability = 0.7

// This all needs to be OOP'd and use inheritence if its ever used in the future.
/datum/material/cloth/teal
	id = "cloth_teal"
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"

/datum/material/cloth/black
	id = "cloth_black"
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"

/datum/material/cloth/green
	id = "cloth_green"
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"

/datum/material/cloth/puple
	id = "cloth_purple"
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"

/datum/material/cloth/blue
	id = "cloth_blue"
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"

/datum/material/cloth/beige
	id = "cloth_beige"
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"

/datum/material/cloth/lime
	id = "cloth_lime"
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
