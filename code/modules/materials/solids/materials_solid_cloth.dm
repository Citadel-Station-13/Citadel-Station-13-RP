//! Cloth
/datum/material/solid/cloth
	name = "cotton"
	uid = "solid_cotton"
	use_name = "cotton"
	color = "#ffffff"

	door_icon_base = "wood"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	ignition_point = T0C+232
	melting_point = T0C+300
	legacy_flags = MATERIAL_PADDING

	protectiveness = 1 // 4%
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	conductive = 0
	pass_stack_colors = TRUE

	// exoplanet_rarity = MAT_RARITY_NOWHERE
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/datum/material/solid/cloth/yellow
	name = "yellow"
	uid = "solid_cotton_yellow"
	use_name = "yellow cloth"
	color = "#FFBF00"

/datum/material/solid/cloth/teal
	name = "teal"
	uid = "solid_cotton_teal"
	use_name = "teal cloth"
	color = "#00E1FF"

/datum/material/solid/cloth/black
	name = "black"
	uid = "solid_cotton_black"
	use_name = "black cloth"
	color = "#505050"

/datum/material/solid/cloth/green
	name = "green"
	uid = "solid_cotton_green"
	use_name = "green cloth"
	color = "#B7F27D"

/datum/material/solid/cloth/purple
	name = "purple"
	uid = "solid_cotton_purple"
	use_name = "purple cloth"
	color = "#9933FF"

/datum/material/solid/cloth/blue
	name = "blue"
	uid = "solid_cotton_blue"
	use_name = "blue cloth"
	color = "#46698C"

/datum/material/solid/cloth/beige
	name = "beige"
	uid = "solid_cotton_beige"
	use_name = "beige cloth"
	color = "#CEB689"

/datum/material/solid/cloth/green
	name = "green"
	uid = "solid_cotton_green"
	use_name = "green cloth"
	color = "#B7F27D"

/datum/material/solid/cloth/lime
	name = "lime"
	uid = "solid_cotton_lime"
	use_name = "lime cloth"
	color = "#62E36C"

/datum/material/solid/cloth/red
	name = "red"
	uid = "solid_cotton_red"
	use_name = "red cloth"
	color = "#9D2300"

/datum/material/solid/cloth/fancyblack
	name = "fancyblack"
	uid = "solid_cotton_fancyblack"
	// wall_icon = "fancyblack"  // TODO?
	color = "#FFFFFF"


//! Carpet

/datum/material/solid/carpet
	name = "red"
	uid = "solid_carpet"
	use_name = "red upholstery"
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	color = "#9D2300"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	// construction_difficulty = MAT_VALUE_NORMAL_DIY
	reflectiveness = MAT_VALUE_DULL
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	protectiveness = 1 // 4%
	default_solid_form = /obj/item/stack/material/bolt
	// exoplanet_rarity = MAT_RARITY_NOWHERE

	// exoplanet_rarity = MAT_RARITY_NOWHERE
	// hidden_from_codex = TRUE
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
