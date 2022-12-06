/datum/material/solid/plastic
	name = "plastic"
	stack_type = /obj/item/stack/material/plastic
	legacy_flags = MATERIAL_BRITTLE
	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/datum/material/solid/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/solid/cardboard
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	legacy_flags = MATERIAL_BRITTLE
	integrity = 10
	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	conductive = 0
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	radiation_resistance = 1
	pass_stack_colors = TRUE


/datum/material/solid/flesh
	name = "flesh"
	uid = "solid_flesh"
	display_name = "chunk of flesh"
	sheet_singular_name = "glob"
	sheet_plural_name = "globs"
	color = COLOR_DARK_RED
	// wall_icon = "flesh" //TODO?
	dooropen_noise = 'sound/effects/attackblob.ogg'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	door_icon_base = "fleshclosed"
	texture_layer_icon_state = "meat"
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 1
	integrity = 60
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_NORMAL
	reflectiveness = MAT_VALUE_DULL
	legacy_flags = MATERIAL_PADDING
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)

	sound_manipulate = 'sound/foley/meat1.ogg'
	sound_dropped = 'sound/foley/meat2.ogg'

/datum/material/solid/flesh/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M))
		return 1
	return 0

/datum/material/solid/flesh/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && L.mind.isholy)
		to_chat(M, "<span class = 'notice'>\The [W] shudders under your touch, starting to become porous.</span>")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(do_after(L, 5 SECONDS))
			spawn(2)
				playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
				W.dismantle_wall()
		return 1
	return 0

/datum/material/solid/bone
	name = "bone"
	color = "#e6dfc8"
	wall_icon = 'icons/turf/walls/bone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "fragment"
	sheet_plural_name = "fragments"
	conductive = 0
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)

/datum/material/solid/bone/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && L.mind.isholy)
		to_chat(M, "<span class = 'notice'>\The [W] shudders under your touch, starting to become porous.</span>")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(do_after(L, 5 SECONDS))
			spawn(2)
				playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
				W.dismantle_wall()
		return 1
	return 0

/datum/material/solid/leather
	name = "leather"
	color = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	conductive = 0

/datum/material/solid/leather/generate_recipes(reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	// . += new/datum/stack_recipe/cloak(src)
	// . += new/datum/stack_recipe/shoes(src)
	// . += new/datum/stack_recipe/boots(src)

/datum/material/solid/leather/synth
	name = "synthleather"
	uid = "solid_synthleather"
	color = "#1f1f20"
	ignition_point = T0C+150
	melting_point = T0C+100

/datum/material/solid/leather/lizard
	name = "scaled hide"
	uid = "solid_scaled_hide"
	color = "#434b31"
	integrity = 75
	hardness = MAT_VALUE_FLEXIBLE + 5
	weight = MAT_VALUE_LIGHT
	reflectiveness = MAT_VALUE_SHINY

/datum/material/solid/leather/fur
	name = "tanned pelt"
	uid = "solid_tanned_pelt"

/datum/material/solid/leather/chitin
	name = "treated chitin"
	uid = "solid_treated_chitin"
	integrity = 100
	color = "#5c5a54"
	hardness = MAT_VALUE_HARD
	weight = MAT_VALUE_NORMAL
	// brute_armor = 2
	// wall_support_value = MAT_VALUE_NORMAL


/datum/material/solid/wax
	name = "wax"
	stack_type = /obj/item/stack/material/wax
	color = "#ebe6ac"
	melting_point = T0C+300
	weight = 1
	hardness = 20
	integrity = 100
	pass_stack_colors = TRUE


/datum/material/solid/foam
	name = "foam"
	display_name = "foam"
	use_name = "foam"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	color = "#ff9900"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	conductive = 0


//! Skin
/datum/material/solid/skin
	name = "skin"
	uid = "solid_skin"
	color = "#9e8c72"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	// hidden_from_codex = TRUE
	// construction_difficulty = MAT_VALUE_NORMAL_DIY
	integrity = 50
	hardness = MAT_VALUE_SOFT
	weight = MAT_VALUE_EXTREMELY_LIGHT
	// explosion_resistance = 1
	reflectiveness = MAT_VALUE_DULL
	// wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	// value = 1.2
	// default_solid_form = /obj/item/stack/material/skin

	sound_manipulate = 'sound/foley/meat1.ogg'
	sound_dropped = 'sound/foley/meat2.ogg'

	var/tans_to = /datum/material/solid/leather

/datum/material/solid/skin/generate_recipes(reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	// . += new/datum/stack_recipe/cloak(src)
	// . += new/datum/stack_recipe/shoes(src)

/datum/material/solid/skin/lizard
	name = "lizardskin"
	uid = "solid_lizardskin"
	color = "#626952"
	// tans_to = /datum/material/solid/leather/lizard
	hardness = MAT_VALUE_FLEXIBLE
	weight = MAT_VALUE_VERY_LIGHT
	// exoplanet_rarity = MAT_RARITY_NOWHERE

/datum/material/solid/skin/insect
	name = "chitin"
	uid = "solid_chitin"
	color = "#7a776d"
	// tans_to = /datum/material/solid/leather/chitin
	integrity = 75
	hardness = MAT_VALUE_RIGID
	weight = MAT_VALUE_VERY_LIGHT
	// brute_armor = 2

	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/datum/material/solid/skin/fur
	name = "fur"
	uid = "solid_fur"
	color = "#7a726d"
	tans_to = /datum/material/solid/leather/fur
	default_solid_form = /obj/item/stack/material/skin/pelt
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/datum/material/solid/skin/fur/gray
	uid = "solid_fur_gray"

/datum/material/solid/skin/fur/white
	uid = "solid_fur_white"

/datum/material/solid/skin/fur/orange
	color = COLOR_ORANGE
	uid = "solid_fur_orange"

/datum/material/solid/skin/fur/black
	color = COLOR_GRAY20
	uid = "solid_fur_black"

/datum/material/solid/skin/fur/heavy
	color = COLOR_GUNMETAL
	uid = "solid_fur_heavy"

/datum/material/solid/skin/goat
	color = COLOR_SILVER
	uid = "solid_skin_goat"

/datum/material/solid/skin/cow
	color = COLOR_GRAY40
	uid = "solid_skin_cow"

/datum/material/solid/skin/shark
	name = "sharkskin"
	color = COLOR_PURPLE_GRAY
	uid = "solid_skin_shark"

/datum/material/solid/skin/fish
	color = COLOR_BOTTLE_GREEN
	name = "fishskin"
	uid = "solid_skin_fish"

/datum/material/solid/skin/fish/purple
	color = COLOR_PALE_PURPLE_GRAY
	uid = "solid_skin_carp"

/datum/material/solid/skin/feathers
	name = "feathers"
	uid = "solid_feathers"
	color = COLOR_SILVER
	default_solid_form = /obj/item/stack/material/skin/feathers
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'

/datum/material/solid/skin/feathers/purple
	color = COLOR_PALE_PURPLE_GRAY
	uid = "solid_feathers_purple"

/datum/material/solid/skin/feathers/blue
	color = COLOR_SKY_BLUE
	uid = "solid_feathers_blue"

/datum/material/solid/skin/feathers/green
	color = COLOR_BOTTLE_GREEN
	uid = "solid_feathers_green"

/datum/material/solid/skin/feathers/brown
	color = COLOR_BEASTY_BROWN
	uid = "solid_feathers_brown"

/datum/material/solid/skin/feathers/red
	color = COLOR_RED
	uid = "solid_feathers_red"

/datum/material/solid/skin/feathers/black
	color = COLOR_GRAY15
	uid = "solid_feathers_black"
