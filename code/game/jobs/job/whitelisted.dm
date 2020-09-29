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
	economic_modifier = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Comedian","Jester")
	whitelist_only = 1
	latejoin_only = 1

	idtype = /obj/item/card/id/civilian/clown
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
			H.equip_to_slot_or_del(new /obj/item/bikehorn(H.back), slot_in_backpack) //VOREStation Edit
		else
			H.equip_to_slot_or_del(new /obj/item/stamp/clown(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/bikehorn(H.back), slot_l_hand) //VOREStation Edit

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
	economic_modifier = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Performer","Interpretive Dancer")
	whitelist_only = 1
	latejoin_only = 1

	idtype = /obj/item/card/id/civilian/mime
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
