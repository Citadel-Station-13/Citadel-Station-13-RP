/* Re-Removing this one. It's very bugged currently, and we have a dedicated system elsewhere, so it won't impact things too much.
/datum/crafting_recipe/pin_removal
	name = "Pin Removal"
	result = /obj/item/gun
	reqs = list(/obj/item/gun = 1)
	parts = list(/obj/item/gun = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/pin_removal/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/gun/G = collected_requirements[/obj/item/gun][1]
	if (G.no_pin_required || !G.pin)
		return FALSE
	return TRUE
*/

/datum/crafting_recipe/strobeshield
	name = "Strobe Shield"
	result = /obj/item/shield/riot/flash
	reqs = list(/obj/item/frame = 1,
				/obj/item/flash = 1,
				/obj/item/shield/riot = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/strobeshield/New()
	..()
	blacklist |= subtypesof(/obj/item/shield/riot/)

/datum/crafting_recipe/makeshiftshield
	name = "Makeshift Metal Shield"
	result = /obj/item/shield/makeshift
	reqs = list(/obj/item/stack/cable_coil = 30,
				/obj/item/stack/material/steel = 10,
				/obj/item/stack/material/cloth = 2,
				/obj/item/stack/material/leather = 3)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/spear
	name = "Spear"
	result = /obj/item/material/twohanded/spear
	reqs = list(/obj/item/handcuffs/cable = 1,
				/obj/item/material/shard = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/material/shard = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/stunprod
	name = "Stunprod"
	result = /obj/item/melee/baton/cattleprod
	reqs = list(/obj/item/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/teleprod
	name = "Teleprod"
	result = /obj/item/melee/baton/cattleprod/teleprod
	reqs = list(/obj/item/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/ore/bluespace_crystal = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/newsbaton
	name = "Newspaper Baton"
	result = /obj/item/melee/telebaton/newspaper
	reqs = list(/obj/item/melee/telebaton = 1,
				/obj/item/newspaper = 1,
				/obj/item/duct_tape_piece = 2)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/bokken
	name = "Training Bokken"
	result = /obj/item/melee/bokken
	tools = list(TOOL_SCREWDRIVER)
	reqs = list(/obj/item/bokken_blade = 1,
				/obj/item/bokken_hilt = 1,
				/obj/item/stack/material/cloth = 2,
				/obj/item/stack/material/leather = 1)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/bokken_hardwood
	name = "Training Hardwood Bokken"
	result = /obj/item/melee/bokken/hardwood
	tools = list(TOOL_SCREWDRIVER)
	reqs = list(/obj/item/bokken_blade/hardwood = 1,
				/obj/item/bokken_hilt = 1,
				/obj/item/stack/material/cloth = 2,
				/obj/item/stack/material/leather = 1)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/wakibokken
	name = "Training Wakizashi Bokken"
	result = /obj/item/melee/bokken/waki
	tools = list(TOOL_SCREWDRIVER)
	reqs = list(/obj/item/wakibokken_blade = 1,
				/obj/item/bokken_hilt = 1,
				/obj/item/stack/material/cloth = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/wakibokken_hardwood
	name = "Training Wakizashi Hardwood Bokken"
	result = /obj/item/melee/bokken/waki/hardwood
	tools = list(TOOL_SCREWDRIVER)
	reqs = list(/obj/item/wakibokken_blade/hardwood = 1,
				/obj/item/bokken_hilt = 1,
				/obj/item/stack/material/cloth = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/kanabo
	name = "Kanabo"
	result = /obj/item/melee/kanabo
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/kanabo_shaft = 1,
				/obj/item/kanabo_studs = 1,
				/obj/item/stack/material/cloth = 3,
				/obj/item/stack/material/leather = 2)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/knuckle_dusters
	name = "Brass Knuckles"
	result = /obj/item/clothing/gloves/knuckledusters
	tools = list(TOOL_WELDER)
	reqs = list(/obj/item/stack/material/brass = 5,
				/obj/item/stack/material/steel = 5)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/tonfa
	name = "Tonfa"
	result = /obj/item/melee/classic_baton/tonfa
	tools = list(/obj/item/material/knife/machete/hatchet)
	reqs = list(/obj/item/stack/material/wood = 6,
				/obj/item/stack/material/steel = 2)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/handcuffs/legcuffs/bola
	reqs = list(/obj/item/handcuffs/cable = 1,
				/obj/item/stack/material/steel = 6)
	time = 20//15 faster than crafting them by hand!
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/* We don't have amputation features for this yet?
/datum/crafting_recipe/tailclub
	name = "Tail Club"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
	            /obj/item/stack/material/steel = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/tailwhip
	name = "Liz O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE
*/

/datum/crafting_recipe/chainsaw
	name = "Chainsaw"
	result = /obj/item/chainsaw
	reqs = list(/obj/item/surgical/circular_saw = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/stock_parts/motor = 1,
				/obj/item/stack/material/plasteel = 5)
	tools = list(TOOL_WELDER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/chainsword
	name = "Chainsaw Sword"
	result = /obj/item/chainsaw/chainsword
	reqs = list(/obj/item/chainsaw = 1,
				/obj/item/stock_parts/motor = 1,
				/obj/item/stack/material/durasteel = 5)
	tools = list(TOOL_WELDER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

//////////////////
///BOMB CRAFTING//
//////////////////

/* I think these are for syndie bombs? Requires investigation.
/datum/crafting_recipe/chemical_payload
	name = "Chemical Payload (C4)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/plastic/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/chemical_payload2
	name = "Chemical Payload (Gibtonite)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER
*/

/* The molotov isn't a formal item in our codebase, and I think it would cheapen things to make it one.
/datum/crafting_recipe/molotov
	name = "Molotov"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/glass/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
*/

/datum/crafting_recipe/punctured_can
	name = "Punctured Can"
	result = /obj/item/trash/punctured_can
	reqs = list(/obj/item/reagent_containers/food/drinks/cans = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/IED
	name = "IED"
	result = /obj/item/grenade/explosive/ied
	reqs = list(/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/trash/punctured_can = 1)
	tools = list(TOOL_WELDER)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/lance
	name = "Explosive Lance (Grenade)"
	result = /obj/item/material/twohanded/spear
	reqs = list(/obj/item/material/twohanded/spear = 1,
				/obj/item/grenade = 1)
	parts = list(/obj/item/material/twohanded/spear = 1,
				/obj/item/grenade = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/tyrmalin_heavy
	name = "Tyrmalin heavy-duty mining charge"
	result = /obj/item/grenade/explosive/ied/tyrmalin/large
	reqs = list(/obj/item/grenade/explosive/ied/tyrmalin = 3,
				/obj/item/duct_tape_piece = 4)
	parts = list(/obj/item/grenade/explosive/ied/tyrmalin = 3,
				/obj/item/duct_tape_piece = 4)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

//////////////////
///GUNS CRAFTING//
//////////////////

/datum/crafting_recipe/pipebow
	name = "Pipe Bow"
	result =  /obj/item/gun/ballistic/bow/pipe
	reqs = list(/obj/item/pipe = 5,
	/obj/item/stack/material/plastic = 15,
	/obj/item/weaponcrafting/string = 5)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/dartgun
	name = "prototype dart gun"
	result =  /obj/item/gun/ballistic/dartgun/research
	reqs = list(/obj/item/stack/material/steel = 10,
	/obj/item/stack/material/glass = 5,
	/obj/item/tank/emergency/oxygen = 1,
	/obj/item/reagent_containers/glass/beaker = 1,
	/obj/item/stack/material/plastic = 5,
	/obj/item/stack/cable_coil = 1)
	time = 150 //It's a gun
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/smartdart
	name = "dart gun magazine"
	result =  /obj/item/ammo_magazine/chemdart
	reqs = list(/obj/item/stack/material/steel = 5,
				/obj/item/stack/material/glass = 2,
				/obj/item/stack/material/plastic = 5)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/rapiddartgun
	name = "dart gun"
	result = /obj/item/gun/ballistic/dartgun
	reqs = list(
		/obj/item/ammo_casing/chemdart = 1,
		/obj/item/stack/material/plastic = 5,
		/obj/item/stack/cable_coil = 1,
		/obj/item/reagent_containers/glass/beaker = 1
	)
	parts = list(/obj/item/reagent_containers/glass/beaker = 1)
	time = 120 //Modifying your gun
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/improvised_pneumatic_cannon
	name = "Pneumatic Cannon"
	result = /obj/item/gun/launcher/pneumatic
	tools = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(/obj/item/cannonframe = 1,
				/obj/item/stack/material/steel = 4,
				/obj/item/duct_tape_piece = 8,
				/obj/item/pipe = 2)
	time = 300
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/flamethrower //Gun*
	name = "Flamethrower"
	result = /obj/item/flamethrower
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/assembly/igniter = 1,
				/obj/item/weldingtool = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

//Note: Changing this from an improvised shotgun to a pipe rifle. Code will be virtually identical. Perhaps we'll make both eventually.
/*
/datum/crafting_recipe/ishotgun
	name = "Improvised Shotgun"
	result = /obj/item/gun/ballistic/revolver/doublebarrel/improvised
	reqs = list(/obj/item/pipe = 1,
				/obj/item/weaponcrafting/receiver = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/duct_tape_piece = 5,)
	tools = list(TOOL_SCREWDRIVER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
*/

/datum/crafting_recipe/piperifle
	name = "pipe rifle"
	result = /obj/item/gun/ballistic/contender/pipegun
	reqs = list(/obj/item/pipe = 1,
				/obj/item/weaponcrafting/receiver = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/duct_tape_piece = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

//////////////////
///AMMO CRAFTING//
//////////////////

//Arrows
/datum/crafting_recipe/arrow
	name = "Arrow"
	result = /obj/item/ammo_casing/arrow/wood
	time = 5 // these only do 15 damage
	reqs = list(/obj/item/stack/material/wood = 1,
				 /obj/item/stack/material/cloth = 1,
				 /obj/item/stack/rods = 1) // 1 metal sheet = 2 rods = 2 arrows
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ashen_arrow
	name = "Ashen Arrow"
	result = /obj/item/ammo_casing/arrow/ash
	tools = list(TOOL_WELDER)
	time = 10 // 1.5 seconds minimum per actually worthwhile arrow excluding interface lag
	//always_available = FALSE
	reqs = list(/obj/item/ammo_casing/arrow/wood = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/bone_arrow
	name = "Bone Arrow"
	result = /obj/item/ammo_casing/arrow/bone
	time = 5
	//always_available = FALSE
	reqs = list(/obj/item/stack/material/bone = 1,
				 /obj/item/stack/sinew = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

/datum/crafting_recipe/hard_bone_arrow
	name = "Hardened Bone Arrow"
	result = /obj/item/ammo_casing/arrow/bone_ap
	tools = list(TOOL_WELDER)
	time = 5
	//always_available = FALSE
	reqs = list(/obj/item/stack/material/bone = 1,
				 /obj/item/ammo_casing/arrow/bone = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_available = FALSE

//Munitions
/datum/crafting_recipe/smartdart
	name = "chemical dart"
	result =  /obj/item/ammo_casing/chemdart
	reqs = list(/obj/item/stack/material/steel = 1,
				/obj/item/stack/material/glass = 1,
				/obj/item/stack/material/plastic = 1)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/a12g/improvised
	reqs = list(/obj/item/grenade/chem_grenade = 1,
				/obj/item/stack/material/steel = 1,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/meteorslug
	name = "Meteorslug Shell"
	result = /obj/item/ammo_casing/a12g/techshell/meteorslug
	reqs = list(/obj/item/ammo_casing/a12g/techshell = 1,
				/obj/item/rcd_ammo = 1,
				/obj/item/stock_parts/manipulator = 2)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/a12g/techshell/pulseslug
	reqs = list(/obj/item/ammo_casing/a12g/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/a12g/techshell/dragonsbreath
	reqs = list(/obj/item/ammo_casing/a12g/techshell = 1,
				/datum/reagent/phosphorus = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/a12g/techshell/frag12
	reqs = list(/obj/item/ammo_casing/a12g/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/acid = 5,
				/datum/reagent/acid/polyacid = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/a12g/techshell/emp
	reqs = list(/obj/item/ammo_casing/a12g/techshell = 1,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/subspace/crystal = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/laserslug
	name = "Scatter Laser Shell"
	result = /obj/item/ammo_casing/a12g/techshell/laserslug
	reqs = list(/obj/item/ammo_casing/a12g/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 1,
				/obj/item/stock_parts/micro_laser/high = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/leadball
	name = "Lead Ball"
	result = /obj/item/ammo_casing/musket
	reqs = list(/obj/item/stack/material/lead = 1)
	tools = list(TOOL_WELDER, TOOL_WIRECUTTER)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

////////////////////
// PARTS CRAFTING //
////////////////////

// BOKKEN CRAFTING

/datum/crafting_recipe/bokken_blade
	name = "Training Bokken Blade"
	result = /obj/item/bokken_blade
	tools = list(/obj/item/material/knife/machete/hatchet)
	reqs = list(/obj/item/stack/material/wood = 10)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/wakibokken_blade
	name = "Training Wakizashi Bokken Blade"
	result = /obj/item/wakibokken_blade
	tools = list(/obj/item/material/knife/machete/hatchet)
	reqs = list(/obj/item/stack/material/wood = 5)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/bokken_blade/hardwood
	name = "Training Hardwood Bokken Blade"
	result = /obj/item/bokken_blade/hardwood
	tools = list(/obj/item/material/knife/machete/hatchet, TOOL_WELDER)
	reqs = list(/obj/item/stack/material/wood/hard = 10)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/wakibokken_blade/hardwood
	name = "Training Wakizashi Hardwood Bokken Blade"
	result = /obj/item/wakibokken_blade/hardwood
	tools = list(/obj/item/material/knife/machete/hatchet, TOOL_WELDER)
	reqs = list(/obj/item/stack/material/wood/hard = 5)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/bokken_hilt
	name = "Training Bokken hilt"
	result = /obj/item/bokken_hilt
	tools = list(/obj/item/material/knife/machete/hatchet)
	reqs = list(/obj/item/stack/material/wood = 5,
				/obj/item/stack/material/cloth = 2)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

// KANABO CRAFTING
/datum/crafting_recipe/kanabo_shaft
	name = "Kanabo Shaft"
	result = /obj/item/kanabo_shaft
	tools = list(/obj/item/material/knife/machete/hatchet)
	reqs = list(/obj/item/stack/material/wood = 20,
				/obj/item/stack/material/cloth = 2)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/kanabo_studs
	name = "Kanabo Studs"
	result = /obj/item/kanabo_studs
	reqs = list(/obj/item/stack/material/steel = 5)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
