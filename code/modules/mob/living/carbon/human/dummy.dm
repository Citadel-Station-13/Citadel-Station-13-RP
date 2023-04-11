/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = STATUS_GODMODE | STATUS_CAN_PUSH
	no_vore = TRUE //Dummies don't need bellies.

// NO STOP USING THESE FOR ANYTHING BUT PREFS SETUP
// MAKE SOMETHING THAT ISN'T /HUMAN IF YOU JUST WANT A MANNEQUIN THIS IS NOT HARD TO FIGURE OUT
// DONT USE THE SUPER COMPLICATED PLAYER MOB WITH ORGANS FOR A *MANNEQUIN*, WHY??
INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy/mannequin)
/mob/living/carbon/human/dummy/mannequin
	/// currently locked for usage
	var/in_use = FALSE

/mob/living/carbon/human/dummy/mannequin/Initialize(mapload)
	. = ..()
	GLOB.mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/proc/wipe_state()
	delete_inventory(TRUE, TRUE)
	set_species(/datum/species/human, TRUE, TRUE)

/mob/living/carbon/human/dummy/mannequin/proc/unset_busy()
	wipe_state()
	in_use = FALSE

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy/mannequin
	var/mob/living/carbon/human/dummy/mannequin/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	else
		pass()
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	else
		D.regenerate_icons() //they were cut in wipe_state()
	D.in_use = TRUE
	return D

/*
/proc/generate_dummy_lookalike(slotkey, mob/target)
	if(!istype(target))
		return generate_or_wait_for_human_dummy(slotkey)

	var/mob/living/carbon/human/dummy/mannequin/copycat = generate_or_wait_for_human_dummy(slotkey)

	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.dna.transfer_identity(copycat, transfer_SE = TRUE)

		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			human_target.copy_clothing_prefs(copycat)

		copycat.updateappearance(icon_update=TRUE, mutcolor_update=TRUE, mutations_overlay_update=TRUE)
	else
		//even if target isn't a carbon, if they have a client we can make the
		//dummy look like what their human would look like based on their prefs
		target?.client?.prefs?.copy_to(copycat, icon_updates=TRUE, roundstart_checks=FALSE)

	return copycat
*/

/proc/unset_busy_human_dummy(slotkey)
	if(!slotkey)
		return
	var/mob/living/carbon/human/dummy/mannequin/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		D.unset_busy()

/proc/clear_human_dummy(slotkey)
	if(!slotkey)
		return

	var/mob/living/carbon/human/dummy/mannequin/dummy = GLOB.human_dummy_list[slotkey]

	GLOB.human_dummy_list -= slotkey
	if(istype(dummy))
		GLOB.dummy_mob_list -= dummy
		qdel(dummy)

//? old/legacy stuff below, do not use

/mob/living/carbon/human/dummy/mannequin/default/Initialize(mapload)
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	weight = rand(100,175)
	gender = pick(MALE,FEMALE,NEUTER)

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
