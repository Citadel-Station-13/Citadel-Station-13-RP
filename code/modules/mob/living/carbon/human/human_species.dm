/mob/living/carbon/human/skrell
	h_style = "Skrell Short Tentacles"
	species = /datum/species/skrell

/mob/living/carbon/human/tajaran
	h_style = "Tajaran Ears"
	species = /datum/species/tajaran

/mob/living/carbon/human/unathi
	h_style = "Unathi Horns"
	species = /datum/species/unathi

/mob/living/carbon/human/vox
	h_style = "Short Vox Quills"
	species = /datum/species/vox

/mob/living/carbon/human/diona
	species = /datum/species/diona

/mob/living/carbon/human/teshari
	h_style = "Teshari Default"
	species = /datum/species/teshari

/mob/living/carbon/human/promethean
	species = /datum/species/shapeshifter/promethean

/mob/living/carbon/human/zaddat
	species = /datum/species/zaddat

/mob/living/carbon/human/monkey
	species = /datum/species/monkey

/mob/living/carbon/human/farwa
	species = /datum/species/monkey/tajaran

/mob/living/carbon/human/neaera
	species = /datum/species/monkey/skrell

/mob/living/carbon/human/stok
	species = /datum/species/monkey/unathi

/mob/living/carbon/human/sergal
	h_style = "Sergal Plain"
	species = /datum/species/naramadi

/mob/living/carbon/human/akula
	species = /datum/species/akula

/mob/living/carbon/human/nevrean
	species = /datum/species/nevrean

/mob/living/carbon/human/xenochimera
	species = /datum/species/shapeshifter/xenochimera

/mob/living/carbon/human/xenohybrid
	species = /datum/species/xenohybrid

/mob/living/carbon/human/spider
	species = /datum/species/vasilissan

/mob/living/carbon/human/vulpkanin
	species = /datum/species/vulpkanin

/mob/living/carbon/human/protean
	species = /datum/species/protean

/mob/living/carbon/human/alraune
	species = /datum/species/alraune

/mob/living/carbon/human/apidaen
	species = /datum/species/apidaen

/mob/living/carbon/human/auril
	species = /datum/species/auril

/mob/living/carbon/human/dremachir
	species = /datum/species/dremachir

/mob/living/carbon/human/shadekin
	species = /datum/species/shadekin

/mob/living/carbon/human/adherent
	species = /datum/species/adherent

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

/mob/living/carbon/human/dummy/mannequin/Initialize(mapload)
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
				H.equip_to_slot_or_del(new PICK(H), SLOT_ID_UNIFORM)
				H.update_inv_w_uniform()
			if(!glasses)
				var/list/options = typesof(/obj/item/clothing/glasses)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), SLOT_ID_GLASSES)
				H.update_inv_glasses()
			if(!shoes)
				var/list/options = typesof(/obj/item/clothing/shoes)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), SLOT_ID_SHOES)
				H.update_inv_shoes()

/mob/living/carbon/human/dummy/mannequin/plastic/Initialize(mapload)
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
				H.equip_to_slot_or_del(new PICK(H), SLOT_ID_UNIFORM)
				H.update_inv_w_uniform()
			if(!glasses)
				var/list/options = typesof(/obj/item/clothing/glasses)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), SLOT_ID_GLASSES)
				H.update_inv_glasses()
			if(!shoes)
				var/list/options = typesof(/obj/item/clothing/shoes)
				var/PICK= options[rand(1,options.len)]
				H.equip_to_slot_or_del(new PICK(H), SLOT_ID_SHOES)
				H.update_inv_shoes()

/mob/living/carbon/human/dummy/mannequin/samurai/Initialize(mapload)
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
				H.equip_to_slot_or_del(new /obj/item/clothing/under/color/black, SLOT_ID_UNIFORM)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/duty, SLOT_ID_SHOES)
				H.update_inv_shoes()
			if(!gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black, SLOT_ID_GLOVES)
				H.update_inv_gloves()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/samurai, SLOT_ID_MASK)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/samurai, SLOT_ID_HEAD)
				H.update_inv_head()
			if(!wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/samurai, SLOT_ID_SUIT)
				H.update_inv_wear_suit()

/mob/living/carbon/human/dummy/mannequin/animegirl/Initialize(mapload)
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
				H.equip_to_slot_or_del(new /obj/item/clothing/under/schoolgirl, SLOT_ID_UNIFORM)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/hitops/black, SLOT_ID_SHOES)
				H.update_inv_shoes()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/medical, SLOT_ID_MASK)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/bunny, SLOT_ID_HEAD)
				H.update_inv_head()
			if(!glasses)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/plain/eyepatch, SLOT_ID_SUIT)
				H.update_inv_glasses()

/mob/living/carbon/human/dummy/mannequin/mummy/Initialize(mapload)
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
				H.equip_to_slot_or_del(new /obj/item/clothing/under/mummy, SLOT_ID_UNIFORM)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal, SLOT_ID_SHOES)
				H.update_inv_shoes()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mummy, SLOT_ID_MASK)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/nemes, SLOT_ID_HEAD)
				H.update_inv_head()
			if(!wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/pharaoh, SLOT_ID_SUIT)
				H.update_inv_wear_suit()

/mob/living/carbon/human/dummy/mannequin/scarecrow/Initialize(mapload)
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
				H.equip_to_slot_or_del(new /obj/item/clothing/under/scarecrow, SLOT_ID_UNIFORM)
				H.update_inv_w_uniform()
			if(!shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/workboots, SLOT_ID_SHOES)
				H.update_inv_shoes()
			if(!wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/scarecrow, SLOT_ID_MASK)
				H.update_inv_wear_mask()
			if(!head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/scarecrow, SLOT_ID_HEAD)
				H.update_inv_head()
			if(!gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather, SLOT_ID_SUIT)
				H.update_inv_gloves()
