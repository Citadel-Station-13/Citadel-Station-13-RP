/datum/material/wood
	id = "wood"
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#9c5930"
	integrity = 50
	icon_base = 'icons/turf/walls/wood_wall.dmi'
	wall_stripe_icon = 'icons/turf/walls/wood_wall_stripe.dmi'
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	conductive = 0
	conductivity = 1
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	table_icon_base = "wood"
	tgui_icon_key = "plank"
	sound_melee_brute = 'sound/effects/woodcutting.ogg'

	relative_integrity = 0.8
	relative_weight = 1
	relative_density = 0.4
	relative_conductivity = 0.1
	relative_permeability = 0.05
	relative_reactivity = 1.5
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_VULNERABLE

/datum/material/wood/log
	id = "log"
	name = "log"
	icon_base = 'icons/turf/walls/log.dmi'
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"
	tgui_icon_key = "log"

/datum/material/wood/log/sif
	id = "log_sif"
	name = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood/log/hard
	id = "log_hardwood"
	name = MAT_HARDLOG
	icon_colour = "#6f432a"
	stack_type = /obj/item/stack/material/log/hard

/datum/material/wood/holographic
	id = "wood_holo"
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/wood/sif
	id = "wood_sif"
	name = MAT_SIFWOOD
	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/wood/hardwood
	id = "wood_hardwood"
	name = MAT_HARDWOOD
	stack_type = /obj/item/stack/material/wood/hard
	icon_colour = "#42291a"
	icon_base = 'icons/turf/walls/wood_wall.dmi'
	wall_stripe_icon = 'icons/turf/walls/wood_wall_stripe.dmi'
	icon_reinf_directionals = TRUE
	table_icon_base = "stone"

	relative_integrity = 1
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
