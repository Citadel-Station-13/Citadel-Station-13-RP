/datum/job/centcom_officer	// For Business
	title = "CentCom Officer"
	department = "Command"
	head_position = 1
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	idtype = /obj/item/card/id/centcom
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_modifier = 20
	whitelist_only = 1
	latejoin_only = 1

	minimum_character_age = 25
	ideal_character_age = 40

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/radio/headset/centcom(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom, slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/gun/energy/pulse_rifle/M1911, slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/pda/centcom(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/omnihud/all(H), slot_r_store)

		H.implant_loyalty()

		return 1

	get_access()
		var/access = get_all_accesses()
		return access

/datum/job/centcom_visitor	// For Pleasure	// You mean for admin abuse... -Ace	// Yes -Zand
	title = "CentCom Visitor"
	department = "Civilian"
	head_position = 1
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#1D1D4F"
	idtype = /obj/item/card/id/centcom
	access = list()
	minimal_access = list()
	minimal_player_age = 14
	economic_modifier = 20
	whitelist_only = 1
	latejoin_only = 1

	minimum_character_age = 25
	ideal_character_age = 40

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/radio/headset/centcom(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom, slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/pda/centcom(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/pda/centcom(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/omnihud(H), slot_r_store)

		H.implant_loyalty()

		return 1

	get_access()
		var/access = get_all_accesses()
		return access

/datum/job/clown
	title = "Clown"
	flag = CLOWN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the spirit of laughter"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/clown
	economic_modifier = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Comedian","Jester","Vibrant Mascot")
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/clown

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/pda/clown(H), slot_belt)

		if(H.backbag > 0)
			H.equip_to_slot_or_del(new /obj/item/stamp/clown(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/bikehorn(H.back), slot_in_backpack)
		else
			H.equip_to_slot_or_del(new /obj/item/stamp/clown(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/bikehorn(H.back), slot_l_hand)

		return 1

/datum/job/clown/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/mime
	title = "Mime"
	flag = MIME
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the spirit of performance"
	selection_color = "#515151"
	idtype = /obj/item/card/id/civilian/mime
	economic_modifier = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Performer","Interpretive Dancer","Subdued Mascot")
	whitelist_only = 1
	latejoin_only = 1
	outfit_type = /decl/hierarchy/outfit/job/mime

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/mime(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/mime(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/mime(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mime(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/pda/mime(H), slot_belt)

		if(H.backbag > 0)
			H.equip_to_slot_or_del(new /obj/item/pen/crayon/mime(H.back), slot_in_backpack)
		else
			H.equip_to_slot_or_del(new /obj/item/pen/crayon/mime(H), slot_l_hand)

		return 1

/datum/job/mime/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
