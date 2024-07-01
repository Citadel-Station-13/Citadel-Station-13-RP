//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * modules are modular items that can be inserted into specific complexity on the rig.
 */
/obj/item/rig_module
	#warn impl all

	//* Core
	/// lookup id
	var/lookup_id
	/// lookup prefix - set this please
	var/lookup_prefix = "unkw"

	//* Balancing
	/// complexity this takes up
	///
	/// complexity is the metric used to balance complexity / variety of functions
	/// more niche & powerful/varied gear takes up more complexity
	var/module_complexity = 0
	/// volume this takes up
	///
	/// volume is the metric used to balance offense/defense/storage
	/// you generally can have two of the three, not all of the above
	var/module_volume = 0
	/// weight to add to rigsuit
	///
	/// stuff like heavy armor tends to be heavier.
	var/module_weight = 0

	//* Conflicts
	/// single-conflict enum; if set, only one of this kind of module can exist on a rig
	/// this will not conflict with any of the other conflict types!
	var/global_conflict_enum
	/// cannot put more than one of this type in the rig;
	var/global_conflict_type
	/// cannot put more than one of ourselves into the rig
	var/global_conflict_self
	/// zone-conflict enum; if set, only one our exact type can exist in any of our zones
	var/zone_conflict_enum
	/// cannot put more than one of this type in any of our zones
	var/zone_conflict_type
	/// cannot put more htan one of our own exact type into any of our zones
	var/zone_conflict_self

	//* Defense
	/// brute damage
	var/brute_damage = 0
	/// burn damage
	var/burn_damage = 0
	/// total integrity
	var/max_health = 100

	//* Registration
	/// the rig we're on
	var/obj/item/rig/host
	/// registered low power draw in watts
	var/registered_low_power = 0
	/// registered high power draw in watts
	var/registered_high_power = 0

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
	/// all = takes complexity from all zones
	/// none = takes complexity from any zone
	/// this is a define instead of a bit because of speed reasons.
	var/zone = RIG_ZONE_NONE
	/// allow automatically swapping handedness if we are only on one arm zone
	/// via a certain tool
	/// legs also count as handedness.
	var/swap_handedness_tool = TOOL_SCREWDRIVER

/obj/item/rig_module/Destroy()
	if(host)
		host.remove_module(src)
	return ..()

/obj/item/rig_module/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = list()
	if(swap_handedness_tool)
		.[swap_handedness_tool] = list("swap arm" = dyntool_image_neutral(swap_handedness_tool))
	return merge_double_lazy_assoc_list(., ..())

/obj/item/rig_module/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	if(function == swap_handedness_tool)
		if(auto_swap_handedness())
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

//* Power *//

/obj/item/rig_module/proc/set_high_power_draw(watts)
	#warn impl

/obj/item/rig_module/proc/set_low_power_draw(watts)
	#warn impl

/obj/item/rig_module/proc/use_high_burst_power(joules)
	return isnull(host)? 0 : host.draw_high_power(joules)

/obj/item/rig_module/proc/use_low_burst_power(joules)
	return isnull(host)? 0 : host.draw_low_power(joules)

//* Setters *//

/obj/item/rig_module/proc/set_module_weight(weight)
	var/old = module_weight
	module_weight = weight
	host?.on_module_weight_change(src, old, weight)

/obj/item/rig_module/proc/set_module_volume(volume)
	var/old = module_volume
	module_volume = volume
	host?.on_module_volume_change(src, old, volume)

/obj/item/rig_module/proc/set_module_complexity(complexity)
	var/old = module_complexity
	module_complexity = complexity
	host?.on_module_complexity_change(src, old, complexity)

/obj/item/rig_module/proc/set_module_zone(new_zone)
	// yeah, nah, we're not handling this cleanly
	ASSERT(!host)
	zone = new_zone

//* UI *//

/obj/item/rig_module/proc/rig_static_data()
	return list(
		"$tgui" = tgui_interface,
		"$src" = ref(src),
	)
	#warn impl

/obj/item/rig_module/proc/rig_data()
	#warn impl

/obj/item/rig_module/proc/rig_push_data(list/data)
	#warn impl

/**
 * queues non-static
 */
/obj/item/rig_module/proc/rig_queue_data()
	#warn impl

/**
 * @return TRUE if did something (and stop propagation).
 */
/obj/item/rig_module/proc/rig_act(mob/user, control_flags, action, list/params)
	return FALSE

/**
 * checks if someone's allowed to do something; if FALSE, tgui_act
 *
 * @return TRUE / FALSE
 */
/obj/item/rig_module/proc/rig_allowed(mob/user, control_flags, action, list/params)
	return control_flags & RIG_CONTROL_MODULES

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
			set_module_zone(RIG_ZONE_RIGHT_ARM)
			return TRUE
		if(RIG_ZONE_RIGHT_ARM)
			set_module_zone(RIG_ZONE_LEFT_ARM)
			return TRUE
		if(RIG_ZONE_LEFT_LEG)
			set_module_zone(RIG_ZONE_RIGHT_LEG)
			return TRUE
		if(RIG_ZONE_RIGHT_LEG)
			set_module_zone(RIG_ZONE_LEFT_LEG)
			return TRUE
		else
			return FALSE
