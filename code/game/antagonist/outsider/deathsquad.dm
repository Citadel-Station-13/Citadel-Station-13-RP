var/datum/antagonist/deathsquad/deathsquad

/datum/antagonist/deathsquad
	id = MODE_DEATHSQUAD
	role_type = BE_OPERATIVE
	role_text = "Death Commando"
	role_text_plural = "Death Commandos"
	welcome_text = "You work in the service of corporate Asset Protection, answering directly to the Board of Directors."
	antag_sound = 'sound/effects/antag_notice/deathsquid_alert.ogg'
	landmark_id = "Commando"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_HAS_NUKE | ANTAG_HAS_LEADER
	default_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	antaghud_indicator = "deathsquad"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

	var/deployed = 0

/datum/antagonist/deathsquad/New(var/no_reference)
	..()
	if(!no_reference)
		deathsquad = src

/datum/antagonist/deathsquad/attempt_spawn()
	if(..())
		deployed = 1

/datum/antagonist/deathsquad/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate/combat(player), SLOT_ID_UNIFORM)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(player), SLOT_ID_UNIFORM)

	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/swat(player), SLOT_ID_SHOES)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), SLOT_ID_GLOVES)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), SLOT_ID_GLASSES)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(player), SLOT_ID_MASK)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/pinpointer(player), SLOT_ID_LEFT_POCKET)
		player.equip_to_slot_or_del(new /obj/item/disk/nuclear(player), SLOT_ID_RIGHT_POCKET)
	else
		player.equip_to_slot_or_del(new /obj/item/plastique(player), SLOT_ID_LEFT_POCKET)
	player.equip_to_slot_or_del(new /obj/item/gun/projectile/revolver/combat(player), SLOT_ID_BELT)
	player.equip_to_slot_or_del(new /obj/item/gun/energy/pulse_rifle(player), /datum/inventory_slot_meta/abstract/hand/right)
	player.equip_to_slot_or_del(new /obj/item/rig/ert/assetprotection(player), SLOT_ID_BACK)
	player.equip_to_slot_or_del(new /obj/item/melee/energy/sword(player), SLOT_ID_SUIT_STORAGE)
//	player.implant_loyalty()

	var/obj/item/card/id/id = create_id("Asset Protection", player)
	if(id)
		id.access |= get_all_station_access()
		id.icon_state = "centcom"
	create_radio(DTH_FREQ, player)

/datum/antagonist/deathsquad/update_antag_mob(var/datum/mind/player)

	..()

	var/syndicate_commando_rank
	if(leader && player == leader)
		syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	else
		syndicate_commando_rank = pick("Lieutenant", "Captain", "Major")

	var/syndicate_commando_name = pick(last_names)

	var/datum/preferences/A = new() //Randomize appearance for the commando.
	A.randomize_appearance_and_body_for(player.current)

	player.name = "[syndicate_commando_rank] [syndicate_commando_name]"
	player.current.name = player.name
	player.current.real_name = player.current.name

	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.gender = pick(MALE, FEMALE)
		H.age = rand(25,45)
		H.dna.ready_dna(H)

	return

/datum/antagonist/deathsquad/create_antagonist()
	if(..() && !deployed)
		deployed = 1
