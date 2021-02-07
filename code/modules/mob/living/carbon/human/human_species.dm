/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

	/mob/living/carbon/human/dummy/proc/get_icon()

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	delete_inventory()

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

/mob/living/carbon/human/dummy
	no_vore = TRUE //Dummies don't need bellies.

/mob/living/carbon/human/sergal/New(var/new_loc)
	h_style = "Sergal Plain"
	..(new_loc, "Sergal")

/mob/living/carbon/human/akula/New(var/new_loc)
	..(new_loc, "Akula")

/mob/living/carbon/human/nevrean/New(var/new_loc)
	..(new_loc, "Nevrean")

/mob/living/carbon/human/xenochimera/New(var/new_loc)
	..(new_loc, "Xenochimera")

/mob/living/carbon/human/xenohybrid/New(var/new_loc)
	..(new_loc, "Xenomorph Hybrid")

/mob/living/carbon/human/spider/New(var/new_loc)
	..(new_loc, "Vasilissan")

/mob/living/carbon/human/vulpkanin/New(var/new_loc)
	..(new_loc, "Vulpkanin")

/mob/living/carbon/human/protean/New(var/new_loc)
	..(new_loc, "Protean")

/mob/living/carbon/human/alraune/New(var/new_loc)
	..(new_loc, "Alraune")

/mob/living/carbon/human/shadekin/New(var/new_loc)
	..(new_loc, SPECIES_SHADEKIN)

//Fashion Mannequins
/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	name = "Wooden Mannequin"
	real_name = "Wooden Mannequin"
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(25,175)
	gender = pick(MALE,FEMALE,NEUTER)
	delete_inventory()

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
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(25,175)
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
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(25,175)
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
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(25,175)
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
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(25,175)
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
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	weight = rand(25,175)
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
				H.equip_to_slot_or_del(new /obj/item/clothing/head/cowboy_hat/wide, slot_head)
				H.update_inv_head()
			if(!gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather, slot_wear_suit)
				H.update_inv_gloves()
