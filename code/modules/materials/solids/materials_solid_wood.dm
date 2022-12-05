/datum/material/wood
	name = MAT_WOOD
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"

	stack_type = /obj/item/stack/material/wood

	integrity = 75
	shard_type = SHARD_SPLINTER
	shard_can_repair = FALSE // you can't weld splinters back into planks
	hardness = MAT_VALUE_FLEXIBLE + 10
	weight = MAT_VALUE_NORMAL
	protectiveness = 8 // 28%
	conductive = FALSE
	conductivity = 1
	// construction_difficulty = MAT_VALUE_NORMAL_DIY
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	// hitsound = 'sound/effects/woodhit.ogg'

	wall_icon = 'icons/turf/walls/wood.dmi'
	table_icon = 'icons/obj/structures/tables/wood.dmi'
	// wall_blend_icons = list(
	// 	'icons/turf/walls/solid.dmi' = TRUE,
	// 	'icons/turf/walls/stone.dmi' = TRUE,
	// 	'icons/turf/walls/metal.dmi' = TRUE,
	// )
	color = WOOD_COLOR_GENERIC
	door_icon_base = "wood"

/datum/material/wood/log
	name = MAT_LOG
	wall_icon = 'icons/turf/walls/logs.dmi'
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

/datum/material/wood/sif
	name = MAT_SIFWOOD
	stack_type = /obj/item/stack/material/wood/sif
	color = WOOD_COLOR_SIF
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/wood/log/sif
	name = MAT_SIFLOG
	color = WOOD_COLOR_SIF
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood/hardwood
	name = MAT_HARDWOOD
	stack_type = /obj/item/stack/material/wood/hard
	color = WOOD_COLOR_HARD
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	integrity = 85 //a bit stronger than regular wood
	hardness = MAT_VALUE_FLEXIBLE + 20
	weight = MAT_VALUE_RIGID

/datum/material/wood/log/hard
	name = MAT_HARDLOG
	color = WOOD_COLOR_HARD
	stack_type = /obj/item/stack/material/log/hard

/datum/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	color = WOOD_COLOR_CHOCOLATE //the very concept of wood should be brown
	stack_type = null
	shard_type = SHARD_NONE
	// exoplanet_rarity = MAT_RARITY_NOWHERE
