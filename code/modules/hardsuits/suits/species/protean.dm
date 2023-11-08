/obj/item/hardsuit/protean
	name = "nanosuit control cluster"
	suit_type = "nanomachine"
	icon_state = "nanomachine_rig"
	armor_type = /datum/armor/hardsuit/protean
	siemens_coefficient = 0.5
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	seal_delay = 1
	var/mob/living/carbon/human/myprotean
	initial_modules = list(
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/device/rigwelder, // Almost forgot these, but who uses blobsuits for their intended purpose anyways?
		/obj/item/hardsuit_module/device/toolset    // I did say I was going to do it
		)

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/protean
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/protean
	chest_type = /obj/item/clothing/suit/space/hardsuit/protean
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/protean
	maintenance_while_online = TRUE

/datum/armor/hardsuit/protean
	melee = 0.0
	bullet = 0.0
	laser = 0.0
	energy = 0.0
	bomb = 0.0
	bio = 1.0
	rad = 1.0

/obj/item/hardsuit/protean/relaymove(mob/user, var/direction)
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_MOVE))
		return
	forced_move(direction, user, FALSE, TRUE)

/obj/item/hardsuit/protean/check_suit_access(mob/living/carbon/human/user)
	if(user == myprotean)
		return TRUE
	return ..()

/obj/item/clothing/head/helmet/space/hardsuit/protean
	name = "mass"
	desc = "A helmet-shaped clump of nanomachines."
	light_overlay = "should not use a light overlay"
	species_restricted = null

/obj/item/clothing/gloves/gauntlets/hardsuit/protean
	name = "mass"
	desc = "Glove-shaped clusters of nanomachines."
	siemens_coefficient = 0
	species_restricted = null

/obj/item/clothing/shoes/magboots/hardsuit/protean
	name = "mass"
	desc = "Boot-shaped clusters of nanomachines."
	species_restricted = null

/obj/item/clothing/suit/space/hardsuit/protean
	name = "mass"
	desc = "A body-hugging mass of nanomachines."
	can_breach = 0
	species_restricted = null
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton,/obj/item/storage/backpack,/obj/item/bluespace_radio)
