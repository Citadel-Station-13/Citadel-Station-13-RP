var/list/outfits_decls_
var/list/outfits_decls_root_
var/list/outfits_decls_by_type_

/proc/outfit_by_type(var/outfit_type)
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_by_type_[outfit_type]

/proc/outfits()
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_

/proc/init_outfit_decls()
	if(outfits_decls_root_)
		return
	outfits_decls_ = list()
	outfits_decls_by_type_ = list()
	outfits_decls_root_ = new/decl/hierarchy/outfit()

/decl/hierarchy/outfit
	name = "Naked"

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
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

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

	var/flags // Specific flags

	var/undress = 1	//Does the outfit undress the mob upon equp?

/decl/hierarchy/outfit/New()
	..()

	if(is_hidden_category())
		return
	outfits_decls_by_type_[type] = src
	dd_insertObjectList(outfits_decls_, src)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_BACKPACK)
		switch(H.backbag)
			if(2) back = backpack
			if(3) back = satchel_one
			if(4) back = satchel_two
			if(5) back = messenger_bag
			else back = null

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	equip_base(H)

	rank = id_pda_assignment || rank
	assignment = id_pda_assignment || assignment || rank
	var/obj/item/card/id/W = equip_id(H, rank, assignment)
	if(W)
		rank = W.rank
		assignment = W.assignment
	equip_pda(H, rank, assignment)

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_del(new path(H), slot_in_backpack)

	post_equip(H)
	if(W) // We set ID info last to ensure the ID photo is as correct as possible.
		H.set_id_info(W)
	return 1

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H)
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform)
	if(suit)
		H.equip_to_slot_or_del(new suit(H),slot_wear_suit)
	if(back)
		H.equip_to_slot_or_del(new back(H),slot_back)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),slot_belt)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),slot_gloves)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),slot_shoes)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),slot_wear_mask)
	if(head)
		H.equip_to_slot_or_del(new head(H),slot_head)
	if(l_ear)
		H.equip_to_slot_or_del(new l_ear(H),slot_l_ear)
	if(r_ear)
		H.equip_to_slot_or_del(new r_ear(H),slot_r_ear)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),slot_glasses)
	if(id)
		H.equip_to_slot_or_del(new id(H),slot_wear_id)
	if(l_pocket)
		H.equip_to_slot_or_del(new l_pocket(H),slot_l_store)
	if(r_pocket)
		H.equip_to_slot_or_del(new r_pocket(H),slot_r_store)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),slot_s_store)

	if(l_hand)
		H.put_in_l_hand(new l_hand(H))
	if(r_hand)
		H.put_in_r_hand(new r_hand(H))
	if(H.species)
		H.species.equip_survival_gear(H, flags&OUTFIT_EXTENDED_SURVIVAL, flags&OUTFIT_COMPREHENSIVE_SURVIVAL)

/decl/hierarchy/outfit/proc/equip_id(mob/living/carbon/human/H, rank, assignment)
	if(!id_slot || !id_type)
		return
	var/obj/item/card/id/W = new id_type(H)
	if(id_desc)
		W.desc = id_desc
	if(rank)
		W.rank = rank
	if(assignment)
		W.assignment = assignment
	if(H.equip_to_slot_or_del(W, id_slot))
		return W

/decl/hierarchy/outfit/proc/equip_pda(mob/living/carbon/human/H, rank, assignment)
	if(!pda_slot || !pda_type)
		return
	var/obj/item/pda/pda = new pda_type(H)
	if(H.equip_to_slot_or_del(pda, pda_slot))
		pda.owner = H.real_name
		pda.ownjob = assignment
		pda.ownrank = rank
		pda.name = "PDA-[H.real_name] ([assignment])"
		if(H.client.prefs.ringtone) // if null we use the job default
			pda.ringtone = H.client.prefs.ringtone
		return pda

/decl/hierarchy/outfit/dd_SortValue()
	return name

/decl/hierarchy/outfit/USDF/Marine
	name = "USDF marine"
	uniform = /obj/item/clothing/under/solgov/utility/marine/green
	shoes = /obj/item/clothing/shoes/boots/jackboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/radio/headset/centcom
	r_pocket = /obj/item/ammo_magazine/m95
	l_pocket = /obj/item/ammo_magazine/m95
	l_hand = /obj/item/ammo_magazine/m95
	r_hand = /obj/item/ammo_magazine/m95
	back = /obj/item/gun/projectile/automatic/battlerifle
	backpack_contents = list(/obj/item/storage/box = 1)
	hierarchy_type = /decl/hierarchy/outfit/wizard
	head = /obj/item/clothing/head/helmet/combat/USDF
	suit = /obj/item/clothing/suit/armor/combat/USDF
	belt = /obj/item/storage/belt/security/tactical

/decl/hierarchy/outfit/USDF/Marine/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	C.name = "[H.real_name]'s military ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "USDF"
	C.registered_name = H.real_name
	return C

/decl/hierarchy/outfit/USDF/Officer
	name = "USDF officer"
	head = /obj/item/clothing/head/dress/marine/command/admiral
	shoes = /obj/item/clothing/shoes/boots/jackboots
	l_ear = /obj/item/radio/headset/centcom
	uniform = /obj/item/clothing/under/solgov/mildress/marine/command
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/gun/projectile/revolver/consul
	l_pocket = /obj/item/ammo_magazine/s44
	r_pocket = /obj/item/ammo_magazine/s44
	r_hand = /obj/item/clothing/accessory/holster/hip
	l_hand = /obj/item/clothing/accessory/tie/black

/decl/hierarchy/outfit/USDF/Officer/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	C.name = "[H.real_name]'s military ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "USDF"
	C.registered_name = H.real_name
	return C

/decl/hierarchy/outfit/solgov/representative
	name = "SolGov Representative"
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/radio/headset/centcom
	uniform = /obj/item/clothing/under/suit_jacket/navy
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/pen/blue
	r_pocket = /obj/item/pen/red
	r_hand = /obj/item/pda/centcom
	l_hand = /obj/item/clipboard

/decl/hierarchy/outfit/solgov/representative/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	C.name = "[H.real_name]'s SolGov ID Card"
	C.icon_state = "lifetime"
	C.access = get_all_station_access()
	C.access += get_all_centcom_access()
	C.assignment = "SolGov Representative"
	C.registered_name = H.real_name
	return C

/decl/hierarchy/outfit/imperial/soldier
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
	r_hand = /obj/item/melee/energy/sword/imperial
	l_hand = /obj/item/shield/energy/imperial
	suit_store = /obj/item/gun/energy/imperial

/decl/hierarchy/outfit/imperial/officer
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
	r_hand = /obj/item/melee/energy/sword/imperial
	l_hand = /obj/item/shield/energy/imperial
	suit_store = /obj/item/gun/energy/imperial
