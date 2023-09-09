#warn refactor top two rpocs

/datum/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/datum/material/proc/generate_recipes()
	recipes = list()
	return recipes

/datum/material/plasteel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("whetstone", /obj/item/whetstone, 2, time = 10)
	recipes += new/datum/stack_recipe("reinforced skateboard assembly", /obj/item/heavy_skateboard_frame, 10, time = 20, one_per_turf = 1)
	recipes += new/datum/stack_recipe("plasteel floor tile", /obj/item/stack/tile/plasteel, 1, 4, 20)

/datum/material/sandstone/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("sandstone floor tile", /obj/item/stack/tile/floor/sandstone, 1, 4, 20)
	recipes += new/datum/stack_recipe("sandstone jar", /obj/item/reagent_containers/glass/bucket/sandstone, 2, time = 4, one_per_turf = 0, on_floor = 0, pass_stack_color = FALSE)

/datum/material/sandstone/marble/generate_recipes()
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
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (large)", /obj/item/reagent_containers/cartridge/dispenser/large,        5, on_floor=0, pass_stack_color = TRUE) // 500u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (med)",   /obj/item/reagent_containers/cartridge/dispenser/medium, 3, on_floor=0, pass_stack_color = TRUE) // 250u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (small)", /obj/item/reagent_containers/cartridge/dispenser/small,  1, on_floor=0, pass_stack_color = TRUE) // 100u
	recipes += new/datum/stack_recipe("white floor tile", /obj/item/stack/tile/floor/white, 1, 4, 20, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("freezer floor tile", /obj/item/stack/tile/floor/freezer, 1, 4, 20, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("shower curtain", /obj/structure/curtain, 4, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("plastic flaps", /obj/structure/plasticflaps, 4, time = 25, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("airtight plastic flaps", /obj/structure/plasticflaps/mining, 5, time = 25, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("water-cooler", /obj/structure/reagent_dispensers/water_cooler, 4, time = 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("lampshade", /obj/item/lampshade, 1, time = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("rubberized wheels", /obj/item/skate_wheels, 12, time = 24)
	recipes += new/datum/stack_recipe("plastic raincoat", /obj/item/clothing/suit/storage/hooded/rainponcho, 5, time = 10)

/datum/material/wood/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/ridden/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/ridden/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wood circlet", /obj/item/clothing/head/woodcirclet, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("clipboard", /obj/item/clipboard, 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wood roofing tile", /obj/item/stack/tile/roofing/wood, 3, 4, 20)
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
	recipes += new/datum/stack_recipe("drying rack", /obj/machinery/smartfridge/drying_rack, 10)
	recipes += new/datum/stack_recipe("skateboard assembly", /obj/item/skateboard_frame, 10, time = 20, one_per_turf = 1)
	recipes += new/datum/stack_recipe("bokken blade", /obj/item/bokken_blade, 10, time = 10)
	recipes += new/datum/stack_recipe("bokken hilt", /obj/item/bokken_hilt, 5, time = 10)
	recipes += new/datum/stack_recipe("wakibokken blade", /obj/item/wakibokken_blade, 10, time = 5)
	recipes += new/datum/stack_recipe("rifle stock", /obj/item/weaponcrafting/stock, 5, time = 5)
	recipes += new/datum/stack_recipe("wooden panel", /obj/structure/window/wooden, 1, time = 10, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe_list("wooden fencing", list( \
		new/datum/stack_recipe("fence", /obj/structure/fence/wooden, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("fence end", /obj/structure/fence/wooden/end, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("fencepost", /obj/structure/fence/wooden/post, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("fence corner", /obj/structure/fence/wooden/corner, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("gate", /obj/structure/fence/door/wooden, 5, one_per_turf = 1, on_floor = 1), \
		))

/datum/material/wood/hardwood/generate_recipes()
	//we're not going to ..() since we want to override the list entirely, to cut out all the stuff it'd inherit from wood - important, or else we'd have to fuss around with more subtypes to stop people turning hardwood into regular wood
	recipes = list()
	recipes += new/datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/ridden/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/ridden/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
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

/datum/material/cloth/generate_recipes()
	recipes = list()
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
