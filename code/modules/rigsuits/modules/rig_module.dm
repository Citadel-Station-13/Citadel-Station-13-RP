//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * modules are modular items that can be inserted into specific slots on the rig.
 */
/obj/item/rig_module
	#warn impl all

	//* Core
	/// lookup id
	var/lookup_id
	/// lookup prefix - set this please
	var/lookup_prefix = "unkw"

	//* Balancing
	/// slots this takes up
	///
	/// slots is the metric used to balance complexity / variety of functions
	/// more niche & powerful/varied gear takes up more slots
	var/module_slots = 0
	/// size this takes up
	///
	/// size is the metric used to balance offense/defense/storage
	/// you generally can have two of the three, not all of the above
	var/module_size = 0
	/// weight to add to rigsuit
	///
	/// stuff like heavy armor tends to be heavier.
	var/module_weight = 0

	//* Conflicts
	/// single-conflict enum; if set, only one of this kind of module can exist on a rig
	/// this will not conflict with any of the other conflict types!
	var/single_conflict_rig

	//* UI
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64
	/// is our UI update queued?
	var/ui_update_queued = FALSE
	/// TGUI route; this is handled by routes.tsx in the Rigsuit folder on TGUI!
	var/tgui_interface = "inert"

	//* Zone
	/// our zone define, e.g. RIG_ZONE_X
	/// all = takes slots from all zones
	/// none = takes slots from any zone
	/// this is a define instead of a bit because of speed reasons.
	var/zone = RIG_ZONE_NONE
	/// allow automatically swapping handedness if we are only on one arm zone
	/// via a certain tool
	/// legs also count as handedness.
	var/swap_handedness_tool = TOOL_SCREWDRIVER

/obj/item/rig_module/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = list()
	if(swap_handedness_tool)
		.[swap_handedness_tool] = list("swap arm" = dyntool_image_neutral(swap_handedness_tool))
	return merge_double_lazy_assoc_list(., ..())

/obj/item/rig_module/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	if(function == swap_handedness_tool)
		if(auto_swap_handedness)
			e_args.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_CONFIGURATION,
				visible = SPAN_NOTICE("[e_args.performer] tinkers with [src], mirroring its mechanism's orientations."),
				audible = SPAN_NOTICE("You hear mechanisms being re-fastened."),
				visible_self = SPAN_NOTICE("You swap the orientation on [src]."),
			)
			log_construction(e_args, src, "swapped handedness")
		else
			e_args.chat_feedback(
				SPAN_WARNING("failed to swap handedness on [src] despite being marked as handed and swappable; contact a coder."),
				target = src,
			)
		return TRUE
	return ..()

//* Attachment *//

/**
 * has final say over rig
 * most regular checks should be rig-side
 *
 * @params
 * * rig - the suit
 * * rig_opinion - what does the suit say about this?
 * * actor - (optional) person attaching
 * * silent - (optional) should we inform the person attaching?
 */
/obj/item/rig_module/proc/can_attach(obj/item/rig/rig, rig_opinion, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * first check - 'does it make sense for this to be attached to the rig?'
 *
 * if not, specify why if not silent and actor is provided
 *
 * @params
 * * rig - the suit
 * * actor - (optional) person attaching
 * * silent - (optional) should we inform the person attaching?
 */
/obj/item/rig_module/proc/valid_attach(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * has final say over rig
 * most regular checks should be rig-side
 *
 * @params
 * * rig - the suit
 * * rig_opinion - what does the suit say about this?
 * * actor - (optional) person attaching
 * * silent - (optional) should we inform the person attaching?
 */
/obj/item/rig_module/proc/can_detach(obj/item/rig/rig, rig_opinion, datum/event_args/actor/actor, silent)
	return TRUE

//* Console *//

/**
 * @return list(command = desc, ...)
 */
/obj/item/rig_module/proc/console_query(effective_control_flags, username)
	return list()

/**
 * @return list(output, admin log text)
 */
/obj/item/rig_module/proc/console_process(effective_control_flags, username, command, list/arguments)
	return list("unknown command", "<invalid>")

//* UI *//

/obj/item/rig_module/proc/tgui_module_static()
	return list(
		"$tgui" = tgui_interface,
		"$src" = ref(src),
	)
	#warn impl

/obj/item/rig_module/proc/tgui_module_data()
	#warn impl

/obj/item/rig_module/proc/tgui_push_data(list/data)
	#warn impl

/obj/item/rig_module/proc/tgui_queue_data()
	#warn impl

//* Zones *//

/**
 * detect handedness;
 * this only makes sense if we are hand-based
 * we do not check for hand zones existing here
 * we do not check if our arms and legs are for some reason on different sides.
 */
/obj/item/rig_module/proc/unsafe_is_left_handed()
	return rig_zone_to_bit[zone] & (RIG_ZONE_BIT_LEFT_ARM | RIG_ZONE_BIT_LEFT_LEG)

/**
 * detect handedness;
 * this only makes sense if we are hand-based
 * we do not check if our arms and legs are for some reason on different sides.
 *
 * @return RIG_HANDEDNESS_X enum
 */
/obj/item/rig_module/proc/safe_handedness()
	var/our_bits = rig_zone_to_bit[zone]
	if(our_bits & (RIG_ZONE_BIT_ARMS | RIG_ZONE_BIT_LEGS))
		return our_bits & (RIG_ZONE_BIT_LEFT_ARM | RIG_ZONE_BIT_LEFT_LEG) ? RIG_HANDEDNESS_LEFT : RIG_HANDEDNESS_RIGHT
	return RIG_HANDEDNESS_NONE

/**
 * tries to swap handedness
 *
 * legs also count as handedness so uh
 */
/obj/item/rig_module/proc/auto_swap_handedness()
	switch(zone)
		if(RIG_ZONE_LEFT_ARM)
			zone = RIG_ZONE_RIGHT_ARM
			return TRUE
		if(RIG_ZONE_RIGHT_ARM)
			zone = RIG_ZONE_LEFT_ARM
			return TRUE
		if(RIG_ZONE_LEFT_LEG)
			zone = RIG_ZONE_RIGHT_LEG
			return TRUE
		if(RIG_ZONE_RIGHT_LEG)
			zone = RIG_ZONE_LEFT_LEG
			return TRUE
		else
			return FALSE
