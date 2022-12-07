/datum/material/solid/wood
	name = "wood"
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
	wall_blend_icons = list(
		'icons/turf/walls/solid.dmi' = TRUE,
		'icons/turf/walls/stone.dmi' = TRUE,
		'icons/turf/walls/metal.dmi' = TRUE,
	)
	color = WOOD_COLOR_GENERIC
	door_icon_base = "wood"
	texture_layer_icon_state = "woodgrain"

/datum/material/solid/wood/log
	name = "wood log"
	wall_icon = 'icons/turf/walls/logs.dmi'
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

/datum/material/solid/wood/sif
	name = "alien wood"
	stack_type = /obj/item/stack/material/wood/sif
	color = WOOD_COLOR_SIF
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/solid/wood/log/sif
	name = "alien wood log"
	color = WOOD_COLOR_SIF
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/solid/wood/hardwood
	name = "hardwood"
	stack_type = /obj/item/stack/material/wood/hard
	color = WOOD_COLOR_HARD
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	integrity = 85 //a bit stronger than regular wood
	hardness = MAT_VALUE_FLEXIBLE + 20
	weight = MAT_VALUE_RIGID

/datum/material/solid/wood/log/hardwood
	name = "hardwood log"
	color = WOOD_COLOR_HARD
	stack_type = /obj/item/stack/material/log/hard

/datum/material/solid/wood/holographic
	name = "holowood"
	display_name = "wood"
	color = WOOD_COLOR_CHOCOLATE //the very concept of wood should be brown
	stack_type = null
	shard_type = SHARD_NONE
	// exoplanet_rarity = MAT_RARITY_NOWHERE


//! NEW WOODS

/datum/material/solid/wood/mahogany
	name = "mahogany"
	uid = "solid_mahogany"
	adjective_name = "mahogany"
	lore_text = "Mahogany is prized for its beautiful grain and rich colour, and as such is typically used for fine furniture and cabinetry."
	color = WOOD_COLOR_RICH
	// construction_difficulty = MAT_VALUE_HARD_DIY
	// value = 1.6

/datum/material/solid/wood/maple
	name = "maple"
	uid = "solid_maple"
	adjective_name = "maple"
	lore_text = "Owing to its fast growth and ease of working, silver maple is a popular wood for flooring and furniture."
	color = WOOD_COLOR_PALE
	// value = 1.8

/datum/material/solid/wood/ebony
	name = "ebony"
	uid = "solid_ebony"
	adjective_name = "ebony"
	lore_text = "Ebony is the name for a group of dark coloured, extremely dense, and fine grained hardwoods. \
				Despite gene modification to produce larger source trees and ample land to plant them on, \
				genuine ebony remains a luxury for the very wealthy thanks to the price fixing efforts of intergalactic luxuries cartels. \
				Most people will only ever touch ebony in small items, such as chess pieces, or the accent pieces of a fine musical instrument."
	color = WOOD_COLOR_BLACK
	weight = MAT_VALUE_HEAVY
	integrity = 100
	// construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	// value = 1.8

/datum/material/solid/wood/walnut
	name = "walnut"
	uid = "solid_walnut"
	adjective_name = "walnut"
	lore_text = "Walnut is a dense hardwood that polishes to a very fine finish. \
				Walnut is especially favoured for construction of figurines (where it contrasts with lighter coloured woods) and tables. \
				The ultimate aspiration of many professionals is an office with a vintage walnut desk, the bigger and heavier the better."
	color = WOOD_COLOR_CHOCOLATE
	weight = MAT_VALUE_NORMAL
	// construction_difficulty = MAT_VALUE_HARD_DIY

/datum/material/solid/wood/bamboo
	name = "bamboo"
	uid = "solid_bamboo"
	liquid_name = "bamboo pulp"
	adjective_name = "bamboo"
	lore_text = "Bamboo is a fast-growing grass which can be used similar to wood after processing. Due to its swift growth \
				and high strength, various species of bamboo area common building materials in developing societies."
	color = WOOD_COLOR_PALE2
	weight = MAT_VALUE_VERY_LIGHT
	hardness = MAT_VALUE_RIGID

/datum/material/solid/wood/yew
	name = "yew"
	uid = "solid_yew"
	adjective_name = "yew"
	lore_text = "Although favoured in days past for the construction of bows, yew has a multitude of uses, including medicine. The yew \
				tree can live for nearly a thousand years thanks to its natural disease resistance."
	color = WOOD_COLOR_YELLOW
	dissolves_into = list(
		/datum/material/solid/carbon = 0.6,
		// /datum/material/liquid/water = 0.3,
		// /datum/material/liquid/heartstopper = 0.1,
	)
	// value = 1.8
