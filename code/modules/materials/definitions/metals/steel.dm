/datum/material/steel
	id = "steel"
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#666666"
	table_icon_base = "metal"
	tgui_icon_key = "metal"

/datum/material/steel/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "dark office chair",
		product = /obj/structure/bed/chair/office/dark,
		cost = 5,
		category = "office chairs",
	)
	. += create_stack_recipe_datum(
		name = "light office chair",
		product = /obj/structure/bed/chair/office/light,
		cost = 5,
		category = "office chairs",
	)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "beige comfy chair", product = /obj/structure/bed/chair/comfy/beige)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "black comfy chair", product = /obj/structure/bed/chair/comfy/black)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "brown comfy chair", product = /obj/structure/bed/chair/comfy/brown)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "lime comfy chair", product = /obj/structure/bed/chair/comfy/lime)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "teal comfy chair", product = /obj/structure/bed/chair/comfy/teal)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "red comfy chair", product = /obj/structure/bed/chair/comfy/red)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "blue comfy chair", product = /obj/structure/bed/chair/comfy/blue)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "purple comfy chair", product = /obj/structure/bed/chair/comfy/purple)
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "green comfy chair", product = /obj/structure/bed/chair/comfy/green)
	. += create_stack_recipe_datum(
		name = "table frame",
		product = /obj/structure/table,
		time = 1 SECONDS,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "bench frame",
		product = /obj/structure/table/bench,
		time = 1 SECONDS,
		cost = 1,
	)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "standard airlock assembly", product = /obj/structure/door_assembly)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "command airlock assembly", product = /obj/structure/door_assembly/command)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "security airlock assembly", product = /obj/structure/door_assembly/security)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "engi-atmos airlock assembly", product = /obj/structure/door_assembly/engi_atmos)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "engineering airlock assembly", product = /obj/structure/door_assembly/engi)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "mining airlock assembly", product = /obj/structure/door_assembly/mining)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "atmospherics airlock assembly", product = /obj/structure/door_assembly/atmos)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "research airlock assembly", product = /obj/structure/door_assembly/research)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "medical airlock assembly", product = /obj/structure/door_assembly/medical)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "maintenance airlock assembly", product = /obj/structure/door_assembly/maint)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "external airlock assembly", product = /obj/structure/door_assembly/external)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "freezer airlock assembly", product = /obj/structure/door_assembly/freezer)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "airtight airlock assembly", product = /obj/structure/door_assembly/hatch)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "maintenance hatch assembly", product = /obj/structure/door_assembly/hatch/maint)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "high security airlock assembly", product = /obj/structure/door_assembly/high_security)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "voidcraft airlock assembly (horizontal)", product = /obj/structure/door_assembly/voidcraft)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "voidcraft airlock assembly (vertical)", product = /obj/structure/door_assembly/voidcraft/vertical)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "emergency shutter", product = /obj/structure/firedoor_assembly)
	. += create_stack_recipe_datum(category = "airlock assemblies", cost = 4, name = "multi-tile airlock assembly", product = /obj/structure/door_assembly/multi_tile)

/datum/material/steel/hull
	id = "steel_hull"
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_colour = "#666677"

/datum/material/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/steel/holographic
	id = "steel_holo"
	name = "holo" + MAT_STEEL
	display_name = "steel"
	stack_type = null
	shard_type = SHARD_NONE
