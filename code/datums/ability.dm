/**
 * ability system
 *
 * - single, mob owner
 * - supports trigger / toggle presets
 * - supports custom tgui
 *
 * used for intrinsic species / antagonist / body abiltiies
 *
 * * abilities can have state serialized serialize_state() and deserialize_state() separately
 *   from the actual ability. this allows for managing ability states without needing to
 *   store the actual ability and its properties.
 */
/datum/ability
	//* Identity *//
	/// name
	var/name = "Unnamed ability"
	/// desc
	var/desc = "Some sort of ability."
	// TODO: do we want a holder system and an action holder system instead of categories? or is this good enough?
	// TODO: standard category icons and ability tgui when?
	/// category - used for tgui
	var/category = "Misc"

	//? mob
	/// owning mob - can be null if we aren't bound / granted to anyone.
	var/mob/owner

	//? binding
	/// action datum
	var/datum/action/action
	/// action button icon
	var/action_icon = 'icons/screen/actions/actions.dmi'
	/// action button icon state
	var/action_state = "default"
	/// action button background icon
	var/background_icon = 'icons/screen/actions/backgrounds.dmi'
	/// action button background icon state - the _on overlay will be added while active, automatically.
	var/background_state = "default"
	/// currently hotbound?
	var/bound = FALSE
	/// automatically hotbound?
	var/always_bind = FALSE

	//? interaction
	/// default interaction mode
	var/interact_type = ABILITY_INTERACT_NONE
	/// currently hidden?
	var/hidden = FALSE
	/// targeted?
	/// targeted abilities only work with ABILITY_INTERACT_TOGGLE
	var/targeted = FALSE
	/// target type? Can be anything (atoms), mobs or turfs
	var/targeting_type = ABILITY_TARGET_ALL
	/// range?
	var/range

	//? ui
	/// tgui id
	var/tgui_id = "TGUIAbility"

	//? checks
	/// check flags - see [code/__DEFINES/ability.dm]
	var/ability_check_flags = NONE
	/// mobility check flags
	var/mobility_check_flags = NONE

	//? state
	/// for toggled abilities, turning off incurs the cooldown - otherwise, cooldown begins on toggling off.
	#warn handle
	var/cooldown_for_deactivation = TRUE
	/// windup delay, if we have a windup
	var/windup = 0
	/// windup requires standing still
	var/windup_requires_still = TRUE
	/// last use world.time; null if we haven't been used yet
	var/last_used
	/// for toggle interacts: are we enabled?
	var/enabled = FALSE

	//* Cooldown *//
	/// default cooldown time, if any
	var/cooldown = 0
	/// world.time we can be used next
	#warn impl
	var/cooldown_expires
	/// timerid of cooldown update timer
	#warn impl
	var/cooldown_timerid
	/// cooldown applies at start of successful invocation
	/// * if this is FALSE, cooldown starts after this is disabled,
	///   or if we sleep as a triggered spell, when the sleeping proc returns.
	var/cooldown_applies_post_invocation = FALSE

	#warn put in 'set_cooldown_left()', 'put_on_cooldown()'

/datum/ability/Destroy()
	if(!isnull(owner))
		disassociate(owner)
	if(!isnull(action))
		QDEL_NULL(action)
	return ..()

/datum/ability/serialize()
	. = ..()
	.["state"] = serialize_state()

/datum/ability/deserialize(list/data)
	if(date["state"])
		deserialize_state(data["state"])

/datum/ability/proc/serialize_state()
	return list()

/datum/ability/proc/deserialize_state(list/state)
	return

/**
 * generates our action button if it doesn't exist
 *
 * @return our action button.
 */
/datum/ability/proc/generate_action()
	if(!isnull(action))
		return action
	rebuild_action()
	return action

/**
 * full action button update including icon regeneration
 * creates the action if it did not already exist.
 */
/datum/ability/proc/rebuild_action()
	if(isnull(action))
		action = new(src)
	action.name = hotbind_name()
	action.desc = hotbind_desc()
	action.button_icon = action_icon
	action.button_icon_state = action_state
	action.background_icon = background_icon
	action.background_icon_state = background_state
	update_action()

/**
 * updates action button for availability / toggle status
 */
/datum/ability/proc/update_action()
	var/availability = 1
	if(cooldown && !isnull(last_used))
		availability = clamp((world.time - last_used) / cooldown, 0, 1)
	action?.background_additional_overlay = (interact_type) == ABILITY_INTERACT_TOGGLE && enabled ? "[background_state]_on" : null
	action?.push_button_availability(availability, FALSE)
	action?.update_buttons()
	recheck_queued_action_update()

/datum/ability/proc/recheck_queued_action_update()
	if(cooldown_visual_timerid)
		deltimer(cooldown_visual_timerid)
		cooldown_visual_timerid = null
	var/next_available = 0
	if(cooldown && !isnull(last_used) && (world.time < last_used + cooldown))
		next_available = max(next_available, (last_used + cooldown) - world.time)
	if(next_available > 0)
		addtimer(CALLBACK(src, PROC_REF(update_action)), next_available, TIMER_STOPPABLE)

/datum/ability/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	. = ..()
	action_trigger(actor.performer)

/datum/ability/proc/action_trigger(mob/user)
	attempt_trigger(user)

/datum/ability/proc/hotbind_name()
	return "[category] - [name]"

/datum/ability/proc/hotbind_desc()
	return desc

/**
 * called to try to trigger.
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/attempt_trigger(mob/user, toggling)
	if(interact_type == ABILITY_INTERACT_TOGGLE)
		if(!isnull(toggling) && toggling == enabled)
			return
		if(isnull(toggling))
			toggling = !enabled
		if(targeted)
			if(ishuman(user) && toggling == TRUE)
				var/mob/living/carbon/human/H = user
				H.ab_handler?.process_ability(src)
	if(!check_trigger(user, toggling, TRUE))
		return
	if(windup)
		if(!do_after(user, windup, flags = (windup_requires_still? NONE : DO_AFTER_IGNORE_MOVEMENT), mobility_flags = mobility_check_flags))
			return
		if(!check_trigger(user, toggling, TRUE))
			return
	on_trigger(user, toggling)

/**
 * called to check a trigger.
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 * * feedback - output feedback messages
 */
/datum/ability/proc/check_trigger(mob/user, toggling, feedback)
	if(!isnull(last_used) && (isnull(toggling) || toggling || (!toggling && cooldown_for_deactivation)) && (cooldown + last_used > world.time))
		to_chat(user, SPAN_WARNING("[src] is still on cooldown! ([round((world.time - last_used) * 0.1, 0.1)] / [round(cooldown * 0.1, 0.1)])"))
		return FALSE
	if(!available_check())
		to_chat(user, SPAN_WARNING(unavailable_reason()))
		return FALSE
	return TRUE

/**
 * called on trigger
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/on_trigger_old(mob/user, toggling)
	last_used = world.time
	if(interact_type != ABILITY_INTERACT_TOGGLE)
		update_action()
		return
	if(!isnull(toggling) && toggling == enabled)
		return
	if(isnull(toggling))
		toggling = !enabled
	if(enabled && !toggling)
		disable()
	else if(!enabled && toggling)
		enable()

/datum/ability/proc/enable(update_action)
	enabled = TRUE
	if(update_action)
		update_action()
	action?.background_icon_state += "_on"
	action?.update_buttons()
	on_enable()

/datum/ability/proc/disable(update_action)
	enabled = FALSE
	if(update_action)
		update_action()
	action?.background_icon_state = background_state
	action?.update_buttons()
	on_disable()

/datum/ability/proc/quickbind()
	if(bound)
		return
	bound = TRUE
	generate_action()
	if(!isnull(owner))
		action?.grant(owner.actions_innate)

/datum/ability/proc/unbind()
	bound = FALSE
	if(!isnull(owner))
		action?.revoke(owner.actions_innate)

/datum/ability/proc/associate(mob/M)
	if(owner == M)
		return
	ASSERT(isnull(owner))
	owner = M
	owner.register_ability(src)
	if(bound)
		action?.grant(owner.actions_innate)
		update_action()
	else if(always_bind && !hidden)
		quickbind()

/datum/ability/proc/disassociate(mob/M)
	ASSERT(owner == M)
	if(bound)
		action?.revoke(owner.actions_innate)
	owner.unregister_ability(src)
	owner = null

/**
 * checks if we can be used
 */
/datum/ability/proc/available_check()
	if(isnull(owner))
		return FALSE
	if(ability_check_flags == NONE)
		return TRUE
	if((ability_check_flags & ABILITY_CHECK_CONSCIOUS) && !IS_CONSCIOUS(owner))
		return FALSE
	if((ability_check_flags & ABILITY_CHECK_STANDING) && IS_PRONE(owner))
		return FALSE
	if((ability_check_flags & ABILITY_CHECK_FREE_HAND) && !(!owner.are_usable_hands_full()))
		return FALSE
	if((ability_check_flags & ABILITY_CHECK_RESTING) && !IS_PRONE(owner))
		return FALSE
	if(!CHECK_MOBILITY(owner, mobility_check_flags))
		return FALSE
	return TRUE

/**
 * checks if we can be used, returning reason on failure or null for success.
 */
/datum/ability/proc/unavailable_reason()
	if(isnull(owner))
		return "!ERROR - NO OWNER!"
	if(ability_check_flags == NONE)
		return
	if((ability_check_flags & ABILITY_CHECK_CONSCIOUS) && !IS_CONSCIOUS(owner))
		return "You cannot do that while unconscious."
	if((ability_check_flags & ABILITY_CHECK_STANDING) && owner.lying)
		return "You cannot do that while on the ground."
	if((ability_check_flags & ABILITY_CHECK_FREE_HAND) && !(!owner.are_usable_hands_full()))
		return "You cannot do that without a free hand."
	if((ability_check_flags & ABILITY_CHECK_RESTING) && !owner.lying)
		return "You must be lying down to do that."
	if(!CHECK_MOBILITY(owner, mobility_check_flags))
		return "You cannot do that while incapacitated."

/**
 * sets us to hidden - no binding and not seen on panel
 */
/datum/ability/proc/hide()
	hidden = TRUE
	unbind()

/**
 * sets us to not hidden - bind if needed, seen on panel.
 */
/datum/ability/proc/unhide()
	hidden = FALSE
	if(always_bind)
		quickbind()


/**
 * checks if the target is within range and the ability is triggerable
 */
/datum/ability/proc/target_check(mob/user, atom/target)
	if(range)
		if(get_dist(get_turf(user),get_turf(target)) > range)
			return FALSE
	if(check_trigger(user))
		target_trigger(user,target)
		return TRUE
	return FALSE

/**
 * target-affecting proc
 */
/datum/ability/proc/target_trigger(mob/user, atom/target)
	//target-related code goes here
	disable()

/**
 * static data for tgui panel
 */
/datum/ability/ui_static_data(mob/user, datum/tgui/ui)
	return list(
		"$tgui" = tgui_id,
		"$src" = REF(src),
		"interact_type" = interact_type,
		"can_bind" = !always_bind && (interact_type != ABILITY_INTERACT_NONE),
		"bound" = bound,
		"name" = name,
		"desc" = desc,
	)

//* Hooks *//

/**
 * * Sleeping is allowed.
 * * Enable / Disable is fired before this.
 *
 * @return TRUE if triggered. Cooldown and similar will only apply if trigger is successful.
 */
#warn hook
/datum/ability/proc/on_trigger()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

/**
 * * Called additionally to `on_trigger` if there's a target.
 * * Enable / Disable is fired before this.
 * * Sleeping is allowed.
 *
 * @params
 * * target - target entity, if any
 * * clickchain - provided clickchain for the triggering click, if any
 *
 * @return TRUE if triggered. Cooldown and similar will only apply if trigger is successful.
 */
#warn hook target
/datum/ability/proc/on_targeted_trigger(atom/target, datum/event_args/actor/clickchain/clickchain)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

/**
 * * Called additionally to `on_trigger` if we're a toggled ability.
 * * Sleeping is allowed.
 * * Called before on-trigger
 */
/datum/ability/proc/on_enable()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

#warn hook target
/**
 * * Called additionally to `on_enable` if we're a targeted ability.
 * * Sleeping is allowed.
 * * Called before on-trigger
 *
 * @params
 * * target - target entity, if any
 * * clickchain - provided clickchain for the triggering click, if any
 */
/datum/ability/proc/on_targeted_enable()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

/**
 * * Called additionally to `on_trigger` if we're a toggled ability.
 * * Sleeping is allowed.
 * * Called before on-trigger
 */
/datum/ability/proc/on_disable()
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

#warn hook target
/**
 * * Called additionally to `on_disable` if we're a targeted ability.
 * * Sleeping is allowed.
 * * Called before on-trigger
 *
 * @params
 * * target - target entity, if any
 * * clickchain - provided clickchain for the triggering click, if any
 */
/datum/ability/proc/on_targeted_disable(atom/target, datum/event_args/actor/clickchain/clickchain)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

//* Action Button *//

/**
 * action datums for abilities
 */
/datum/action/ability
	abstract_type = /datum/action/ability
	target_type = /datum/ability
