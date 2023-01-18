var/datum/antagonist/highlander/highlanders

/datum/antagonist/highlander
	role_text = "Highlander"
	role_text_plural = "Highlanders"
	welcome_text = "There can be only one."
	id = MODE_HIGHLANDER
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE //| ANTAG_RANDSPAWN | ANTAG_VOTABLE // Someday...

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 3
	initial_spawn_target = 5

/datum/antagonist/highlander/New()
	..()
	highlanders = src

/datum/antagonist/highlander/create_objectives(var/datum/mind/player)

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = player
	steal_objective.set_target("nuclear authentication disk")
	player.objectives |= steal_objective

	var/datum/objective/hijack/hijack_objective = new
	hijack_objective.owner = player
	player.objectives |= hijack_objective

/datum/antagonist/highlander/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		qdel(I)

	player.equip_to_slot_or_del(new /obj/item/clothing/under/kilt(player), SLOT_ID_UNIFORM)
	player.equip_to_slot_or_del(new /obj/item/radio/headset/heads/captain(player), SLOT_ID_LEFT_EAR)
	player.equip_to_slot_or_del(new /obj/item/clothing/head/beret(player), SLOT_ID_HEAD)
	player.put_in_hands_or_del(new /obj/item/material/sword(player))
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/combat(player), SLOT_ID_SHOES)
	player.equip_to_slot_or_del(new /obj/item/pinpointer(get_turf(player)), SLOT_ID_LEFT_POCKET)

	var/obj/item/card/id/W = new(player)
	W.name = "[player.real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_station_access()
	W.access |= get_all_centcom_access()
	W.assignment = "Highlander"
	W.registered_name = player.real_name
	player.equip_to_slot_or_del(W, SLOT_ID_WORN_ID)

/proc/only_one()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		highlanders.add_antagonist(H.mind)

	message_admins("<span class='notice'>[key_name_admin(usr)] used THERE CAN BE ONLY ONE!</span>", 1)
	log_admin("[key_name(usr)] used there can be only one.")
