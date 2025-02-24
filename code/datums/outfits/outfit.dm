/proc/get_all_outfits()
	. = list()
	for(var/path in subtypesof(/datum/outfit))
		var/datum/outfit/O = path
		if(initial(O.abstract_type) == path)
			continue
		. += new path
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc))

/datum/outfit
	/// Abstract type - set to self type for abstract outfits.
	abstract_type = /datum/outfit

	/// the outfit's name
	var/name = "Naked"

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	// In the list(path=count,otherpath=count) format
	var/list/uniform_accessories = list() // webbing, armbands etc - fits in /datum/inventory_slot/abstract/attach_as_accessory
	var/list/backpack_contents = list()

	var/id_type
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/backpack = /obj/item/storage/backpack
	var/satchel_one  = /obj/item/storage/backpack/satchel/norm
	var/satchel_two  = /obj/item/storage/backpack/satchel
	var/messenger_bag = /obj/item/storage/backpack/messenger
	var/rig = /obj/item/storage/backpack/rig
	var/dufflebag = /obj/item/storage/backpack/dufflebag

	var/flags // Specific flags

	var/undress = 1	//Does the outfit undress the mob upon equp?

/datum/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_BACKPACK)
		switch(H.backbag)
			if(2) back = backpack
			if(3) back = satchel_one
			if(4) back = satchel_two
			if(5) back = messenger_bag
			if(6) back = rig
			if(7) back = dufflebag
			else  back = null

/datum/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/datum/outfit/proc/equip(mob/living/carbon/human/H, rank, assignment)
	H.species?.handle_species_job_outfit(H, src)

	equip_base(H)

	rank = rank || id_pda_assignment
	assignment = id_pda_assignment || assignment || rank
	var/obj/item/card/id/W = equip_id(H, rank, assignment)
	if(W)
		rank = W.rank
		assignment = W.assignment
	equip_pda(H, rank, assignment)

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_del(new path(H), /datum/inventory_slot/abstract/put_in_backpack)

	post_equip(H)

	if(W) // We set ID info last to ensure the ID photo is as correct as possible.
		H.set_id_info(W, H.client)
	return 1

/datum/outfit/proc/equip_base(mob/living/carbon/human/H)
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),SLOT_ID_UNIFORM, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(suit)
		H.equip_to_slot_or_del(new suit(H),SLOT_ID_SUIT, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(back)
		H.equip_to_slot_or_del(new back(H),SLOT_ID_BACK, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),SLOT_ID_BELT, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),SLOT_ID_GLOVES, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),SLOT_ID_SHOES, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),SLOT_ID_MASK, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(head)
		H.equip_to_slot_or_del(new head(H),SLOT_ID_HEAD, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(l_ear)
		H.equip_to_slot_or_del(new l_ear(H),SLOT_ID_LEFT_EAR, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(r_ear)
		H.equip_to_slot_or_del(new r_ear(H),SLOT_ID_RIGHT_EAR, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),SLOT_ID_GLASSES, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(id)
		H.equip_to_slot_or_del(new id(H),SLOT_ID_WORN_ID, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(l_pocket)
		H.equip_to_slot_or_del(new l_pocket(H),SLOT_ID_LEFT_POCKET, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(r_pocket)
		H.equip_to_slot_or_del(new r_pocket(H),SLOT_ID_RIGHT_POCKET, INV_OP_FLUFFLESS | INV_OP_SILENT)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),SLOT_ID_SUIT_STORAGE, INV_OP_FLUFFLESS | INV_OP_SILENT)

	if(l_hand)
		H.put_in_left_hand(new l_hand(H), INV_OP_FORCE)
	if(r_hand)
		H.put_in_right_hand(new r_hand(H), INV_OP_FORCE)

	for(var/path in uniform_accessories)
		var/number = uniform_accessories[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_del(new path(H), /datum/inventory_slot/abstract/attach_as_accessory, INV_OP_FLUFFLESS | INV_OP_SILENT)

	// deal with racial & survival gear
	var/list/to_inject_box = list()
	var/list/to_inject_inv = list()
	H.species.apply_survival_gear(H, to_inject_box, to_inject_inv)
	H.species.apply_racial_gear(H, to_inject_box, to_inject_inv)

	if(length(to_inject_box))
		var/obj/item/survival_box = new /obj/item/storage/box/survival
		for(var/descriptor in to_inject_box)
			if(ispath(descriptor))
				new descriptor(survival_box)
			else if(IS_ANONYMOUS_TYPEPATH(descriptor))
				new descriptor(survival_box)
			else if(isitem(descriptor))
				var/obj/item/moving = descriptor
				moving.forceMove(survival_box)
			else
				stack_trace("invalid descriptor '[descriptor]' encountered")
		survival_box.obj_storage.fit_to_contents(no_shrink = TRUE)

		if(!H.inventory.equip_to_slot_if_possible(survival_box, /datum/inventory_slot/abstract/put_in_backpack))
			if(!H.inventory.put_in_hands(survival_box))
				survival_box.forceMove(H.drop_location())

	if(length(to_inject_inv))
		var/list/atom/movable/arbitrary_instantiated_gear = list()
		for(var/descriptor in to_inject_inv)
			if(ispath(descriptor))
				arbitrary_instantiated_gear += new descriptor
			else if(IS_ANONYMOUS_TYPEPATH(descriptor))
				arbitrary_instantiated_gear += new descriptor
			else if(ismovable(descriptor))
				arbitrary_instantiated_gear += descriptor
			else
				stack_trace("invalid descriptor '[descriptor]' encountered")
		for(var/atom/movable/gear as anything in arbitrary_instantiated_gear)
			if(isitem(gear))
				// try to put into inv, then hands, then nearby
				var/obj/item/gear_item = gear
				if(!H.equip_to_slots_if_possible(
					gear_item,
					list(
						/datum/inventory_slot/abstract/put_in_backpack,
						/datum/inventory_slot/abstract/put_in_belt,
						/datum/inventory_slot/abstract/put_in_hands,
						/datum/inventory_slot/inventory/pocket/left,
						/datum/inventory_slot/inventory/pocket/right,
					),
				))
					gear_item.forceMove(H.drop_location())
			else
				// put nearby
				gear.forceMove(H.drop_location())

/datum/outfit/proc/equip_id(mob/living/carbon/human/H, rank, assignment)
	if(!id_slot || !id_type)
		return

	var/faction = H.mind?.original_background_faction()?.id
	if(faction && !(faction == "nanotrasen") && !ispath(id_type, /obj/item/card/id/external))
		id_type = /obj/item/card/id/contractor

	var/obj/item/card/id/W = new id_type(H)

	if(id_desc)
		W.desc = id_desc
	if(rank && assignment)
		W.set_registered_rank(rank, assignment)
	if(H.equip_to_slot_or_del(W, id_slot))
		return W

/datum/outfit/proc/equip_pda(mob/living/carbon/human/H, rank, assignment)
	if(!pda_slot || !pda_type)
		return
	var/obj/item/pda/pda = new pda_type(H)
	pda.owner = H.real_name
	pda.ownjob = assignment
	pda.ownrank = rank
	pda.name = "PDA-[H.real_name] ([assignment])"
	if(H.client.prefs.ringtone) // if null we use the job default
		pda.ringtone = H.client.prefs.ringtone
	tim_sort(GLOB.PDAs, GLOBAL_PROC_REF(cmp_name_asc))
	if(H.equip_to_slot_if_possible(pda, pda_slot))
		return pda
	if(H.force_equip_to_slot(pda, /datum/inventory_slot/abstract/put_in_backpack))
		return pda
	if(H.equip_to_slot_or_del(pda, SLOT_ID_HANDS))
		return pda


/datum/outfit/dd_SortValue()
	return name


//! ## VR FILE MERGE ## !//

/datum/outfit/JSDF/Marine
	name = "JSDF marine"
	uniform = /obj/item/clothing/under/oricon/utility/marine/green
	shoes = /obj/item/clothing/shoes/boots/jackboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/radio/headset
	r_pocket = /obj/item/ammo_magazine/m95
	l_pocket = /obj/item/ammo_magazine/m95
	l_hand = /obj/item/ammo_magazine/m95
	r_hand = /obj/item/ammo_magazine/m95
	back = /obj/item/gun/projectile/ballistic/automatic/battlerifle
	backpack_contents = list(/obj/item/storage/box = 1)
	abstract_type = /datum/outfit/wizard
	head = /obj/item/clothing/head/helmet/combat/JSDF
	suit = /obj/item/clothing/suit/armor/combat/JSDF
	belt = /obj/item/storage/belt/security/tactical

/datum/outfit/JSDF/Marine/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	C.name = "[H?.real_name]'s military ID Card"
	C.icon_state = "lifetime"
	C.assignment = "JSDF"
	C.registered_name = H.real_name
	return C

/datum/outfit/JSDF/Officer
	name = "JSDF officer"
	head = /obj/item/clothing/head/dress/marine/command/admiral
	shoes = /obj/item/clothing/shoes/boots/jackboots
	uniform = /obj/item/clothing/under/oricon/mildress/marine/command
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/gun/projectile/ballistic/revolver/consul
	l_pocket = /obj/item/ammo_magazine/a44/speedloader
	r_pocket = /obj/item/ammo_magazine/a44/speedloader
	r_hand = /obj/item/clothing/accessory/holster/hip
	l_hand = /obj/item/clothing/accessory/tie/black

/datum/outfit/JSDF/Officer/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	C.name = "[H.real_name]'s military ID Card"
	C.icon_state = "lifetime"
	C.assignment = "JSDF"
	C.registered_name = H.real_name
	return C

/datum/outfit/oricon/representative
	name = "Confederation Representative"
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/radio/headset/centcom
	uniform = /obj/item/clothing/under/suit_jacket/navy
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/pen/blue
	r_pocket = /obj/item/pen/red
	r_hand = /obj/item/pda/centcom
	l_hand = /obj/item/clipboard

/datum/outfit/oricon/representative/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	C.name = "[H.real_name]'s OriCon ID Card"
	C.icon_state = "lifetime"
	C.assignment = "OriCon Representative"
	C.registered_name = H.real_name
	return C

/datum/outfit/imperial/soldier
	name = "Imperial soldier"
	head = /obj/item/clothing/head/helmet/combat/imperial
	shoes =/obj/item/clothing/shoes/leg_guard/combat/imperial
	gloves = /obj/item/clothing/gloves/arm_guard/combat/imperial
	l_ear = /obj/item/radio/headset/syndicate
	uniform = /obj/item/clothing/under/imperial
	mask = /obj/item/clothing/mask/gas/imperial
	suit = /obj/item/clothing/suit/armor/combat/imperial
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/security/tactical/bandolier
	l_pocket = /obj/item/cell/device/weapon
	r_pocket = /obj/item/cell/device/weapon
	r_hand = /obj/item/melee/transforming/energy/sword/imperial
	l_hand = /obj/item/shield/transforming/energy/imperial
	suit_store = /obj/item/gun/projectile/energy/imperial

/datum/outfit/imperial/officer
	name = "Imperial officer"
	head = /obj/item/clothing/head/helmet/combat/imperial/centurion
	shoes = /obj/item/clothing/shoes/leg_guard/combat/imperial
	gloves = /obj/item/clothing/gloves/arm_guard/combat/imperial
	l_ear = /obj/item/radio/headset/syndicate
	uniform = /obj/item/clothing/under/imperial
	mask = /obj/item/clothing/mask/gas/imperial
	suit = /obj/item/clothing/suit/armor/combat/imperial/centurion
	belt = /obj/item/storage/belt/security/tactical/bandolier
	l_pocket = /obj/item/cell/device/weapon
	r_pocket = /obj/item/cell/device/weapon
	r_hand = /obj/item/melee/transforming/energy/sword/imperial
	l_hand = /obj/item/shield/transforming/energy/imperial
	suit_store = /obj/item/gun/projectile/energy/imperial
