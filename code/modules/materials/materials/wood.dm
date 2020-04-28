/datum/material/wood
	id = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#9c5930"
	integrity = 50
	icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	protectiveness = 8 // 28%
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

/datum/material/wood/log
	id = MAT_LOG
	icon_base = "log"
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

/datum/material/wood/log/sif
	id = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood/holographic
	id = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/wood/sif
	id = MAT_SIFWOOD
//	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

