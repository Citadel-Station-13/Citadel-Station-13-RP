var/datum/antagonist/deathsquad/mercenary/commandos

/datum/antagonist/deathsquad/mercenary
	id = MODE_COMMANDO
	landmark_id = "Syndicate-Commando"
	role_text = "Syndicate Commando"
	role_text_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to corporate interests."
	antag_sound = 'sound/effects/antag_notice/deathsquid_alert.ogg'
	id_type = /obj/item/card/id/centcom/ERT

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6


/datum/antagonist/deathsquad/mercenary/New()
	..(1)
	commandos = src

/datum/antagonist/deathsquad/mercenary/equip(var/mob/living/carbon/human/player)

	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), SLOT_ID_UNIFORM)
	player.equip_to_slot_or_del(new /obj/item/gun/projectile/silenced(player), SLOT_ID_BELT)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/swat(player), SLOT_ID_SHOES)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), SLOT_ID_GLOVES)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), SLOT_ID_GLASSES)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(player), SLOT_ID_MASK)
	player.equip_to_slot_or_del(new /obj/item/storage/box(player), /datum/inventory_slot_meta/abstract/put_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/ammo_magazine/clip/c45(player), /datum/inventory_slot_meta/abstract/put_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/rig/merc(player), SLOT_ID_BACK)
	player.equip_to_slot_or_del(new /obj/item/gun/energy/pulse_rifle(player), /datum/inventory_slot_meta/abstract/hand/right)

	create_id("Commando", player)
	create_radio(SYND_FREQ, player)
	return 1
