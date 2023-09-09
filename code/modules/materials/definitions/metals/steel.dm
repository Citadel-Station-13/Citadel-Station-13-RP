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
	. += create_stack_recipe_datum(category = "comfy chairs", cost = 2, name = "purple comfy chair", product = /obj/structure/bed/chair/comfy/purp)
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
	. += create_stack_recipe_datum(
		name = "rack",
		product = /obj/structure/table/rack,
		cost = 1,
		time = 0.5 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "closet",
		product = /obj/structure/closet,
		cost = 2,
		time = 1.5 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "canister",
		product = /obj/machinery/portable_atmospherics/canister,
		cost = 10,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		category = "frames",
		name = "machine frame",
		product = /obj/item/frame,
		cost = 5,
		time = 2 SECONDS,
	)
	. += /datum/stack_recipe/railing
	. += create_stack_recipe_datum(category = "sofas", cost = 1, name = "sofa middle", product = /obj/structure/bed/chair/sofa, exclusitivity = /obj/structure/bed)
	. += create_stack_recipe_datum(category = "sofas", cost = 1, name = "sofa left", product = /obj/structure/bed/chair/sofa/left, exclusitivity = /obj/structure/bed)
	. += create_stack_recipe_datum(category = "sofas", cost = 1, name = "sofa right", product = /obj/structure/bed/chair/sofa/right, exclusitivity = /obj/structure/bed)
	. += create_stack_recipe_datum(category = "sofas", cost = 1, name = "sofa corner", product = /obj/structure/bed/chair/sofa/corner, exclusitivity = /obj/structure/bed)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "light switch frame",
		product = /obj/item/frame/lightswitch,
		cost = 2,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "apc frame",
		product = /obj/item/frame/apc,
		cost = 2,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "mirror frame",
		product = /obj/item/frame/mirror,
		cost = 2,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "light fixture frame",
		product = /obj/item/frame/light,
		cost = 2,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "floor lamp frame",
		product = /obj/machinery/light_construct/flamp,
		cost = 2,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "small light fixture frame",
		product = /obj/item/frame/light/small,
		cost = 1,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "fairy light fixture frame",
		product = /obj/item/frame/light/fairy,
		cost = 1,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "fire extinguisher cabinet frame",
		product = /obj/item/frame/extinguisher_cabinet,
		cost = 2,
	)
	// todo: frame rework
	. += create_stack_recipe_datum(
		category = "frames",
		name = "portable turret frame",
		product = /obj/machinery/porta_turret_construct,
		cost = 5,
		time = 2.5 SECONDS,
	)
	. += create_stack_recipe_datum(category = "teshari nests", cost = 1, name = "small teshari nest", product = /obj/structure/bed/chair/bay/chair/padded/red/smallnest, exclusitivity = /obj/structure/bed)
	. += create_stack_recipe_datum(category = "teshari nests", cost = 1, name = "big teshari nest", product = /obj/structure/bed/chair/bay/chair/padded/red/bignest, exclusitivity = /obj/structure/bed)
	. += create_stack_recipe_datum(
		name = "metal rod",
		product = /obj/item/stack/rods,
		cost = 1,
		amount = 2,
	)
	. += create_stack_recipe_datum(
		name = "floor tiles",
		product = /obj/item/stack/tile/floor,
		cost = 1,
		amount = 4,
	)
	. += create_stack_recipe_datum(
		name = "roofing tiles",
		product = /obj/item/stack/tile/roofing,
		cost = 3,
		amount = 4,
	)
	. += create_stack_recipe_datum(category = "filing cabinets", cost = 4, name = "filing cabinet", product = /obj/structure/filingcabinet, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "filing cabinets", cost = 4, name = "tall filing cabinet", product = /obj/structure/filingcabinet/tall, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "filing cabinets", cost = 4, name = "chest drawer", product = /obj/structure/filingcabinet/chestdrawer, time = 2 SECONDS)
	. += create_stack_recipe_datum(
		name = "dance pole",
		product = /obj/structure/dancepole,
		time = 2 SECONDS,
		cost = 2,
	)
	. += create_stack_recipe_datum(
		name = "IV drip",
		product = /obj/machinery/iv_drip,
		time = 4 SECONDS,
		cost = 4,
	)
	. += create_stack_recipe_datum(
		name = "conveyor switch",
		product = /obj/machinery/conveyor_switch,
		cost = 2,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		category = "weapons",
		product = /obj/item/cannonframe,
		cost = 5,
		time = 2 SECONDS,
		name = "improvised pneumatic cannon frame",
	)
	. += create_stack_recipe_datum(
		category = "weapons",
		product = /obj/item/grenade/chem_grenade,
		name = "grenade casing",
		cost = 2,
	)
	. += create_stack_recipe_datum("category" = "modular computer frames", name = "modular console frame", product = /obj/item/modular_computer/console, time = 2 SECONDS, cost = 10)
	. += create_stack_recipe_datum("category" = "modular computer frames", name = "modular telescreen frame", product = /obj/item/modular_computer/telescreen, time = 2 SECONDS, cost = 5)
	. += create_stack_recipe_datum("category" = "modular computer frames", name = "modular laptop frame", product = /obj/item/modular_computer/laptop, time = 2 SECONDS, cost = 3)
	. += create_stack_recipe_datum("category" = "modular computer frames", name = "modular tablet frame", product = /obj/item/modular_computer/tablet, time = 2 SECONDS, cost = 2)
	. += create_stack_recipe_datum(
		name = "desk bell",
		product = /obj/item/deskbell,
		cost = 2,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "scooter frame",
		product = /obj/item/scooter_frame,
		cost = 5,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "metal coffin",
		product = /obj/structure/closet/coffin/comfy,
		time = 2 SECONDS,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "ladder assembly",
		product = /obj/structure/ladder_assembly,
		cost = 4,
		time = 3 SECONDS,
	)

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
