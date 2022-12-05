//! THIS IS A TEMPORARY FILE
#warn Bro, finish the repathing.

// Datum definitions follow.

/datum/material/debug
	name = "debugium"
	stack_type = /obj/item/stack/material/debug
	wall_icon = 'icons/turf/walls/debug.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_debug.dmi'
	color = "#FFFFFF"

/obj/item/stack/material/debug
	name = "debugium"
	icon_state = "debugium"
	default_type = "debugium"


/datum/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	color = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"

/datum/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	legacy_flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	color = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)

/datum/material/gold
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	color = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	color = "#EDD12F"

/datum/material/silver
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	color = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

//R-UST port
/datum/material/supermatter
	name = "supermatter"
	color = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	radioactivity = 20
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	wall_icon = 'icons/turf/walls/stone.dmi'
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)

/datum/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	wall_icon = 'icons/turf/walls/stone.dmi'
	color = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/datum/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(/datum/gas/phoron, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
*/

/datum/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	wall_icon = 'icons/turf/walls/stone.dmi'
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	color = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/stone/marble
	name = MAT_MARBLE
	color = "#AAAAAA"
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	bench_icon = 'icons/obj/structures/benches/stone.dmi'
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble


/datum/material/steel
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	wall_icon = 'icons/turf/walls/solid.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#666666"

/datum/material/steel/hull
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	wall_icon = 'icons/turf/walls/hull.dmi'
	texture_layer_icon_state = "mesh"
	color = "#666677"

/datum/material/steel/hull/place_sheet(turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/diona
	name = "biomass"
	color = null
	stack_type = null
	integrity = 600
	wall_icon = 'icons/turf/walls/diona.dmi'
	wall_reinf_icon = null

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)

/datum/material/steel/holographic
	name = "holo" + MAT_STEEL
	display_name = MAT_STEEL
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	wall_icon = 'icons/turf/walls/solid.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14

/datum/material/plasteel/hull
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	color = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)

// Very rare alloy that is reflective, should be used sparingly.
/datum/material/durasteel
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	wall_icon = 'icons/turf/walls/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	color = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT, MAT_DIAMOND = SHEET_MATERIAL_AMOUNT) //shrug

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	name = MAT_DURASTEELHULL
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	color = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)

/datum/material/plasteel/titanium
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	color = "#D1E6E3"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'

/datum/material/plasteel/titanium/hull
	name = MAT_TITANIUMHULL
	stack_type = null
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'

/datum/material/glass
	name = "glass"
	stack_type = /obj/item/stack/material/glass
	legacy_flags = MATERIAL_BRITTLE
	table_icon = 'icons/obj/structures/tables/glass.dmi'
	table_state_reinf = "rglass"
	color = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 30
	weight = 15
	protectiveness = 0 // 0%
	conductive = 0
	conductivity = 1 // Glass shards don't conduct.
	door_icon_base = "stone"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 2, "Windoor" = 2)
	created_window = /obj/structure/window/basic
	created_fulltile_window = /obj/structure/window/basic/full
	rod_product = /obj/item/stack/material/glass/reinforced

/datum/material/glass/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)

	if(!user || !used_stack || !created_window || !created_fulltile_window || !window_options.len)
		return 0

	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>This task is too complex for your clumsy hands.</span>")
		return 1

	var/title = "Sheet-[used_stack.name] ([used_stack.get_amount()] sheet\s left)"
	var/choice = input(title, "What would you like to construct?") as null|anything in window_options
	var/build_path = /obj/structure/windoor_assembly
	var/sheets_needed = window_options[choice]
	if(choice == "Windoor")
		if(is_reinforced())
			build_path = /obj/structure/windoor_assembly/secure
	else if(choice == "Full Window")
		build_path = created_fulltile_window
	else
		build_path = created_window

	if(used_stack.get_amount() < sheets_needed)
		to_chat(user, "<span class='warning'>You need at least [sheets_needed] sheets to build this.</span>")
		return 1

	if(!choice || !used_stack || !user || used_stack.loc != user || user.stat)
		return 1

	var/turf/T = user.loc
	if(!istype(T))
		to_chat(user, "<span class='warning'>You must be standing on open flooring to build a window.</span>")
		return 1

	// Get data for building windows here.
	var/list/possible_directions = GLOB.cardinal.Copy()
	var/window_count = 0
	for (var/obj/structure/window/check_window in user.loc)
		window_count++
		if(check_window.is_fulltile())
			possible_directions -= GLOB.cardinal
		else
			possible_directions -= check_window.dir
	for (var/obj/structure/windoor_assembly/check_assembly in user.loc)
		window_count++
		possible_directions -= check_assembly.dir
	for (var/obj/machinery/door/window/check_windoor in user.loc)
		window_count++
		possible_directions -= check_windoor.dir

	// Get the closest available dir to the user's current facing.
	var/build_dir = SOUTHWEST //Default to southwest for fulltile windows.
	var/failed_to_build

	if(window_count >= 4)
		failed_to_build = 1
	else
		if(choice in list("One Direction","Windoor"))
			if(possible_directions.len)
				for(var/direction in list(user.dir, turn(user.dir,90), turn(user.dir,270), turn(user.dir,180)))
					if(direction in possible_directions)
						build_dir = direction
						break
			else
				failed_to_build = 1
	if(failed_to_build)
		to_chat(user, "<span class='warning'>There is no room in this location.</span>")
		return 1

	// Build the structure and update sheet count etc.
	used_stack.use(sheets_needed)
	new build_path(T, build_dir, 1)
	return 1

/datum/material/glass/proc/is_reinforced()
	return (hardness > 35) //todo

/datum/material/glass/reinforced
	name = "rglass"
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	legacy_flags = MATERIAL_BRITTLE
	color = "#00E1FF"
	opacity = 0.3
	integrity = 100
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT / 2, MAT_GLASS = SHEET_MATERIAL_AMOUNT)
	window_options = list("One Direction" = 1, "Full Window" = 2, "Windoor" = 2)
	created_window = /obj/structure/window/reinforced
	created_fulltile_window = /obj/structure/window/reinforced/full
	wire_product = null
	rod_product = null

/datum/material/glass/phoron
	name = MAT_GLASS_BS
	stack_type = /obj/item/stack/material/glass/phoronglass
	legacy_flags = MATERIAL_BRITTLE
	integrity = 100
	color = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	window_options = list("One Direction" = 1, "Full Window" = 2)
	created_window = /obj/structure/window/phoronbasic
	created_fulltile_window = /obj/structure/window/phoronbasic/full
	wire_product = null
	rod_product = /obj/item/stack/material/glass/phoronrglass

/datum/material/glass/phoron/reinforced
	name = "reinforced borosilicate glass"
	display_name = "reinforced borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronrglass
	stack_origin_tech = list(TECH_MATERIAL = 5)
	composite_material = list() //todo
	window_options = list("One Direction" = 1, "Full Window" = 2)
	created_window = /obj/structure/window/phoronreinforced
	created_fulltile_window = /obj/structure/window/phoronreinforced/full
	hardness = 40
	weight = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list() //todo
	rod_product = null

/datum/material/plastic
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

/datum/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/material/osmium
	color = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductivity = 100

/datum/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	color = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	color = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	color = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1

/datum/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/material/platinum
	color = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	color = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/lead
	name = MAT_LEAD
	stack_type = /obj/item/stack/material/lead
	color = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.

// Particle Smasher and other exotic materials.

/datum/material/verdantium
	name = MAT_VERDANTIUM
	stack_type = /obj/item/stack/material/verdantium
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	color = "#4FE95A"
	integrity = 80
	protectiveness = 15
	weight = 15
	hardness = 30
	shard_type = SHARD_SHARD
	negation = 15
	conductivity = 60
	reflectivity = 0.3
	radiation_resistance = 5
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

//exotic wonder material
/datum/material/morphium
	name = MAT_MORPHIUM
	stack_type = /obj/item/stack/material/morphium
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	color = "#37115A"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	protectiveness = 60
	integrity = 900
	conductive = 0
	conductivity = 1.5
	hardness = 80
	shard_type = SHARD_SHARD
	weight = 30
	negation = 25
	explosion_resistance = 85
	reflectivity = 0.2
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 8, TECH_PHORON = 6, TECH_BLUESPACE = 6, TECH_ARCANE = 3)

/datum/material/morphium/hull
	name = MAT_MORPHIUMHULL
	stack_type = /obj/item/stack/material/morphium/hull
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'

/datum/material/valhollide
	name = MAT_VALHOLLIDE
	stack_type = /obj/item/stack/material/valhollide
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	door_icon_base = "stone"
	color = "##FFF3B2"
	protectiveness = 30
	integrity = 240
	weight = 30
	hardness = 45
	negation = 2
	conductive = 0
	conductivity = 5
	reflectivity = 0.5
	radiation_resistance = 20
	spatial_instability = 30
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_PHORON = 5, TECH_BLUESPACE = 5)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"


// Adminspawn only, do not let anyone get this.
/datum/material/alienalloy
	name = "alienalloy"
	display_name = "durable alloy"
	stack_type = null
	color = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	protectiveness = 80 // 80%

// Likewise.
/datum/material/alienalloy/elevatorium
	name = "elevatorium"
	display_name = "elevator panelling"
	color = "#666666"

// Ditto.
/datum/material/alienalloy/dungeonium
	name = "dungeonium"
	display_name = "ultra-durable"
	wall_icon = 'icons/turf/walls/dungeon.dmi'
	color = "#FFFFFF"

/datum/material/alienalloy/bedrock
	name = "bedrock"
	display_name = "impassable rock"
	wall_icon = 'icons/turf/walls/rock.dmi'
	color = "#FFFFFF"

/datum/material/alienalloy/alium
	name = "alium"
	display_name = "alien"
	// wall_icon = "alien"
	table_icon = 'icons/turf/walls/metal.dmi'
	color = "#FFFFFF"

/datum/material/resin
	name = MAT_RESIN
	color = "#261438"
	wall_icon = 'icons/turf/walls/resin.dmi'
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	stack_type = /obj/item/stack/material/resin

/datum/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

/datum/material/resin/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		to_chat(M, "<span class='alien'>\The [W] shudders under your touch, starting to become porous.</span>")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(do_after(L, 5 SECONDS))
			spawn(2)
				playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
				W.dismantle_wall()
		return 1
	return 0

/datum/material/wood
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	color = "#9c5930"
	integrity = 50
	wall_icon = 'icons/turf/walls/wood.dmi'
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
	name = MAT_LOG
	wall_icon = 'icons/turf/walls/logs.dmi'
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

/datum/material/wood/log/sif
	name = MAT_SIFLOG
	color = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood/log/hard
	name = MAT_HARDLOG
	color = "#6f432a"
	stack_type = /obj/item/stack/material/log/hard

/datum/material/wood/holographic
	name = "holowood"
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/wood/sif
	name = MAT_SIFWOOD
	stack_type = /obj/item/stack/material/wood/sif
	color = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/wood/hardwood
	name = MAT_HARDWOOD
	stack_type = /obj/item/stack/material/wood/hard
	color = "#42291a"
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	integrity = 65	//a bit stronger than regular wood
	hardness = 20
	weight = 20	//likewise, heavier

/datum/material/cardboard
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

/datum/material/snow
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	legacy_flags = MATERIAL_BRITTLE
	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#FFFFFF"
	integrity = 1
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile
	radiation_resistance = 1

/datum/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	name = MAT_SNOW_PACKED
	legacy_flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	color = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	radiation_resistance = 1

/datum/material/cloth //todo
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	legacy_flags = MATERIAL_PADDING
	conductive = 0
	pass_stack_colors = TRUE

/datum/material/cult
	name = "cult"
	display_name = "disturbing stone"
	wall_icon = 'icons/turf/walls/cult.dmi'
	color = "#402821"
	wall_reinf_icon = 'icons/turf/walls/reinf_cult.dmi'
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target, "cult")

/datum/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/debris/cleanable/blood(target)

/datum/material/cult/reinf
	name = "cult2"
	display_name = "human remains"

/datum/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)

/datum/material/flesh
	name = "flesh"
	color = "#35343a"
	// wall_icon = "flesh" //TODO?
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "fleshclosed"
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "glob"
	sheet_plural_name = "globs"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)

/datum/material/flesh/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M))
		return 1
	return 0

/datum/material/flesh/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
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

/datum/material/bone
	name = "bone"
	color = "#e6dfc8"
	wall_icon = 'icons/turf/walls/bone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "fragment"
	sheet_plural_name = "fragments"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)

/datum/material/bone/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
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

//TODO PLACEHOLDERS:
/datum/material/leather
	name = "leather"
	color = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	conductive = 0

/datum/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	color = "#DA020A"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%

/datum/material/cotton
	name = "cotton"
	display_name ="cotton"
	color = "#FFFFFF"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

// This all needs to be OOP'd and use inheritence if its ever used in the future.
/datum/material/cloth_teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	color = "#00EAFA"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	color = "#505050"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	color = "#01C608"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	color = "#9C56C4"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	color = "#6B6FE3"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	color = "#E8E7C8"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	color = "#62E36C"
	legacy_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/toy_foam
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

//Vaudium products
/datum/material/bananium
	name = "bananium"
	stack_type = /obj/item/stack/material/bananium
	integrity = 150
	conductivity = 0 // Weird rubber metal.
	protectiveness = 10 // 33%
	color = "#d6c100"

/datum/material/stone/silencium
	name = "silencium"
	color = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/silencium

/datum/material/brass
	name = "brass"
	color = "#CAC955"
	integrity = 150
	stack_type = /obj/item/stack/material/brass

/datum/material/copper
	name = "copper"
	color = "#b45c13"
	weight = 15
	hardness = 30
	conductivity = 35
	stack_type = /obj/item/stack/material/copper

//Moving this here. It was in beehive.dm for some reason.
/datum/material/wax
	name = "wax"
	stack_type = /obj/item/stack/material/wax
	color = "#ebe6ac"
	melting_point = T0C+300
	weight = 1
	hardness = 20
	integrity = 100
	pass_stack_colors = TRUE

/datum/material/flesh
	name = "flesh"
	display_name = "chunk of flesh"
	color = "#dd90aa"
	sheet_singular_name = "meat"
	sheet_plural_name = "meats"
	integrity = 1200
	melting_point = 6000
	explosion_resistance = 200
	hardness = 500
	weight = 500

/datum/material/fluff //This is to allow for 2 handed weapons that don't want to have a prefix.
	name = " "
	display_name = ""
	color = "#000000"
	sheet_singular_name = "fluff"
	sheet_plural_name = "fluffs"
	hardness = 60
	weight = 20 //Strong as iron.

/datum/material/darkglass
	name = "darkglass"
	display_name = "darkglass"
	// wall_icon = "darkglass" // TODO?
	table_icon = 'icons/obj/structures/tables/glass_dark.dmi'
	color = "#FFFFFF"

/datum/material/fancyblack
	name = "fancyblack"
	display_name = "fancyblack"
	// wall_icon = "fancyblack"  // TODO?
	color = "#FFFFFF"

/datum/material/algae
	name = MAT_ALGAE
	stack_type = /obj/item/stack/material/algae
	color = "#557722"
	shard_type = SHARD_STONE_PIECE
	weight = 10
	hardness = 10
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/obj/item/stack/material/algae
	name = "algae sheet"
	icon_state = "sheet-uranium"
	color = "#557722"
	default_type = MAT_ALGAE

/obj/item/stack/material/algae/ten
	amount = 10

/datum/material/carbon
	name = MAT_CARBON
	stack_type = /obj/item/stack/material/carbon
	color = "#303030"
	shard_type = SHARD_SPLINTER
	weight = 5
	hardness = 20
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	door_icon_base = "stone"
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/obj/item/stack/material/carbon
	name = "carbon sheet"
	icon_state = "sheet-metal"
	color = "#303030"
	default_type = MAT_CARBON

/datum/material/hybrid_resin
	name = "resin compound"
	color = "#321a49"
	wall_icon = 'icons/turf/walls/resin.dmi'
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+200//we melt faster this isnt a building material you wanna built engines from
	sheet_singular_name = "bar"
	sheet_plural_name = "bars"
	conductive = 0
	explosion_resistance = 20//normal resin has 60, we are much softer
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/hybrid_resin

/obj/item/stack/material/hybrid_resin
	name = "resin compound"
	icon_state = "sheet-resin"
	default_type = "resin compound"
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/datum/material/hybrid_resin/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/hybrid_resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/effect/alien/hybrid_resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/hybrid_nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/effect/alien/hybrid_resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE)
