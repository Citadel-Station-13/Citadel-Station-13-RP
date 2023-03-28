
// Datum definitions follow.
/datum/material/uranium
	id = "uranium"
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = RAD_INTENSITY_MAT_URANIUM
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"

/datum/material/diamond
	id = "diamond"
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)

/datum/material/gold
	id = "gold"
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/gold/bronze //placeholder for ashtrays
	id = "bronze"
	name = "bronze"
	icon_colour = "#EDD12F"

/datum/material/silver
	id = "silver"
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

//R-UST port
/datum/material/supermatter
	id = "supermatter"
	name = "supermatter"
	icon_colour = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	radioactivity = RAD_INTENSITY_MAT_SUPERMATTER
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = 'icons/turf/walls/stone.dmi'
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)

/datum/material/phoron
	id = "phoron"
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_colour = "#FC2BC5"
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

/datum/material/sandstone
	id = "sandstone"
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"

/datum/material/sandstone/marble
	id = "marble"
	name = "marble"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/datum/material/steel
	id = "steel"
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#666666"
	table_icon_base = "metal"

/datum/material/steel/hull
	id = "steel_hull"
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#666677"

/datum/material/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/diona
	id = "biomass_diona"
	name = "biomass"
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = 'icons/turf/walls/diona.dmi'
	icon_reinf = null

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)

/datum/material/steel/holographic
	id = "steel_holo"
	name = "holo" + MAT_STEEL
	display_name = "steel"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/plasteel
	id = "plasteel"
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14
	table_icon_base = "metal"

/datum/material/plasteel/hull
	id = "plasteel_hull"
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)

// Very rare alloy that is reflective, should be used sparingly.
/datum/material/durasteel
	id = "durasteel"
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT, MAT_DIAMOND = SHEET_MATERIAL_AMOUNT) //shrug
	table_icon_base = "metal"

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	id = "durasteel_hull"
	name = MAT_DURASTEELHULL
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)

/datum/material/plasteel/titanium
	id = "titanium"
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	table_icon_base = "metal"

/datum/material/plasteel/titanium/hull
	id = "titanium_hull"
	name = MAT_TITANIUMHULL
	stack_type = null
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'

/datum/material/glass
	id = "glass"
	name = "glass"
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
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
	table_icon_base = "glass"
	table_reinf_icon_base = "rglass"

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
	id = "glass_reinf"
	name = "rglass"
	display_name = "reinforced glass"
	stack_type = /obj/item/stack/material/glass/reinforced
	flags = MATERIAL_BRITTLE
	icon_colour = "#00E1FF"
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
	id = "glass_boro"
	name = "borosilicate glass"
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	integrity = 100
	icon_colour = "#FC2BC5"
	stack_origin_tech = list(TECH_MATERIAL = 4)
	window_options = list("One Direction" = 1, "Full Window" = 2)
	created_window = /obj/structure/window/phoronbasic
	created_fulltile_window = /obj/structure/window/phoronbasic/full
	wire_product = null
	rod_product = /obj/item/stack/material/glass/phoronrglass

/datum/material/glass/phoron/reinforced
	id = "glass_boro_reinf"
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
	id = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/datum/material/plastic/holographic
	name = "holoplastic"
	id = "plastic_holo"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/osmium
	name = "osmium"
	id = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductivity = 100

/datum/material/tritium
	name = "tritium"
	id = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/deuterium
	name = "deuterium"
	id = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	conductive = 0

/datum/material/mhydrogen
	name = "mhydrogen"
	id = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1

/datum/material/platinum
	name = "platinum"
	id = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/iron
	name = "iron"
	id = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/lead
	name = MAT_LEAD
	id = "lead"
	stack_type = /obj/item/stack/material/lead
	icon_colour = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.

// Particle Smasher and other exotic materials.

/datum/material/verdantium
	name = MAT_VERDANTIUM
	id = "verdantium"
	stack_type = /obj/item/stack/material/verdantium
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#4FE95A"
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
	id = "morphium"
	stack_type = /obj/item/stack/material/morphium
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#37115A"
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
	id = "morphium_hull"
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'

/datum/material/valhollide
	name = MAT_VALHOLLIDE
	id = "valhollide"
	stack_type = /obj/item/stack/material/valhollide
	icon_base = 'icons/turf/walls/stone.dmi'
	door_icon_base = "stone"
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "##FFF3B2"
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
	id = "alien_alloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	protectiveness = 80 // 80%

// Likewise.
// todo: kill with fire
/datum/material/alienalloy/elevatorium
	id = "elevatorium"
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

// Ditto.
// todo: KILL WITH FIRE
/datum/material/alienalloy/dungeonium
	id = "dungeonium"
	name = "dungeonium"
	display_name = "ultra-durable"
	icon_base = 'icons/turf/walls/dungeon.dmi'
	icon_colour = "#FFFFFF"

/datum/material/alienalloy/bedrock
	id = "bedrock"
	name = "bedrock"
	display_name = "impassable rock"
	icon_base = 'icons/turf/walls/rock.dmi'
	icon_colour = "#FFFFFF"

/datum/material/alienalloy/alium
	id = "abductor_alloy"
	name = "alium"
	display_name = "alien"
	icon_colour = "#FFFFFF"

/datum/material/resin
	id = "xenoresin"
	name = "resin"
	icon_colour = "#261438"
	icon_base = 'icons/turf/walls/resin.dmi'
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
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
	id = "wood"
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#9c5930"
	integrity = 50
	icon_base = 'icons/turf/walls/wood.dmi'
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

/datum/material/wood/log
	id = "log"
	name = "log"
	icon_base = 'icons/turf/walls/log.dmi'
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = null
	sheet_plural_name = "pile"

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
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	integrity = 65	//a bit stronger than regular wood
	hardness = 20
	weight = 20	//likewise, heavier
	table_icon_base = "stone"

/datum/material/cardboard
	id = "cardboard"
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#AAAAAA"
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
	id = "snow"
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#FFFFFF"
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
	id = "snow_packed"
	name = "packed snow"
	flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D8FDFF"
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
	id = "cloth"
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	stack_type = /obj/item/stack/material/cloth
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	flags = MATERIAL_PADDING
	conductive = 0
	pass_stack_colors = TRUE

/datum/material/cult
	id = "cult"
	name = "cult"
	display_name = "disturbing stone"
	icon_base = 'icons/turf/walls/cult.dmi'
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/datum/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target, "cult")

/datum/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/debris/cleanable/blood(target)

/datum/material/cult/reinf
	id = "cult_reinforced"
	name = "cult2"
	display_name = "human remains"

/datum/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)

/datum/material/flesh
	id = "flesh"
	name = "flesh"
	icon_colour = "#35343a"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "fleshclosed"
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
	id = "bone"
	name = "bone"
	icon_colour = "#e6dfc8"
	stack_type = /obj/item/stack/material/bone
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "fragment"
	sheet_plural_name = "fragments"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	door_icon_base = "stone"
	table_icon_base = "stone"

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
// todo: wtf are these they need to be subtyped properly and uhh yea
/datum/material/leather
	id = "leather"
	name = "leather"
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	conductive = 0

/datum/material/carpet
	id = "carpet"
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%

/datum/material/cotton
	id = "cotton"
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

// This all needs to be OOP'd and use inheritence if its ever used in the future.
/datum/material/cloth_teal
	id = "cloth_teal"
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_black
	id = "cloth_black"
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_green
	id = "cloth_green"
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_puple
	id = "cloth_purple"
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_blue
	id = "cloth_blue"
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_beige
	id = "cloth_beige"
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/cloth_lime
	id = "cloth_lime"
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0

/datum/material/toy_foam
	id = "foam"
	name = "foam"
	display_name = "foam"
	use_name = "foam"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	icon_colour = "#ff9900"
	hardness = 0
	weight = 0
	protectiveness = 0 // 0%
	conductive = 0

//Vaudium products
/datum/material/bananium
	id = "bananium"
	name = "bananium"
	stack_type = /obj/item/stack/material/bananium
	integrity = 150
	conductivity = 0 // Weird rubber metal.
	protectiveness = 10 // 33%
	icon_colour = "#d6c100"

/datum/material/sandstone/silencium
	id = "silencium"
	name = "silencium"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/silencium

/datum/material/brass
	id = "brass"
	name = "brass"
	icon_colour = "#CAC955"
	integrity = 150
	stack_type = /obj/item/stack/material/brass

/datum/material/copper
	id = "copper"
	name = "copper"
	icon_colour = "#b45c13"
	weight = 15
	hardness = 30
	conductivity = 35
	stack_type = /obj/item/stack/material/copper


/datum/material/wax
	id = "wax"
	name = "wax"
	stack_type = /obj/item/stack/material/wax
	icon_colour = "#ebe6ac"
	melting_point = T0C+300
	weight = 1
	hardness = 20
	integrity = 100
	pass_stack_colors = TRUE

/datum/material/flesh
	id = "flesh"
	name = "flesh"
	display_name = "chunk of flesh"
	icon_colour = "#dd90aa"
	sheet_singular_name = "meat"
	sheet_plural_name = "meats"
	integrity = 1200
	melting_point = 6000
	explosion_resistance = 200
	hardness = 500
	weight = 500

/datum/material/fluff //This is to allow for 2 handed weapons that don't want to have a prefix.
	id = "fluff"
	name = " "
	display_name = ""
	icon_colour = "#000000"
	sheet_singular_name = "fluff"
	sheet_plural_name = "fluffs"
	hardness = 60
	weight = 20 //Strong as iron.

// what the fuck?
/datum/material/darkglass
	id = "glass_dark"
	name = "darkglass"
	display_name = "darkglass"
	icon_base = "darkglass"
	icon_colour = "#FFFFFF"

// what the fuck?
/datum/material/fancyblack
	id = "black_fancy"
	name = "fancyblack"
	display_name = "fancyblack"
	icon_base = "fancyblack"
	icon_colour = "#FFFFFF"
