/datum/crafting_recipe/mummy
	name = "Mummification Bandages (Mask)"
	result = /obj/item/clothing/mask/gas/mummy
	time = 10
	tools = list(/obj/item/nullrod/egyptian)
	reqs = list(/obj/item/stack/material/cloth = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy/body
	name = "Mummification Bandages (Body)"
	result = /obj/item/clothing/under/mummy
	reqs = list(/obj/item/stack/material/cloth = 5)

/* //Commenting these out until we add in a vector to harvest lizard skin and catgirl organs.
/datum/crafting_recipe/lizardhat
	name = "Lizard Cloche Hat"
	result = /obj/item/clothing/head/lizard
	time = 10
	reqs = list(/obj/item/organ/tail/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/lizardhat_alternate
	name = "Lizard Cloche Hat"
	result = /obj/item/clothing/head/lizard
	time = 10
	reqs = list(/obj/item/stack/sheet/animalhide/lizard = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/kittyears
	name = "Kitty Ears"
	result = /obj/item/clothing/head/kitty/genuine
	time = 10
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/organ/ears/cat = 1)
	category = CAT_CLOTHING
*/

/datum/crafting_recipe/papermask
	name = "Paper Mask"
	result = /obj/item/clothing/mask/paper
	time = 10
	reqs = list(/obj/item/paper = 20)
	category = CAT_CLOTHING

/datum/crafting_recipe/balaclavabreath
	name = "Breathaclava"
	result = /obj/item/clothing/mask/balaclava/breath
	time = 10
	reqs = list(/obj/item/clothing/mask/balaclava = 1,
				/obj/item/clothing/mask/breath = 1)
	category = CAT_CLOTHING

/*
/datum/crafting_recipe/armwraps
	name = "Armwraps"
	result = /obj/item/clothing/gloves/fingerless/pugilist/crafted
	time = 60
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/stack/sheet/cloth = 4,
				/obj/item/stack/sticky_tape = 2,
				/obj/item/stack/sheet/leather = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/armwrapsplusone
	name = "Armwraps of Mighty Fists"
	result = /obj/item/clothing/gloves/fingerless/pugilist/magic
	time = 300
	tools = list(TOOL_WIRECUTTER, /obj/item/book/codex_gigas, /obj/item/clothing/head/wizard, /obj/item/clothing/suit/wizrobe)
	reqs = list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/leather = 2,
				/obj/item/stack/sheet/durathread = 2,
				/datum/reagent/consumable/ethanol/sake = 100,
				/datum/reagent/consumable/ethanol/wizz_fizz = 100,
				/obj/item/stack/sheet/sinew = 1,
				/obj/item/stack/sheet/mineral/gold = 50)
	category = CAT_CLOTHING
*/

////////
//Huds//
////////

/datum/crafting_recipe/hudsunsec
	name = "Security HUDsunglasses"
	result = /obj/item/clothing/glasses/sunglasses/sechud
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/hud/security = 1,
					/obj/item/clothing/glasses/sunglasses = 1)
	reqs = list(/obj/item/clothing/glasses/hud/security = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunsecremoval
	name = "Security HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/sechud = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunmed
	name = "Medical HUDsunglasses"
	result = /obj/item/clothing/glasses/sunglasses/medhud
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/hud/health = 1,
				/obj/item/clothing/glasses/sunglasses = 1)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				/obj/item/clothing/glasses/sunglasses = 1,
				/obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunmedremoval
	name = "Medical HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/medhud = 1)
	category = CAT_CLOTHING

/* These don't exist in our code, and I'm not entirely sure that they can, as they are.
/datum/crafting_recipe/beergoggles
	name = "Beer Goggles"
	result = /obj/item/clothing/glasses/sunglasses/reagent
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/science = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/beergogglesremoval
	name = "Beer Goggles removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/sunglasses/reagent = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/diagnostic_sunglasses
	name = "Diagnostic HUDsunglasses"
	result = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				/obj/item/clothing/glasses/sunglasses = 1)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/diagnostic_sunglasses_removal
	name = "Diagnostic HUDsunglasses removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic/sunglasses = 1)
	category = CAT_CLOTHING

//Kevinz doesn't want it as a recipe for now, leaving it in if anything ever changes to let it in
/datum/crafting_recipe/stunglasses
	name = "Stunglasses"
	result = /obj/item/clothing/glasses/sunglasses/stunglasses
	time = 60
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/assembly/flash = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_CLOTHING

// Eyepatch Glasses We don't have these yet.

/datum/crafting_recipe/secpatch
	name = "Security Eyepatch HUD"
	result = /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/hud/security/sunglasses = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	reqs = list(/obj/item/clothing/glasses/hud/security/sunglasses = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/secpatch_removal
	name = "Security HUDpatch Removal"
	result = /obj/item/clothing/glasses/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/medpatch
	name = "Medical Eyepatch HUD"
	result = /obj/item/clothing/glasses/hud/health/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/hud/health = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	reqs = list(/obj/item/clothing/glasses/hud/health = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/medpatch_removal
	name = "Medical HUDpatch Removal"
	result = /obj/item/clothing/glasses/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/health/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/diagpatch
	name = "Diagnostic Eyepatch HUD"
	result = /obj/item/clothing/glasses/hud/diagnostic/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/diagpatch_removal
	name = "Diagnostic HUDpatch Removal"
	result = /obj/item/clothing/glasses/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/diagnostic/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/mesonpatch
	name = "Meson Scanner Eyepatch"
	result = /obj/item/clothing/glasses/meson/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	parts = list(/obj/item/clothing/glasses/meson = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	reqs = list(/obj/item/clothing/glasses/meson = 1,
				/obj/item/clothing/glasses/eyepatch = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/mesonpatch_removal
	name = "Meson Scanner patch Removal"
	result = /obj/item/clothing/glasses/eyepatch
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/meson/eyepatch = 1)
	category = CAT_CLOTHING
*/

/datum/crafting_recipe/ghostsheet
	name = "Ghost Sheet"
	result = /obj/item/clothing/head/ghost_sheet
	time = 5
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/bedsheet = 1)
	category = CAT_CLOTHING

/datum/crafting_recipe/briefcase
	name = "Hand made Briefcase"
	result = /obj/item/storage/briefcase/crafted
	time = 35
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/stack/material/cardboard = 1,
				/obj/item/stack/material/cloth = 2,
				/obj/item/stack/material/leather = 5)
	category = CAT_CLOTHING

/* Disabling these two for now because I can't find any mob icons for them.
/datum/crafting_recipe/medolier
	name = "Medolier"
	result =  /obj/item/storage/belt/medolier
	reqs = list(/obj/item/stack/sheet/metal = 2,
	/obj/item/stack/sheet/cloth = 3,
	/obj/item/stack/sheet/plastic = 4)
	time = 30
	category = CAT_CLOTHING

/datum/crafting_recipe/twinsheath
	name = "Twin Sword Sheath"
	result = /obj/item/storage/belt/sabre/twin
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3,
				/obj/item/stack/sheet/leather = 8)
	tools = list(TOOL_WIRECUTTER)
	time = 70
	category = CAT_CLOTHING

//Leaving the Durathread stuff out for now too, because I think this only matters for item health or something? I need more info before I even think about working with a new material type.
/datum/crafting_recipe/durathread_reinforcement_kit
	name = "Durathread Reinforcement Kit"
	result = /obj/item/armorkit
	reqs = list(/obj/item/stack/sheet/durathread = 4)
	tools = list(/obj/item/stack/sheet/mineral/titanium, TOOL_WIRECUTTER) // tough needle for a tough fabric
	time = 40
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_duffelbag
	name = "Durathread Dufflebag"
	result = /obj/item/storage/backpack/duffelbag/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 7,
				/obj/item/stack/sheet/leather = 3)
	time = 70
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_toolbelt
	name = "Durathread Toolbelt"
	result = /obj/item/storage/belt/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 5,
				/obj/item/stack/sheet/leather = 2)
	time = 30
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_bandolier
	name = "Durathread Bandolier"
	result = /obj/item/storage/belt/bandolier/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 6,
				/obj/item/stack/sheet/leather = 2)
	time = 50
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_helmet
	name = "Makeshift Durathread Helmet"
	result = /obj/item/clothing/head/helmet/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 4,
				/obj/item/stack/sheet/leather = 2)
	time = 30
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_vest
	name = "Makeshift Durathread Armour"
	result = /obj/item/clothing/suit/armor/vest/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 6,
				/obj/item/stack/sheet/leather = 3)
	time = 50
	category = CAT_CLOTHING

/datum/crafting_recipe/durathread_wintercoat
	name = "Durathread Winter Coat"
	result = /obj/item/clothing/suit/hooded/wintercoat/durathread
	reqs = list(/obj/item/stack/sheet/durathread = 12,
				/obj/item/stack/sheet/leather = 10)
	time = 70
	category = CAT_CLOTHING
*/

/datum/crafting_recipe/wintercoat_cosmic
	name = "Cosmic Winter Coat"
	result = /obj/item/clothing/suit/storage/hooded/wintercoat/cosmic
	reqs = list(/obj/item/clothing/suit/storage/hooded/wintercoat = 1,
				/obj/item/bedsheet/cosmos = 1)
	time = 60
	category = CAT_CLOTHING

/* We don't have garlic yet.
/datum/crafting_recipe/garlic_necklace
	name = "Garlic Necklace"
	result = /obj/item/clothing/neck/garlic_necklace
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/garlic = 15,
				/obj/item/stack/cable_coil = 10)
	time = 100 //Takes awhile to put all the garlics on the coil and knot it.
	category = CAT_CLOTHING

//Bro I don't even know what these DO.
/datum/crafting_recipe/gripperoffbrand
	name = "Improvised Gripper Gloves"
	reqs = list(
            /obj/item/clothing/gloves/fingerless = 1,
         //   /obj/item/stack/sticky_tape = 1
		 	/obj/item/stack/cable_coil = 5,
			/obj/item/stack/sheet/cloth = 2,
	)
	result = /obj/item/clothing/gloves/tackler/offbrand
	category = CAT_CLOTHING
	tools = list(TOOL_WIRECUTTER)
	time = 20
*/

//Holsters
/datum/crafting_recipe/holster_shoulder
	name = "Holster (Shoulder)"
	result = /obj/item/clothing/accessory/holster
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/plastic = 2,
				/obj/item/stack/material/cloth = 1,
				/obj/item/stack/material/leather = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/holster_armpit
	name = "Holster (Armpit)"
	result = /obj/item/clothing/accessory/holster/armpit
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/plastic = 2,
				/obj/item/stack/material/cloth = 1,
				/obj/item/stack/material/leather = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/holster_waist
	name = "Holster (Waist)"
	result = /obj/item/clothing/accessory/holster/waist
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/plastic = 2,
				/obj/item/stack/material/cloth = 1,
				/obj/item/stack/material/leather = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/holster_hip
	name = "Holster (Hip)"
	result = /obj/item/clothing/accessory/holster/hip
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/plastic = 2,
				/obj/item/stack/material/cloth = 1,
				/obj/item/stack/material/leather = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/holster_leg
	name = "Holster (Leg))"
	result = /obj/item/clothing/accessory/holster/leg
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/plastic = 2,
				/obj/item/stack/material/cloth = 1,
				/obj/item/stack/material/leather = 5)
	category = CAT_CLOTHING

/datum/crafting_recipe/holster_machete
	name = "Holster (Machete)"
	result = /obj/item/clothing/accessory/holster/machete
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/plastic = 4,
				/obj/item/stack/material/leather = 6)
	category = CAT_CLOTHING

/datum/crafting_recipe/holster_kineticaccel
	name = "Holster (Kinetic Accelerator)"
	result = /obj/item/clothing/accessory/holster/waist/kinetic_accelerator
	time = 35
	tools = list(TOOL_WIRECUTTER,
				TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/steel = 3,
				/obj/item/stack/material/leather = 8)
	category = CAT_CLOTHING
