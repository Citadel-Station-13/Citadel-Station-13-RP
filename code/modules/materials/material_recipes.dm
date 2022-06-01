/datum/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/datum/material/proc/generate_recipes()
	recipes = list()

	// If is_brittle() returns true, these are only good for a single strike.
	recipes += new/datum/stack_recipe("[display_name] baseball bat", /obj/item/material/twohanded/baseballbat, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] spoon", /obj/item/material/kitchen/utensil/spoon/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] armor plate", /obj/item/material/armor_plating, 1, time = 20, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] grave marker", /obj/item/material/gravemarker, 5, time = 50, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ring", /obj/item/clothing/gloves/ring/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] bracelet", /obj/item/clothing/accessory/bracelet/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)

	if(integrity>=50)
		recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] double bed", /obj/structure/bed/double, 4, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)

	if(hardness>50)
		recipes += new/datum/stack_recipe("[display_name] fork", /obj/item/material/kitchen/utensil/fork/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] knife", /obj/item/material/knife/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] blade", /obj/item/material/butterflyblade, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] hammer Head", /obj/item/material/hammer_head, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)

/datum/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("office chairs",list( \
		new/datum/stack_recipe("dark office chair", /obj/structure/bed/chair/office/dark, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("light office chair", /obj/structure/bed/chair/office/light, 5, one_per_turf = 1, on_floor = 1) \
		))
	recipes += new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/brown, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red comfy chair", /obj/structure/bed/chair/comfy/red, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue comfy chair", /obj/structure/bed/chair/comfy/blue, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple comfy chair", /obj/structure/bed/chair/comfy/purp, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green comfy chair", /obj/structure/bed/chair/comfy/green, 2, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("table frame", /obj/structure/table, 1, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("bench frame", /obj/structure/table/bench, 1, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("rack", /obj/structure/table/rack, 1, time = 5, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("cannon frame", /obj/item/cannonframe, 10, time = 15, one_per_turf = 0, on_floor = 0)
	recipes += new/datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, 1, 4, 20)
	recipes += new/datum/stack_recipe("roofing tile", /obj/item/stack/tile/roofing, 3, 4, 20)
	recipes += new/datum/stack_recipe("dance pole", /obj/structure/dancepole, 1, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60)
	recipes += new/datum/stack_recipe("frame", /obj/item/frame, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("mirror frame", /obj/item/frame/mirror, 1, time = 5, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe("fire extinguisher cabinet frame", /obj/item/frame/extinguisher_cabinet, 4, time = 5, one_per_turf = 0, on_floor = 1)
	//recipes += new/datum/stack_recipe("fire axe cabinet frame", /obj/item/frame/fireaxe_cabinet, 4, time = 5, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe("railing", /obj/structure/railing, 2, time = 50, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe_list("airlock assemblies", list( \
		new/datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("eng atmos airlock assembly", /obj/structure/door_assembly/door_assembly_eat, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("voidcraft airlock assembly horizontal", /obj/structure/door_assembly/door_assembly_voidcraft, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("voidcraft airlock assembly vertical", /obj/structure/door_assembly/door_assembly_voidcraft/vertical, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("emergency shutter", /obj/structure/firedoor_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("IV drip", /obj/machinery/iv_drip, 4, time = 20, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("conveyor switch", /obj/machinery/conveyor_switch, 2, time = 20, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("grenade casing", /obj/item/grenade/chem_grenade)
	recipes += new/datum/stack_recipe("light fixture frame", /obj/item/frame/light, 2)
	recipes += new/datum/stack_recipe("small light fixture frame", /obj/item/frame/light/small, 1)
	recipes += new/datum/stack_recipe("floor lamp fixture frame", /obj/machinery/light_construct/flamp, 2)
	recipes += new/datum/stack_recipe("apc frame", /obj/item/frame/apc, 2)
	recipes += new/datum/stack_recipe_list("modular computer frames", list( \
		new/datum/stack_recipe("modular console frame", /obj/item/modular_computer/console, 20),\
		new/datum/stack_recipe("modular telescreen frame", /obj/item/modular_computer/telescreen, 10),\
		new/datum/stack_recipe("modular laptop frame", /obj/item/modular_computer/laptop, 10),\
		new/datum/stack_recipe("modular tablet frame", /obj/item/modular_computer/tablet, 5),\
	))
	recipes += new/datum/stack_recipe_list("filing cabinets", list( \
		new/datum/stack_recipe("filing cabinet", /obj/structure/filingcabinet, 4, time = 20, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("tall filing cabinet", /obj/structure/filingcabinet/filingcabinet, 4, time = 20, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("chest drawer", /obj/structure/filingcabinet/chestdrawer, 4, time = 20, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("desk bell", /obj/item/deskbell, 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("scooter frame", /obj/item/scooter_frame, 5, time = 20, one_per_turf = 1, on_floor = 1)

/datum/material/plasteel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("AI core", /obj/structure/AIcore, 4, time = 50, one_per_turf = 1)
	recipes += new/datum/stack_recipe("Metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = 1)
	recipes += new/datum/stack_recipe("knife grip", /obj/item/material/butterflyhandle, 4, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("dark floor tile", /obj/item/stack/tile/floor/dark, 1, 4, 20)
	recipes += new/datum/stack_recipe("roller bed", /obj/item/roller, 5, time = 30, on_floor = 1)
	recipes += new/datum/stack_recipe("whetstone", /obj/item/whetstone, 2, time = 10)
	recipes += new/datum/stack_recipe("reinforced skateboard assembly", /obj/item/heavy_skateboard_frame, 10, time = 20, one_per_turf = 1)
	recipes += new/datum/stack_recipe("plasteel floor tile", /obj/item/stack/tile/plasteel, 1, 4, 20)

/datum/material/stone/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1)

/datum/material/stone/marble/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("light marble floor tile", /obj/item/stack/tile/wmarble, 1, 4, 20)
	recipes += new/datum/stack_recipe("dark marble floor tile", /obj/item/stack/tile/bmarble, 1, 4, 20)
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("male statue", /obj/structure/statue/marble/male, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("female statue", /obj/structure/statue/marble/female, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("monkey statue", /obj/structure/statue/marble/monkey, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("corgi statue", /obj/structure/statue/marble/corgi, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))

/datum/material/plastic/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("plastic bag", /obj/item/storage/bag/plasticbag, 3, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("blood pack", /obj/item/reagent_containers/blood/empty, 4, on_floor = 0, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (large)", /obj/item/reagent_containers/chem_disp_cartridge,        5, on_floor=0, pass_stack_color = TRUE) // 500u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (med)",   /obj/item/reagent_containers/chem_disp_cartridge/medium, 3, on_floor=0, pass_stack_color = TRUE) // 250u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (small)", /obj/item/reagent_containers/chem_disp_cartridge/small,  1, on_floor=0, pass_stack_color = TRUE) // 100u
	recipes += new/datum/stack_recipe("white floor tile", /obj/item/stack/tile/floor/white, 1, 4, 20, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("freezer floor tile", /obj/item/stack/tile/floor/freezer, 1, 4, 20, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("shower curtain", /obj/structure/curtain, 4, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("plastic flaps", /obj/structure/plasticflaps, 4, time = 25, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("airtight plastic flaps", /obj/structure/plasticflaps/mining, 5, time = 25, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("water-cooler", /obj/structure/reagent_dispensers/water_cooler, 4, time = 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("lampshade", /obj/item/lampshade, 1, time = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("plastic net", /obj/item/material/fishing_net, 25, time = 1 MINUTE, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("rubberized wheels", /obj/item/skate_wheels, 12, time = 24)
	recipes += new/datum/stack_recipe("plastic raincoat", /obj/item/clothing/suit/storage/hooded/rainponcho, 5, time = 10)

/datum/material/wood/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wood circlet", /obj/item/clothing/head/woodcirclet, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("clipboard", /obj/item/clipboard, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wooden chair", /obj/structure/bed/chair/wood, 3, time = 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crossbow frame", /obj/item/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	// Pew pew pew
	recipes += new/datum/stack_recipe_list("pews", list( \
		new/datum/stack_recipe("pew middle", /obj/structure/bed/chair/pew, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew left", /obj/structure/bed/chair/pew/left, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew right", /obj/structure/bed/chair/pew/right, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		))
	recipes += new/datum/stack_recipe("beehive assembly", /obj/item/beehive_assembly, 4, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("beehive frame", /obj/item/honey_frame, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("book shelf", /obj/structure/bookcase, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("noticeboard frame", /obj/item/frame/noticeboard, 4, time = 5, one_per_turf = 0, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wooden bucket", /obj/item/reagent_containers/glass/bucket/wood, 2, time = 4, one_per_turf = 0, on_floor = 0, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("coilgun stock", /obj/item/coilgun_assembly, 5, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude fishing rod", /obj/item/material/fishing_rod/built, 8, time = 10 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("drying rack", /obj/machinery/smartfridge/drying_rack, 10)
	recipes += new/datum/stack_recipe("skateboard assembly", /obj/item/skateboard_frame, 10, time = 20, one_per_turf = 1)
	recipes += new/datum/stack_recipe("bokken blade", /obj/item/bokken_blade, 10, time = 10)
	recipes += new/datum/stack_recipe("bokken hilt", /obj/item/bokken_hilt, 5, time = 10)
	recipes += new/datum/stack_recipe("wakibokken blade", /obj/item/wakibokken_blade, 10, time = 5)
	recipes += new/datum/stack_recipe("rifle stock", /obj/item/weaponcrafting/stock, 5, time = 5)
	recipes += new/datum/stack_recipe("wooden panel", /obj/structure/window/wooden, 1, time = 10, one_per_turf = 0, on_floor = 1)

/datum/material/wood/hardwood/generate_recipes()
	//we're not going to ..() since we want to override the list entirely, to cut out all the stuff it'd inherit from wood - important, or else we'd have to fuss around with more subtypes to stop people turning hardwood into regular wood
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] baseball bat", /obj/item/material/twohanded/baseballbat, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] spoon", /obj/item/material/kitchen/utensil/spoon/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] armor plate", /obj/item/material/armor_plating, 1, time = 20, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] grave marker", /obj/item/material/gravemarker, 5, time = 50, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ring", /obj/item/clothing/gloves/ring/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] bracelet", /obj/item/clothing/accessory/bracelet/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	//TODO - make hardwood tile and floor sprites
	//recipes += new/datum/stack_recipe("hardwood floor tile", /obj/item/stack/tile/wood/hard, 1, 4, 20)

	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] double bed", /obj/structure/bed/double, 4, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crossbow frame", /obj/item/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0)
	recipes += new/datum/stack_recipe("coilgun stock", /obj/item/coilgun_assembly, 5)
	recipes += new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1)
	// Pew pew pew
	recipes += new/datum/stack_recipe_list("pews", list( \
		new/datum/stack_recipe("pew middle", /obj/structure/bed/chair/pew, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew left", /obj/structure/bed/chair/pew/left, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		new/datum/stack_recipe("pew right", /obj/structure/bed/chair/pew/right, 1, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"), \
		))
	recipes += new/datum/stack_recipe("hardwood bokken blade", /obj/item/bokken_blade/hardwood, 10, time = 20)
	recipes += new/datum/stack_recipe("hardwood wakibokken blade", /obj/item/wakibokken_blade/hardwood, 5, time = 10)

/datum/material/wood/log/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("bonfire", /obj/structure/bonfire, 5, time = 50, supplied_material = "[name]", pass_stack_color = TRUE)

/datum/material/cardboard/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("box", /obj/item/storage/box, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("donut box", /obj/item/storage/box/donut/empty, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("egg box", /obj/item/storage/fancy/egg_box, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("light tubes box", /obj/item/storage/box/lights/tubes, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("light bulbs box", /obj/item/storage/box/lights/bulbs, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("mouse traps box", /obj/item/storage/box/mousetraps, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("pizza box", /obj/item/pizzabox, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("large cardboard box", /obj/structure/closet/largecardboard, 3, time = 25, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe_list("folders",list( \
		new/datum/stack_recipe("blue folder", /obj/item/folder/blue), \
		new/datum/stack_recipe("grey folder", /obj/item/folder), \
		new/datum/stack_recipe("red folder", /obj/item/folder/red), \
		new/datum/stack_recipe("white folder", /obj/item/folder/white), \
		new/datum/stack_recipe("yellow folder", /obj/item/folder/yellow), \
		))

/datum/material/snow/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("snowball", /obj/item/material/snow/snowball, 1, time = 10)
	recipes += new/datum/stack_recipe("snow brick", /obj/item/stack/material/snowbrick, 2, time = 10)
	recipes += new/datum/stack_recipe("snowman", /obj/structure/snowman, 2, time = 15)
	recipes += new/datum/stack_recipe("snow robot", /obj/structure/snowman/borg, 2, time = 10)
	recipes += new/datum/stack_recipe("snow spider", /obj/structure/snowman/spider, 3, time = 20)
	recipes += new/datum/stack_recipe("snowman head", /obj/item/clothing/head/snowman, 5, time = 5)
	recipes += new/datum/stack_recipe("snowman suit", /obj/item/clothing/suit/snowman, 10, time = 10)

/datum/material/snowbrick/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] double bed", /obj/structure/bed/double, 4, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")

/datum/material/wood/sif/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("alien wood floor tile", /obj/item/stack/tile/wood/sif, 1, 4, 20, pass_stack_color = TRUE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue

/datum/material/supermatter/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("supermatter shard", /obj/machinery/power/supermatter/shard, 30 , one_per_turf = 1, time = 600, on_floor = 1)

/datum/material/cloth/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("woven net", /obj/item/material/fishing_net, 10, time = 30 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("bedsheet", /obj/item/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe_list("colored bedsheets", list( \
		new/datum/stack_recipe("red bedsheet", /obj/item/bedsheet/red, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("orange bedsheet", /obj/item/bedsheet/orange, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("yellow bedsheet", /obj/item/bedsheet/yellow, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("green bedsheet", /obj/item/bedsheet/green, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("blue bedsheet", /obj/item/bedsheet/blue, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("purple bedsheet", /obj/item/bedsheet/purple, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("brown bedsheet", /obj/item/bedsheet/brown, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("rainbow bedsheet", /obj/item/bedsheet/rainbow, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		))
	recipes += new/datum/stack_recipe("double bedsheet", /obj/item/bedsheet/double, 10, time = 30 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe_list("colored double bedsheets", list( \
		new/datum/stack_recipe("red double bedsheet", /obj/item/bedsheet/reddouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("orange doudble bedsheet", /obj/item/bedsheet/orangedouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("yellow double bedsheet", /obj/item/bedsheet/yellowdouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("green double bedsheet", /obj/item/bedsheet/greendouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("blue double bedsheet", /obj/item/bedsheet/bluedouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("purple double bedsheet", /obj/item/bedsheet/purpledouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("brown double bedsheet", /obj/item/bedsheet/browndouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		new/datum/stack_recipe("rainbow double bedsheet", /obj/item/bedsheet/rainbowdouble, 10, time = 30 SECONDS, pass_stack_color = TRUE), \
		))
	recipes += new/datum/stack_recipe("uniform", /obj/item/clothing/under/color/white, 8, time = 15 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps, 2, time = 5 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("gloves", /obj/item/clothing/gloves/white, 2, time = 5 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah, 3, time = 6 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("turban", /obj/item/clothing/head/turban, 3, time = 6 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("hijab", /obj/item/clothing/head/hijab, 3, time = 6 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("kippa", /obj/item/clothing/head/kippa, 3, time = 6 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("kippa", /obj/item/clothing/head/traveller, 3, time = 6 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white, 4, time = 5 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white, 8, time = 10 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("belt pouch", /obj/item/storage/belt/fannypack/white, 25, time = 1 MINUTE, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("empty sandbag", /obj/item/stack/emptysandbag, 2, 5, 10, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("shrine seal", /obj/structure/shrine_seal, 2, time = 5 SECONDS)
	recipes += new/datum/stack_recipe("cloth rag", /obj/item/reagent_containers/glass/rag, 1, time = 2 SECONDS)
	recipes += new/datum/stack_recipe("woven string", /obj/item/weaponcrafting/string, 1, time = 10)

/datum/material/resin/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/effect/alien/resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder/resin, 2, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] net", /obj/item/material/fishing_net, 10, time = 5 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/effect/alien/resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] node", /obj/effect/alien/weeds/node, 1, time = 4 SECONDS)

/datum/material/silver/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("head of security statue", /obj/structure/statue/silver/hos, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("medical doctor statue", /obj/structure/statue/silver/md, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("janitor statue", /obj/structure/statue/silver/janitor, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("security statue", /obj/structure/statue/silver/sec, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("secborg statue", /obj/structure/statue/silver/secborg, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("medborg statue", /obj/structure/statue/silver/medborg, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("silver floor tile", /obj/item/stack/tile/silver, 1, 4, 20)

/datum/material/gold/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("golden crown", /obj/item/clothing/head/crown, 10, time = 30)
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("head of security statue", /obj/structure/statue/gold/hos, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("head of personnel statue", /obj/structure/statue/gold/hop, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("chief medical officer statue", /obj/structure/statue/gold/cmo, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("chief engineer statue", /obj/structure/statue/gold/ce, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("research director statue", /obj/structure/statue/gold/rd, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("gold floor tile", /obj/item/stack/tile/gold, 1, 4, 20)

/datum/material/phoron/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("scientist statue", /obj/structure/statue/phoron/scientist, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("xenomorph statue", /obj/structure/statue/phoron/xeno, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("phoron floor tile", /obj/item/stack/tile/phoron, 1, 4, 20)

/datum/material/uranium/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("nuke statue", /obj/structure/statue/uranium/nuke, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("engineer statue", /obj/structure/statue/uranium/eng, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("uranium floor tile", /obj/item/stack/tile/uranium, 1, 4, 20)

/datum/material/diamond/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("captain statue", /obj/structure/statue/diamond/captain, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("ai hologram statue", /obj/structure/statue/diamond/ai1, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("ai core statue", /obj/structure/statue/diamond/ai2, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("diamond floor tile", /obj/item/stack/tile/diamond, 1, 4, 20)

/datum/material/sandstone/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("assistant statue", /obj/structure/statue/sandstone/assistant, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))

/datum/material/bananium/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("bananium statue", /obj/structure/statue/bananium, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("clown statue", /obj/structure/statue/bananium/clown, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("bananium floor tile", /obj/item/stack/tile/bananium, 1, 4, 20)

/datum/material/silencium/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("silencium floor tile", /obj/item/stack/tile/silencium, 1, 4, 20)

/datum/material/durasteel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("durasteel floor tile", /obj/item/stack/tile/durasteel, 1, 4, 20)

/datum/material/brass/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("brass floor tile", /obj/item/stack/tile/brass, 1, 4, 20)

/datum/material/leather/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("wallet", /obj/item/storage/wallet, 1)
	recipes += new/datum/stack_recipe("muzzle", /obj/item/clothing/mask/muzzle, 2)
	recipes += new/datum/stack_recipe("botany gloves", /obj/item/clothing/gloves/botanic_leather, 3)
	recipes += new/datum/stack_recipe("toolbelt", /obj/item/storage/belt/utility, 4)
	recipes += new/datum/stack_recipe("leather satchel", /obj/item/storage/backpack/satchel, 5)
	recipes += new/datum/stack_recipe("bandolier", /obj/item/storage/belt/security/tactical/bandolier, 5)
	recipes += new/datum/stack_recipe("leather jacket", /obj/item/clothing/suit/storage/toggle/leather_jacket, 7)
	recipes += new/datum/stack_recipe("leather shoes", /obj/item/clothing/shoes/laceup, 2)
	recipes += new/datum/stack_recipe("leather overcoat", /obj/item/clothing/suit/overcoat, 10)
	recipes += new/datum/stack_recipe("voyager satchel", /obj/item/storage/backpack/satchel/voyager, 10)
	recipes += new/datum/stack_recipe("voyager backpack", /obj/item/storage/backpack/voyager, 10)
	recipes += new/datum/stack_recipe("voyager harness", /obj/item/clothing/accessory/storage/voyager, 8)
	recipes += new/datum/stack_recipe_list("statues", list( \
		new/datum/stack_recipe("bone statue", /obj/structure/statue/bone, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("skull statue", /obj/structure/statue/bone/skull, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("half skull statue", /obj/structure/statue/bone/skull/half, 20, time = 5, one_per_turf = 1, on_floor = 1), \
		))

/datum/material/sinew/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("sinew restraints", /obj/item/handcuffs/sinew, 1)

/datum/material/wax/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("candle", /obj/item/flame/candle, 1)
	recipes += new/datum/stack_recipe("wax floor tile", /obj/item/stack/tile/wax, 1, 4, 20)
	recipes += new/datum/stack_recipe("honeycomb floor tile", /obj/item/stack/tile/honeycomb, 1, 4, 20)
	recipes += new/datum/stack_recipe("wax globule", /obj/item/ammo_casing/organic/wax, 1)
	recipes += new/datum/stack_recipe("royal throne", /obj/structure/bed/chair/apidean, 20, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("apidean stool", /obj/structure/bed/chair/apidean_stool, 5, time = 5, one_per_turf = 1, on_floor = 1)
