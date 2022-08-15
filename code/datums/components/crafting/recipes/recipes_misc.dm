/////////////////
//Large Objects//
/////////////////

/datum/crafting_recipe/plunger
	name = "Plunger"
	result = /obj/item/plunger
	time = 1
	reqs = list(/obj/item/stack/material/plastic = 1,
				/obj/item/stack/material/wood = 1)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_TOOL

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/material/cloth = 2,
				 /obj/item/stack/material/plastic = 2,
				 /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

/* I need to go through and convert these.
/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/material/plasteel = 3,
		        /obj/item/stack/material/mineral/wood = 20,
		        /obj/item/stack/cable_coil = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/femur_breaker
	name = "Femur Breaker"
	result = /obj/structure/femur_breaker
	time = 150
	reqs = list(/obj/item/stack/material/metal = 20,
		        /obj/item/stack/cable_coil = 30)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

/*
// Blood Sucker stuff //
/datum/crafting_recipe/bloodsucker/blackcoffin
	name = "Black Coffin"
	result = /obj/structure/closet/crate/coffin/blackcoffin
	tools = list(TOOL_WELDER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/cloth = 1,
				/obj/item/stack/material/mineral/wood = 5,
				/obj/item/stack/material/metal = 1)
				///obj/item/duct_tape_piece = 8,,
				///obj/item/pipe = 2)
	time = 150
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS
	always_available = TRUE

/datum/crafting_recipe/bloodsucker/meatcoffin
	name = "Meat Coffin"
	result =/obj/structure/closet/crate/coffin/meatcoffin
	tools = list(/obj/item/kitchen/knife,
				 /obj/item/kitchen/rollingpin)
	reqs = list(/obj/item/reagent_containers/food/snacks/meat/slab = 5,
				/obj/item/restraints/handcuffs/cable = 1)
	time = 150
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS
	always_available = TRUE

/datum/crafting_recipe/bloodsucker/metalcoffin
	name = "Metal Coffin"
	result =/obj/structure/closet/crate/coffin/metalcoffin
	tools = list(TOOL_WELDER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/metal = 5)
	time = 100
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS
	always_available = TRUE

/datum/crafting_recipe/bloodsucker/vassalrack
	name = "Persuasion Rack"
	//desc = "For converting crewmembers into loyal Vassals."
	result = /obj/structure/bloodsucker/vassalrack
	tools = list(TOOL_WELDER,
				 	//TOOL_SCREWDRIVER,
					TOOL_WRENCH
					 )
	reqs = list(/obj/item/stack/material/mineral/wood = 3,
				/obj/item/stack/material/metal = 2,
				/obj/item/restraints/handcuffs/cable = 2,
				//obj/item/storage/belt = 1,
				//obj/item/stack/material/animalhide = 1,
				//obj/item/stack/material/leather = 1,
				//obj/item/stack/material/plasteel = 5
				)
		//parts = list(/obj/item/storage/belt = 1
		//			 )
	time = 150
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
	always_available = FALSE	// Disabled until learned


/datum/crafting_recipe/bloodsucker/candelabrum
	name = "Candelabrum"
	//desc = "For converting crewmembers into loyal Vassals."
	result = /obj/structure/bloodsucker/candelabrum
	tools = list(TOOL_WELDER,
				 TOOL_WRENCH
				)
	reqs = list(/obj/item/stack/material/metal = 3,
				/obj/item/stack/rods = 1,
				/obj/item/candle = 1
				)
	time = 100
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
	always_available = FALSE	// Disabled til learned
*/

/*
//This is for blacksmithing, if we want to port it.

/datum/crafting_recipe/furnace
	name = "Sandstone Furnace"
	result = /obj/structure/furnace
	time = 300
	reqs = list(/obj/item/stack/material/mineral/sandstone = 15,
	/obj/item/stack/material/metal = 4,
	/obj/item/stack/rods = 2)
	tools = list(TOOL_CROWBAR)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/tableanvil
	name = "Table Anvil"
	result = /obj/structure/anvil/obtainable/table
	time = 300
	reqs = list(/obj/item/stack/material/metal = 4,
		        /obj/item/stack/rods = 2)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/sandvil
	name = "Sandstone Anvil"
	result = /obj/structure/anvil/obtainable/sandstone
	time = 300
	reqs = list(/obj/item/stack/material/mineral/sandstone = 24)
	tools = list(TOOL_CROWBAR)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/basaltblock
	name = "Sintered Basalt Block"
	result = /obj/item/basaltblock
	time = 200
	reqs = list(/obj/item/stack/ore/glass/basalt = 50)
	tools = list(TOOL_WELDER)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/basaltanvil
	name = "Basalt Anvil"
	result = /obj/structure/anvil/obtainable/basalt
	time = 200
	reqs = list(/obj/item/basaltblock = 5)
	tools = list(TOOL_CROWBAR)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

///////////////////
//Tools & Storage//
///////////////////

/* //This medication stuff needs some work.

/datum/crafting_recipe/upgraded_gauze
	name = "Sterilized Gauze"
	result = /obj/item/stack/medical/gauze/adv/one
	time = 1
	reqs = list(/obj/item/stack/medical/gauze = 1,
				/datum/reagent/space_cleaner/sterilizine = 5)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_TOOL

/datum/crafting_recipe/brute_pack
	name = "Suture Pack"
	result = /obj/item/stack/medical/suture/five
	time = 1
	reqs = list(/obj/item/stack/medical/gauze/adv = 1,
				/datum/reagent/medicine/styptic_powder = 10)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_TOOL

/datum/crafting_recipe/burn_pack
	name = "Regenerative Mesh"
	result = /obj/item/stack/medical/mesh/five
	time = 1
	reqs = list(/obj/item/stack/medical/gauze/adv = 1,
				/datum/reagent/medicine/silver_sulfadiazine = 10)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_TOOL
*/

/datum/crafting_recipe/ghettojetpack
	name = "Improvised Jetpack"
	result = /obj/item/tank/jetpack/improvised
	time = 30
	reqs = list(/obj/item/tank/emergency/oxygen = 2,
				/obj/item/extinguisher = 1,
				/obj/item/pipe = 3,
				/obj/item/stack/cable_coil = 30)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_TOOL
	tools = list(TOOL_WRENCH, TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/goldenbox
	name = "Gold Plated Toolbox"
	result = /obj/item/storage/toolbox/gold_fake
	tools = list(/obj/item/cell/high,
				/obj/item/reagent_containers/glass/beaker)
	reqs = list(/obj/item/stack/material/cardboard = 1, //so we dont null items in crafting
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/material/gold = 1)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/shovel
	name = "Shovel"
	result = /obj/item/shovel
	tools = list(/obj/item/tool/screwdriver)
	reqs = list(/obj/item/stack/material/steel = 1,
				/obj/item/stack/material/wood = 5)
	time = 30
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/*
/datum/crafting_recipe/toolboxhammer
	name = "Toolbox Hammer"
	result = /obj/item/melee/smith/hammer/toolbox
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	reqs = list(/obj/item/storage/toolbox = 1,
							/obj/item/stack/material/metal = 4,
							/obj/item/stack/rods = 2)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS
*/

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 10
	reqs = list(/obj/item/paper = 5)
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/smallcarton
	name = "Small Carton"
	result = /obj/item/reagent_containers/food/drinks/sillycup/smallcarton
	time = 10
	reqs = list(/obj/item/stack/material/cardboard = 1)
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/brass_driver
	name = "Brass Screwdriver"
	tools = list(/obj/item/cell/high,
				/obj/item/reagent_containers/glass/beaker)
	result = /obj/item/tool/screwdriver/brass
	reqs = list(/obj/item/tool/screwdriver = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/material/brass = 1
				)
	time = 40
	//always_available = FALSE
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/brass_welder
	name = "Brass Welding Tool"
	tools = list(/obj/item/cell/high,
				/obj/item/reagent_containers/glass/beaker)
	result = /obj/item/weldingtool/brass
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/material/brass = 1
				)
	time = 40
	//always_available = FALSE
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/brass_wirecutters
	name = "Brass Wirecutters"
	tools = list(/obj/item/cell/high,
				/obj/item/reagent_containers/glass/beaker)
	result = /obj/item/tool/wirecutters/brass
	reqs = list(/obj/item/tool/wirecutters = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/material/brass = 1
				)
	time = 40
	//always_available = FALSE
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/brass_crowbar
	name = "Brass Crowbar"
	tools = list(/obj/item/cell/high,
				/obj/item/reagent_containers/glass/beaker)
	result = /obj/item/tool/crowbar/brass
	reqs = list(/obj/item/tool/crowbar = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/material/brass = 1
				)
	time = 40
	//always_available = FALSE
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/brass_wrench
	name = "Brass Wrench"
	tools = list(/obj/item/cell/high,
				/obj/item/reagent_containers/glass/beaker)
	result = /obj/item/tool/wrench/brass
	reqs = list(/obj/item/tool/wrench = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/material/brass = 1
				)
	time = 40
	//always_available = FALSE
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/welder_spear
	name = "Welder Spear"
	result = /obj/item/weldingtool/welder_spear
	reqs = list(/obj/item/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/weldingtool/mini = 1)
	time = 40
	category = CAT_TOOL
	subcategory = CAT_MISCELLANEOUS

/* Not gonna code this right now. This is bound to be nuts.
/datum/crafting_recipe/rcl
	name = "Makeshift Rapid Cable Layer"
	result = /obj/item/rcl/ghetto
	time = 40
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/material/metal = 15)
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS
*/

/datum/crafting_recipe/picket_sign
	name = "Picket Sign"
	result = /obj/item/picket_sign
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/material/cardboard = 2)
	time = 80
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/*
/datum/crafting_recipe/electrochromatic_kit
	name = "Electrochromatic Kit"
	result = /obj/item/electronics/electrochromatic_kit
	reqs = list(/obj/item/stack/material/metal = 1,
				/obj/item/stack/cable_coil = 1)
	time = 5
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/blackmarket_uplink
	name = "Black Market Uplink"
	result = /obj/item/blackmarket_uplink
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stack/cable_coil = 15,
		/obj/item/radio = 1,
		/obj/item/analyzer = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/heretic/codex
	name = "Codex Cicatrix"
	result = /obj/item/forbidden_book
	tools = list(/obj/item/pen)
	reqs = list(/obj/item/paper = 5,
				/obj/item/organ/eyes = 1,
				/obj/item/organ/heart = 1,
				/obj/item/stack/material/animalhide/human = 1)
	time = 150
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
	always_available = FALSE
*/

////////////
//Vehicles//
////////////

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/structure/bed/chair/wheelchair
	reqs = list(/obj/item/stack/material/plasteel = 2,
				/obj/item/stack/rods = 8)
	time = 100
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/*
/datum/crafting_recipe/motorized_wheelchair
	name = "Hoverchair"
	result = /obj/vehicle_old/ridden/wheelchair/motorized
	reqs = list(/obj/item/stack/material/plasteel = 10,
		/obj/item/stack/rods = 8,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	parts = list(/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 200
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/
/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle_old/skateboard
	time = 60
	reqs = list(/obj/item/stack/material/steel = 5,
				/obj/item/stack/rods = 10)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle_old/skateboard/scooter
	time = 65
	reqs = list(/obj/item/stack/material/steel = 5,
				/obj/item/stack/rods = 12)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/////////
//Toys///
/////////

/*
/datum/crafting_recipe/toysword
	name = "Toy Sword"
	reqs = list(/obj/item/light/bulb = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/material/plastic = 4)
	result = /obj/item/toy/sword
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/extendohand
	name = "Extendo-Hand"
	reqs = list(/obj/item/bodypart/r_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/toyneb
	name = "Non-Euplastic Blade"
	reqs = list(/obj/item/light/tube = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/material/plastic = 4)
	result = /obj/item/toy/sword/cx
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/catgirlplushie
	name = "Catgirl Plushie"
	reqs = list(/obj/item/toy/plush/hairball = 3)
	result = /obj/item/toy/plush/catgirl
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

////////////
//Unsorted//
////////////

/* Blacksmithed items.
/datum/crafting_recipe/stick
	name = "Stick"
	time = 30
	reqs = list(/obj/item/stack/material/wood = 1)
	result = /obj/item/stick
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/swordhilt
	name = "Sword Hilt"
	time = 30
	reqs = list(/obj/item/stack/material/wood = 2)
	result = /obj/item/swordhandle
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/paperframes
	name = "Paper Frames"
	result = /obj/item/stack/material/paperframes/five
	time = 10
	reqs = list(/obj/item/stack/material/wood = 5, /obj/item/paper = 20)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	time = 30
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/material/wood = 1)
	tools = list(/obj/item/material/knife/machete/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/*
/datum/crafting_recipe/bluespacehonker
	name = "Bluespace Bike horn"
	result = /obj/item/bikehorn/bluespacehonker
	time = 10
	reqs = list(/obj/item/stack/ore/bluespace_crystal = 1,
				/obj/item/toy/crayon/blue = 1,
				/obj/item/bikehorn = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

/datum/crafting_recipe/mousetrap
	name = "Mouse Trap"
	result = /obj/item/assembly/mousetrap
	time = 10
	reqs = list(/obj/item/stack/material/cardboard = 1,
				/obj/item/stack/rods = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/*
/datum/crafting_recipe/flashlight_eyes
	name = "Flashlight Eyes"
	result = /obj/item/organ/eyes/robotic/flashlight
	time = 10
	reqs = list(
		/obj/item/flashlight = 2,
		/obj/item/restraints/handcuffs/cable = 1
	)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/pressureplate
	name = "Pressure Plate"
	result = /obj/item/pressure_plate
	time = 5
	reqs = list(/obj/item/stack/material/metal = 1,
				  /obj/item/stack/tile/plasteel = 1,
				  /obj/item/stack/cable_coil = 2,
				  /obj/item/assembly/igniter = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

/datum/crafting_recipe/gold_horn
	name = "Golden Bike Horn"
	result = /obj/item/bikehorn/golden
	time = 20
	reqs = list(/obj/item/stack/material/bananium = 5,
				/obj/item/bikehorn = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/*
/datum/crafting_recipe/coconut_bong
	name = "Coconut Bong"
	result = /obj/item/bong/coconut
	reqs = list(/obj/item/stack/material/mineral/bamboo = 2,
				/obj/item/reagent_containers/food/snacks/grown/coconut = 1)
	time = 70
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS
*/

//////////////
//Banners/////
//////////////

/datum/crafting_recipe/command_banner
	name = "Command Banner"
	result = /obj/item/banner/command
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/suit/captunic = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/engineering_banner
	name = "Engitopia Banner"
	result = /obj/item/banner/engineering
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/engineer = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/cargo_banner
	name = "Cargonia Banner"
	result = /obj/item/banner/cargo
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/cargotech = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/science_banner
	name = "Sciencia Banner"
	result = /obj/item/banner/science
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/scientist = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/medical_banner
	name = "Meditopia Banner"
	result = /obj/item/banner/medical
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/medical = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/security_banner
	name = "Securistan Banner"
	result = /obj/item/banner/security
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/security = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISCELLANEOUS

//Double Air Tanks
/datum/crafting_recipe/double_tank_oxygen
	name = "Double Emergency Oxygen Tank"
	result = /obj/item/tank/emergency/oxygen/double
	time = 30
	reqs = list(/obj/item/tank/emergency/oxygen = 2,
				/obj/item/duct_tape_piece = 5)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_MISCELLANEOUS
	tools = list(TOOL_WRENCH, TOOL_WELDER)

/datum/crafting_recipe/double_tank_phoron
	name = "Double Emergency Phoron Tank"
	result = /obj/item/tank/emergency/phoron/double
	time = 30
	reqs = list(/obj/item/tank/emergency/phoron = 2,
				/obj/item/duct_tape_piece = 5)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_MISCELLANEOUS
	tools = list(TOOL_WRENCH, TOOL_WELDER)

/datum/crafting_recipe/double_tank_nitrogen
	name = "Double Emergency Nitrogen Tank"
	result = /obj/item/tank/emergency/nitrogen/double
	time = 30
	reqs = list(/obj/item/tank/emergency/nitrogen = 2,
				/obj/item/duct_tape_piece = 5)
	category = CAT_MISCELLANEOUS
	subcategory = CAT_MISCELLANEOUS
	tools = list(TOOL_WRENCH, TOOL_WELDER)
