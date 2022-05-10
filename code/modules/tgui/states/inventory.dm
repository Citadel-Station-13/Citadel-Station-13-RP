/**
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * tgui state: inventory_state
 *
 * Checks that the src_object is in the user's top-level
 * (hand, ear, pocket, belt, etc) inventory.
 */

GLOBAL_DATUM_INIT(inventory_state, /datum/ui_state/inventory_state, new)

/datum/ui_state/inventory_state/can_use_topic(src_object, mob/user)
	if(!(src_object in user))
		return UI_CLOSE
	return user.shared_ui_interaction(src_object)

GLOBAL_DATUM_INIT(glasses_state, /datum/ui_state/glasses_state, new)

/datum/ui_state/glasses_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses == src_object)
			return user.shared_ui_interaction()

	return UI_CLOSE

GLOBAL_DATUM_INIT(nif_state, /datum/ui_state/nif_state, new)

/datum/ui_state/nif_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.nif && H.nif.stat == NIF_WORKING && src_object == H.nif)
			return user.shared_ui_interaction()

	return UI_CLOSE

///This is slightly distinct from the module state, as it wants to update if not working
GLOBAL_DATUM_INIT(ui_nif_main_state, /datum/ui_state/nif_main_state, new)
/datum/ui_state/nif_main_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.nif || src_object != H.nif)
			return UI_CLOSE

		if(H.nif.stat == NIF_WORKING)
			return user.shared_ui_interaction()
		else
			return min(user.shared_ui_interaction(), UI_UPDATE)

	return UI_CLOSE

GLOBAL_DATUM_INIT(ui_commlink_state, /datum/ui_state/commlink_state, new)
/datum/ui_state/commlink_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.nif && H.nif.stat == NIF_WORKING && H.nif.comm == src_object)
			return user.shared_ui_interaction()

	return UI_CLOSE
