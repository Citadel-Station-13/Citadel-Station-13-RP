//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * flatten all keyed overlays
 */
/mob/living/carbon/proc/flatten_standing_overlays()
	return

/**
 * rebuild all keyed overlays
 */
/mob/living/carbon/proc/rebuild_standing_overlays(dump_all_overlays = TRUE)
	regenerate_icons()
	// todo: rebuild inventory
	reapply_standing_overlays(dump_all_overlays)

/**
 * reapply all keyed overlays
 *
 * * inventory overlays *are* included in this
 *
 * @params
 * * dump_all_overlays - drop all non-priority overlays
 */
/mob/living/carbon/proc/reapply_standing_overlays(dump_all_overlays = TRUE)
	if(dump_all_overlays)
		cut_overlays()
	for(var/key in standing_overlays)
		add_overlay(standing_overlays[key])
	inventory.reapply_slot_renders()

/**
 * obliterate a keyed overlay or list of keyed overlays from our overlays
 *
 * * inventory overlays are not handled by this; check /datum/inventory
 */
/mob/living/carbon/proc/remove_standing_overlay(key, do_not_update)
	. = standing_overlays[key]

	standing_overlays -= key

	if(!do_not_update)
		cut_overlay(.)

/**
 * set a keyed overlay or list of keyed overlays to our overlays
 *
 * * inventory overlays are not handled by this; check /datum/inventory
 */
/mob/living/carbon/proc/set_standing_overlay(key, list/overlay_or_list, do_not_update)
	. = standing_overlays[key]

	if(isnull(overlay_or_list) || (islist(overlay_or_list) && !length(overlay_or_list)))
		standing_overlays -= key
		// unreference so we don't try to add overlay it
		overlay_or_list = null
	else
		SEND_SIGNAL(src, COMSIG_CARBON_UPDATING_OVERLAY, args, key)
		standing_overlays[key] = overlay_or_list

	if(!do_not_update)
		if(!isnull(.))
			cut_overlay(.)
		if(!isnull(overlay_or_list))
			add_overlay(overlay_or_list)

