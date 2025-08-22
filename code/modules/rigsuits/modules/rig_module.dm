//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * modules are modular items that can be inserted into specific complexity on the rig.
 *
 * # lifecycle
 * Modules have a manged lifecycle.
 * * un/install refers to being added/removed to the rig.
 * * de/activation refers to the rig being attached / detached from someone,
 * * on/offline refers to the module being powered / depowered.
 *
 * Lifecycle events are fired in order if added/removed while others are 'active'.
 * As an example, removing a module while modules are powered and the suit is activated will:
 * * first fire 'on_offline' so it's brought offline
 * * then fire 'on_deactivation'
 * * then fire 'on_uninstall'
 * While if the module was in a deactivated suit, it would only call 'on_uninstall'.
 */
/obj/item/rig_module
	name = "rig module"
	desc = "A piece of equipment able to be installed onto powered hardsuits."
	#warn impl all

	materials_base = list(MAT_STEEL = 2000, MAT_PLASTIC = 2500, MAT_GLASS = 1750)
	/// use our own integrity system
	integrity_enabled = FALSE

	//* Core *//
	/// lookup id
	/// * set on a rigsuit so this module is addressable by the console and other features
	/// * shown to players as well as used on the backend.
	var/lookup_id
	/// lookup prefix - set this please
	var/lookup_prefix = "unkw"

	//* Balancing *//
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

	//* Conflicts *//
	/// single-conflict enum; if set, only one of this kind of module can exist on a rig
	/// * this will not conflict with any of the other conflict types!
	var/global_conflict_enum
	/// cannot put more than one of this type in the rig;
	/// * this will not conflict with any of the other conflict types!
	var/global_conflict_type
	/// zone-conflict enum; if set, only one our exact type can exist in any of our zones
	/// * this will not conflict with any of the other conflict types!
	var/zone_conflict_enum
	/// cannot put more than one of this type in any of our zones
	/// * this will not conflict with any of the other conflict types!
	var/zone_conflict_type

	//* Defense *//
	/// brute damage
	var/brute_damage = 0
	/// burn damage
	var/burn_damage = 0
	/// total integrity
	var/max_health = 100

	//* Hotbinds *//
	/// Our hotbind datums
	/// * lazy list
	var/list/datum/rig_hotbind/hotbinds

	//* Installation *//
	/// can be added / removed
	var/can_remove = TRUE

	//* Registration *//
	/// the rig we're on
	var/obj/item/rig/host
	/// needs ticking
	var/host_ticked = FALSE

	//* UI *//
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64
	/// is our UI update queued?
	var/ui_update_queued = FALSE
	/// TGUI route; this is handled by routes.tsx in the Rigsuit folder on TGUI!
	var/tgui_interface = "Inert"
	/// display name
	var/display_name
	/// display desc
	var/display_desc

	//* Zone *//
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
 * first check - 'does it make sense for this to be installed to the rig?'
 * * if not, specify why if not silent and actor is provided
 * * this has final say for denial; this overrides even forced installations.
 *
 * @params
 * * rig - the suit
 * * actor - (optional) person installing
 * * silent - (optional) should we inform the person installing?
 */
/obj/item/rig_module/proc/is_valid_install(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/**
 * * has final say over rig
 * * most regular checks should be rig-side
 * * not checked for forced operations
 *
 * @params
 * * rig - the suit
 * * rig_opinion - what does the suit say about this?
 * * actor - (optional) person installing
 * * silent - (optional) should we inform the person installing?
 */
/obj/item/rig_module/proc/can_install(obj/item/rig/rig, rig_opinion, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/**
 * * has final say over rig
 * * most regular checks should be rig-side
 * * not checked for forced operations
 *
 * @params
 * * rig - the suit
 * * rig_opinion - what does the suit say about this?
 * * actor - (optional) person installing
 * * silent - (optional) should we inform the person installing?
 */
/obj/item/rig_module/proc/can_uninstall(obj/item/rig/rig, rig_opinion, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/obj/item/rig_module/proc/on_install(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/item/rig_module/proc/on_uninstall(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Called after add if the rig is online, or when the rig goes online, or when the rig is mob-swapped.
 * * Use to handle behaviors that need to bind to a mob.
 * * If the rig is mob-swapped, this will be called on the old wearer.
 */
/obj/item/rig_module/proc/on_activation(obj/item/rig/rig, mob/wearer)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * * Called before uninstall if the rig is attached to someone.
 * * Use to handle behaviors that need to bind to a mob.
 * * If the rig is mob-swapped, this will be called on the old wearer.
 */
/obj/item/rig_module/proc/on_deactivation(obj/item/rig/rig, mob/wearer)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Called after add if the rig is online, or when the rig goes online, or when the rig is mob-swapped.
 * * Rig modules go offline when the module bus power is cut.
 * * Use to handle behaviors that need to bind to a mob.
 * * If the rig is mob-swapped, this will be called on the old wearer.
 */
/obj/item/rig_module/proc/on_online(obj/item/rig/rig, mob/wearer)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Called before remove if the rig is offline, or when the rig is taken offline, or when the rig is mob-swapped.
 * * Rig modules go offline when the module bus power is cut.
 * * Use to handle behaviors that need to bind to a mob.
 * * If the rig is mob-swapped, this will be called on the old wearer.
 */
/obj/item/rig_module/proc/on_offline(obj/item/rig/rig, mob/wearer)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

//* Feedback *//

/**
 * Transmits a feedback message to rig users
 */
/obj/item/rig_module/proc/rig_feedback(msg, datum/event_args/actor/actor)
	host?.on_module_rig_feedback(src, msg, actor)

/**
 * Appends a message to rig logs
 */
/obj/item/rig_module/proc/rig_log(msg)
	host?.on_module_rig_log(src, msg)

// todo: rig sound / vfx ?

//* Console *//
//  TODO: implement

// /**
//  * @return list(command = desc, ...)
//  */
// /obj/item/rig_module/proc/console_query(effective_control_flags, username)
// 	return list()

// /**
//  * @return list(output, admin log text)
//  */
// /obj/item/rig_module/proc/console_process(effective_control_flags, username, command, list/arguments)
// 	return list("unknown command", "<invalid>")

//* Hotbinds *//

/**
 * * Do not access 'action' and 'params' directly from the hotbinding. The reference is there
 *   as an escape hatch.
 */
/obj/item/rig_module/proc/on_hotbind(datum/event_args/actor/actor, datum/rig_hotbind/bind, action, list/params)

/obj/item/rig_module/proc/create_hotbind(action, list/params)

/obj/item/rig_module/proc/on_hotbind_created(datum/rig_hotbind/bind)

/obj/item/rig_module/proc/on_hotbind_destroyed(datum/rig_hotbind/bind)

#warn impl

//* Hooks *//

/**
 * on host tick
 * * only called if `host_ticked` is `TRUE`.
 * * not called while host is offline / deactivated.
 */
/obj/item/rig_module/proc/handle_rig_tick(dt)
	return

/**
 * Called to see if we're interested in an item's usage.
 * * Used so the user can radial for what module to use an item on.
 * @return TRUE if we're interested.
 */
/obj/item/rig_module/proc/check_using_item_on_rig(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/**
 * Called when something is used on the rig as an item.
 * * Use to do grenade refills and whatnot
 */
/obj/item/rig_module/proc/handle_using_item_on_rig(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE
#warn hook

//* Input *//

/obj/item/rig_module/proc/is_active_rig_click_module()
	return host?.get_active_rig_module_click() == src

/obj/item/rig_module/proc/become_active_rig_click_module()
	#warn impl

/**
 * Set this to return TRUE if your module is a selectable module.
 */
/obj/item/rig_module/proc/is_rig_click_module()
	return FALSE

/obj/item/rig_module/proc/handle_rig_module_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return clickchain_flags

//* Interaction *//

/**
 * checks rig reachability if mounted, otherwise performer reachability assuming we're held
 */
/obj/item/rig_module/proc/rig_reachability(atom/target, mob/performer)
	if(host)
		return host.wearer?.Reachability(target)
	return performer?.Reachability(target)

//* Power *//

/obj/item/rig_module/proc/set_static_power_draw(watts)
	#warn impl

/obj/item/rig_module/proc/clear_static_power_draw()
	set_static_power_draw(0)

//* Resource API *//

/obj/item/rig_module/proc/pull_resource_gas_route(obj/item/rig_module/requesting, key, )

#warn AAAA

//* Setters *//

/obj/item/rig_module/proc/set_module_weight(weight)
	var/old = module_weight
	module_weight = weight
	host?.on_module_weight_change(src, old, weight)
	return TRUE

/obj/item/rig_module/proc/set_module_volume(volume)
	var/old = module_volume
	module_volume = volume
	host?.on_module_volume_change(src, old, volume)
	return TRUE

/obj/item/rig_module/proc/set_module_complexity(complexity)
	var/old = module_complexity
	module_complexity = complexity
	host?.on_module_complexity_change(src, old, complexity)
	return TRUE

/obj/item/rig_module/proc/set_module_zone(new_zone)
	// no current handling for setting while installed
	if(host)
		return FALSE
	zone = new_zone
	return TRUE

//* UI *//

/**
 * UI module data
 * * This does not auto-update on tick. Use rig_push_data() as needed, and rig_update_data().
 */
/obj/item/rig_module/proc/rig_data()
	return list(
		"$tgui" = tgui_interface,
	)
	#warn impl

/obj/item/rig_module/proc/rig_push_data(list/data, immediate)
	#warn impl

/obj/item/rig_module/proc/rig_update_data()
	#warn impl

/**
 * @return TRUE if did something (and stop propagation).
 */
/obj/item/rig_module/proc/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	return FALSE

//* Zones *//

/**
 * detect handedness;
 * this only makes sense if we are hand-based
 * we do not check if our arms and legs are for some reason on different sides.
 *
 * @return RIG_HANDEDNESS_X enum
 */
/obj/item/rig_module/proc/get_handedness()
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
