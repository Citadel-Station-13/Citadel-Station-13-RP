/datum/prototype/material/wood_log
	id = "log"
	name = "log"
	icon_base = 'icons/turf/walls/wood_wall.dmi' // TODO: make a log wall sprites
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"
	tgui_icon_key = "log"

	// todo: this is all copypasted from wood
	icon_colour = "#9c5930"
	wall_stripe_icon = 'icons/turf/walls/wood_wall_stripe.dmi'
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	table_icon_base = "wood"

	sound_melee_brute = 'sound/effects/woodcutting.ogg'

	relative_integrity = 0.8
	weight_multiplier = 1
	density = 8 * 0.4
	relative_conductivity = 0.1
	relative_permeability = 0.05
	relative_reactivity = 1.5
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_VULNERABLE

	worth = 5

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/wood_log/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "bonfire",
		product = /obj/structure/bonfire,
		cost = 5,
	)

/datum/prototype/material/wood_log/sif
	id = "log_sif"
	name = MAT_SIFLOG
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/prototype/material/wood_log/hard
	id = "log_hardwood"
	name = MAT_HARDLOG
	icon_colour = "#6f432a"
	stack_type = /obj/item/stack/material/log/hard

/datum/prototype/material/wood_log/ironwood
	id = "log_ironwood"
	name = MAT_IRONLOG
	icon_colour = "#5C5454"
	sheet_singular_name = "log"
	stack_type = /obj/item/stack/material/log/ironwood

	relative_integrity = 0.9
	weight_multiplier = 0.8
	density = 8 * 0.8
	relative_conductivity = 0.1
	relative_permeability = 0.05
	relative_reactivity = 1 //Not quite as reactive as regular wood
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_NONE
