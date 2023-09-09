/datum/material/wood_plank
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
	table_icon_base = "wood"
	tgui_icon_key = "plank"

/datum/material/wood_plank/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "coffin",
		product = /obj/structure/closet/coffin,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "wooden chair",
		product = /obj/structure/bed/chair/wood,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "crossbow frame",
		product = /obj/item/crossbowframe,
		cost = 5,
	)

/datum/material/wood_plank/special_recipes()
	var/list/recipes = list()
	recipes += create_stack_recipe_datum(
		name = "beehive assembly",
		product = /obj/item/beehive_assembly,
		cost = 4,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "beehive frame",
		product = /obj/item/honey_frame,
		cost = 1,
	)
	recipes += create_stack_recipe_datum(
		name = "book shelf",
		product = /obj/structure/bookcase,
		cost = 5,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "noticeboard frame",
		product = /obj/item/frame/noticeboard,
		cost = 4,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "wooden bucket",
		product = /obj/item/reagent_containers/glass/bucket/wood,
		cost = 2,
	)
	recipes += create_stack_recipe_datum(
		name = "coilgun stock",
		product = /obj/item/coilgun_assembly,
		cost = 5,
		time = 3 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "drying rack",
		product = /obj/machinery/smartfridge/drying_rack,
		cost = 10,
		time = 3 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "skateboard assembly",
		product = /obj/item/skateboard_frame,
		cost = 6,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "bokken blade",
		product = /obj/item/bokken_blade,
		cost = 10,
		time = 4 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "bokken hilt",
		product = /obj/item/bokken_hilt,
		cost = 4,
		time = 3 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "wakibokken blade",
		product = /obj/item/wakibokken_blade,
		cost = 8,
		time = 4 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "rifle stock",
		product = /obj/item/weaponcrafting/stock,
		cost = 5,
		time = 4 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "wooden panel",
		product = /obj/structure/window/wooden,
		cost = 1,
	)
	recipes += create_stack_recipe_datum(
		name = "wooden sandals",
		product = /obj/item/clothing/shoes/sandal,
		cost = 1,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "wood circlet",
		product = /obj/item/clothing/head/woodcirclet,
		cost = 1,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "clipboard",
		product = /obj/item/clipboard,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "wood floor tile",
		product = /obj/item/stack/tile/wood,
		cost = 1,
		amount = 4,
	)
	. += create_stack_recipe_datum(
		name = "wood roofing tile",
		product = /obj/item/stack/tile/roofing/wood,
		cost = 3,
		amount = 4,
	)
	return recipes

/datum/material/wood_plank/holographic
	id = "wood_holo"
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/wood_plank/holographic/special_recipes()
	return list()

/datum/material/wood_plank/sif
	id = "wood_sif"
	name = MAT_SIFWOOD
	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/wood_plank/sif/special_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "alien wood floor tile",
		product = /obj/item/stack/tile/wood/sif,
		cost = 1,
		amount = 4,
	)
	// todo: this is shitcode
	for(var/datum/stack_recipe/recipe as anything in .)
		if(recipe.name == "wood floor tile" || recipe.name == "wooden chair")
			. -= recipe

/datum/material/wood_plank/hardwood
	id = "wood_hardwood"
	name = MAT_HARDWOOD
	stack_type = /obj/item/stack/material/wood/hard
	icon_colour = "#42291a"
	icon_base = 'icons/turf/walls/wood_wall.dmi'
	wall_stripe_icon = 'icons/turf/walls/wood_wall_stripe.dmi'
	icon_reinf_directionals = TRUE
	integrity = 65	//a bit stronger than regular wood
	hardness = 20
	weight = 20	//likewise, heavier
	table_icon_base = "stone"

/datum/material/wood_plank/hardwood/special_recipes()
	var/list/recipes = list()
	recipes += create_stack_recipe_datum(
		name = "crossbow frame",
		product = /obj/item/crossbowframe,
		cost = 5,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "coilgun stock",
		product = /obj/item/coilgun_assembly,
		cost = 5,
		time = 2 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "hardwood bokken blade",
		product = /obj/item/bokken_blade/hardwood,
		cost = 10,
		time = 4 SECONDS,
	)
	recipes += create_stack_recipe_datum(
		name = "hardwood wakibokken blade",
		product = /obj/item/wakibokken_blade/hardwood,
		cost = 5,
		time = 4 SECONDS,
	)
	return recipes
