/mob/living/carbon/human/skrell/Initialize(var/new_loc)
	h_style = "Skrell Short Tentacles"
	return ..(new_loc, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/Initialize(var/new_loc)
	h_style = "Tajaran Ears"
	return ..(new_loc, SPECIES_TAJ)

/mob/living/carbon/human/unathi/Initialize(var/new_loc)
	h_style = "Unathi Horns"
	return ..(new_loc, SPECIES_UNATHI)

/mob/living/carbon/human/vox/Initialize(var/new_loc)
	h_style = "Short Vox Quills"
	return ..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/diona/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/teshari/Initialize(var/new_loc)
	h_style = "Teshari Default"
	return ..(new_loc, SPECIES_TESHARI)

/mob/living/carbon/human/promethean/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_PROMETHEAN)

/mob/living/carbon/human/zaddat/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_ZADDAT)

/mob/living/carbon/human/monkey/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_TAJ)

/mob/living/carbon/human/neaera/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_SKRELL)

/mob/living/carbon/human/stok/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_UNATHI)

/mob/living/carbon/human/event1/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_EVENT1)

/mob/living/carbon/human/sergal/Initialize(mapload, new_species)
	h_style = "Sergal Plain"
	return ..(mapload, SPECIES_SERGAL)

/mob/living/carbon/human/akula/Initialize(mapload)
	return ..(mapload, SPECIES_AKULA)

/mob/living/carbon/human/nevrean/Initialize(mapload)
	return ..(mapload, SPECIES_NEVREAN)

/mob/living/carbon/human/xenochimera/Initialize(mapload)
	return ..(mapload, SPECIES_XENOCHIMERA)

/mob/living/carbon/human/xenohybrid/Initialize(mapload, new_species)
	return ..(mapload, SPECIES_XENOHYBRID)

/mob/living/carbon/human/spider/Initialize(mapload)
	return ..(mapload, SPECIES_VASILISSAN)

/mob/living/carbon/human/vulpkanin/Initialize(mapload)
	return ..(mapload, SPECIES_VULPKANIN)

/mob/living/carbon/human/protean/Initialize(mapload)
	return ..(mapload, SPECIES_PROTEAN)

/mob/living/carbon/human/alraune/Initialize(mapload)
	return ..(mapload, SPECIES_ALRAUNE)

/mob/living/carbon/human/apidaen/Initialize(mapload)
	return ..(mapload, SPECIES_APIDAEN)

/mob/living/carbon/human/vetala_ruddy/Initialize(mapload)
	return ..(mapload, "Vetala (Ruddy)")

/mob/living/carbon/human/vetala_pale/Initialize(mapload)
	return ..(mapload, "Vetala (Pale)")

/mob/living/carbon/human/auril/Initialize(mapload)
	return ..(mapload, SPECIES_AURIL)

/mob/living/carbon/human/dremachir/Initialize(mapload)
	return ..(mapload, SPECIES_DREMACHIR)

/mob/living/carbon/human/shadekin/Initialize(mapload)
	return ..(mapload, SPECIES_SHADEKIN)

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	no_vore = TRUE //Dummies don't need bellies.

// species_flags --> NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_MINOR_CUT | NO_BLOOD | UNDEAD | NO_DEFIB
// though this is probably unnecessary because **why** are dummies ever in the game world? fuck off.


// /mob/living/carbon/human/dummy/mannequin/Initialize()
// 	. = ..()
// 	GLOB.mob_list -= src
// 	living_mob_list -= src
// 	dead_mob_list -= src
// 	delete_inventory()

//Fashion Mannequins

// NO STOP USING THESE FOR ANYTHING BUT PREFS SETUP
// MAKE SOMETHING THAT ISN'T /HUMAN IF YOU JUST WANT A MANNEQUIN THIS IS NOT HARD TO FIGURE OUT
// DONT USE THE SUPER COMPLICATED PLAYER MOB WITH ORGANS FOR A *MANNEQUIN*, WHY??
INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy/mannequin)
/mob/living/carbon/human/dummy/mannequin

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(100,175)
	gender = pick(MALE,FEMALE,NEUTER)
	delete_inventory()

	// whoever wrote this, wow, you are bad at codde
	// we'll deal with this later, jfc ~silicons
	for(var/mob/living/carbon/human/dummy/mannequin/H in src.loc)
		for(var/i = 1, i <= 2, i++)
			if(!w_uniform)
				var/list/options = typesof(/obj/item/clothing/under)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), slot_w_uniform)
				H.update_inv_w_uniform()
			if(!glasses)
				var/list/options = typesof(/obj/item/clothing/glasses)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), slot_glasses)
				H.update_inv_glasses()
			if(!shoes)
				var/list/options = typesof(/obj/item/clothing/shoes)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), slot_shoes)
				H.update_inv_shoes()

/mob/living/carbon/human/dummy/mannequin/plastic/Initialize()
	. = ..()
	name = "Plastic Mannequin"
	real_name = "Plastic Mannequin"
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(76,175)
	gender = pick(MALE,FEMALE,NEUTER)
	change_skin_color(255, 255, 255)
	delete_inventory()

	for(var/mob/living/carbon/human/dummy/mannequin/plastic/H in src.loc)
		for(var/i = 1, i <= 2, i++)
			if(!w_uniform)
				var/list/options = typesof(/obj/item/clothing/under)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), slot_w_uniform)
				H.update_inv_w_uniform()
			if(!glasses)
				var/list/options = typesof(/obj/item/clothing/glasses)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), slot_glasses)
				H.update_inv_glasses()
			if(!shoes)
				var/list/options = typesof(/obj/item/clothing/shoes)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), slot_shoes)
				H.update_inv_shoes()

/mob/living/carbon/human/dummy/mannequin/samurai/Initialize()
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(76,175)
	gender = pick(MALE,NEUTER)
	delete_inventory()

	for(var/mob/living/carbon/human/dummy/mannequin/samurai/H in src.loc)
		for(var/i = 1, i <= 2, i++)
			if(!w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/color/black, slot_w_uniform)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/duty, slot_shoes)
				H.update_inv_shoes()
			if(!gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black, slot_gloves)
				H.update_inv_gloves()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/samurai, slot_wear_mask)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/samurai, slot_head)
				H.update_inv_head()
			if(!wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/samurai, slot_wear_suit)
				H.update_inv_wear_suit()

/mob/living/carbon/human/dummy/mannequin/animegirl/Initialize()
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(76,175)
	gender = pick(FEMALE,NEUTER)
	delete_inventory()

	for(var/mob/living/carbon/human/dummy/mannequin/animegirl/H in src.loc)
		for(var/i = 1, i <= 2, i++)
			if(!w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/schoolgirl, slot_w_uniform)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/hitops/black, slot_shoes)
				H.update_inv_shoes()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/medical, slot_wear_mask)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/bunny, slot_head)
				H.update_inv_head()
			if(!glasses)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/plain/eyepatch, slot_wear_suit)
				H.update_inv_glasses()

/mob/living/carbon/human/dummy/mannequin/mummy/Initialize()
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(76,175)
	gender = pick(MALE,FEMALE,NEUTER)
	delete_inventory()

	for(var/mob/living/carbon/human/dummy/mannequin/mummy/H in src.loc)
		for(var/i = 1, i <= 2, i++)
			if(!w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/mummy, slot_w_uniform)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal, slot_shoes)
				H.update_inv_shoes()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mummy, slot_wear_mask)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/nemes, slot_head)
				H.update_inv_head()
			if(!wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/pharaoh, slot_wear_suit)
				H.update_inv_wear_suit()

/mob/living/carbon/human/dummy/mannequin/scarecrow/Initialize()
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(76,175)
	gender = pick(MALE,FEMALE,NEUTER)
	delete_inventory()

	for(var/mob/living/carbon/human/dummy/mannequin/scarecrow/H in src.loc)
		for(var/i = 1, i <= 2, i++)
			if(!w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/under/scarecrow, slot_w_uniform)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/workboots, slot_shoes)
				H.update_inv_shoes()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/scarecrow, slot_wear_mask)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/scarecrow, slot_head)
				H.update_inv_head()
			if(!gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather, slot_wear_suit)
				H.update_inv_gloves()

/mob/living/carbon/human/adherent/New(var/new_loc)
	return ..(new_loc, SPECIES_ADHERENT)
