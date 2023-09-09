/datum/material/wood_log
	id = "log"
	name = "log"
	icon_base = 'icons/turf/walls/log.dmi'
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"
	tgui_icon_key = "log"

	// todo: this is all copypasted from wood
	icon_colour = "#9c5930"
	integrity = 50
	wall_stripe_icon = 'icons/turf/walls/wood_wall_stripe.dmi'
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
	table_icon_base = "wood"

/datum/material/wood_log/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "bonfire",
		product = /obj/structure/bonfire,
		cost = 5,
	)

/datum/material/wood_log/sif
	id = "log_sif"
	name = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood_log/hard
	id = "log_hardwood"
	name = MAT_HARDLOG
	icon_colour = "#6f432a"
	stack_type = /obj/item/stack/material/log/hard
