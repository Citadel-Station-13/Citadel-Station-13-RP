/**
 * ability system
 *
 * - single, mob owner
 * - supports trigger / toggle presets
 * - supports custom tgui
 *
 * used for intrinsic species / antagonist / body abiltiies
 */
/datum/ability
	//? basics
	/// name
	var/name = "Unnamed ability"
	/// desc
	var/desc = "Some sort of ability."
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
	var/background_state = "alien"
	/// currently hotbound?
	var/bound = FALSE
	/// automatically hotbound?
	var/always_bind = FALSE

	//? interaction
	/// default interaction mode
	var/interact_type = ABILITY_INTERACT_NONE
	/// tgui id
	var/tgui_id = "TGUIAbility"

	//? checks
	/// check flags - see [code/__DEFINES/ability.dm]
	var/ability_check_flags = NONE
	/// mobility check flags
	var/mobility_check_flags = NONE

	//? state
	/// cooldown delay, if we have a cooldown
	var/cooldown = 0
	/// for toggled abilities, turning off incurs the cooldown - otherwise, cooldown begins on toggling off.
	var/cooldown_for_deactivation = TRUE
	/// windup delay, if we have a windup
	var/windup = 0
	/// windup requires standing still
	var/windup_requires_still = TRUE
	/// last use world.time
	var/last_used
	/// timerid for cooldown finish action button update
	var/cooldown_visual_timerid
	/// for toggle interacts: are we enabled?
	var/enabled = FALSE

/datum/ability/Destroy()
	if(!isnull(owner))
		disassociate(owner)
	if(!isnull(action))
		QDEL_NULL(action)
	return ..()

/**
 * generates our action button if it doesn't exist
 *
 * @return our action button.
 */
/datum/ability/proc/generate_action()
	if(!isnull(action))
		return action
	action = new(src)
	action.name = hotbind_name()
	action.desc = hotbind_desc()
	action.button_managed = TRUE
	action.button_icon = action_icon
	action.button_icon_state = action_state
	action.background_icon = background_icon
	action.background_icon_state = background_state
	update_action()
	return action

/datum/ability/proc/update_action()
	var/availability = 1
	if(cooldown)
		availability = clamp((world.time - last_used) / cooldown, 0, 1)
	action?.push_button_update(availability, (interact_type == ABILITY_INTERACT_TOGGLE) && enabled)
	recheck_queued_action_update()

/datum/ability/proc/recheck_queued_action_update()
	if(cooldown_visual_timerid)
		deltimer(cooldown_visual_timerid)
		cooldown_visual_timerid = null
	var/next_available = 0
	if(cooldown && (world.time < last_used + cooldown))
		next_available = max(next_available, (last_used + cooldown) - world.time)
	if(next_available > 0)
		addtimer(CALLBACK(src, PROC_REF(update_action)), next_available, TIMER_STOPPABLE)

/datum/ability/ui_action_click(datum/action/action, mob/user)
	. = ..()
	action_trigger(user)

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
	if(!check_trigger(user, toggling, TRUE))
		return
	if(windup)
		if(!do_after(user, windup, (windup_requires_still? NONE : DO_AFTER_IGNORE_MOVEMENT), mobility_check_flags))
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
	if((isnull(toggling) || toggling || (!toggling && cooldown_for_deactivation)) && (cooldown + last_used > world.time))
		to_chat(user, SPAN_WARNING("[src] is still on cooldown! ([round((world.time - last_used) * 0.1, 0.1)] / [round(cooldown * 0.1, 0.1)])"))
		return FALSE
	if(!available_check())
		to_chat(user, SPAN_WARNING("You can't do that right now!"))
		return FALSE
	return TRUE

/**
 * called on trigger
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/on_trigger(mob/user, toggling)
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
	on_enable()

/datum/ability/proc/disable(update_action)
	enabled = FALSE
	if(update_action)
		update_action()
	on_disable()

/datum/ability/proc/on_enable()
	return

/datum/ability/proc/on_disable()
	return

/datum/ability/proc/quickbind()
	if(bound)
		return
	bound = TRUE
	generate_action()
	if(!isnull(owner))
		action?.grant(owner)

/datum/ability/proc/unbind()
	bound = FALSE
	if(!isnull(owner))
		action?.remove(owner)

/datum/ability/proc/associate(mob/M)
	if(owner == M)
		return
	ASSERT(isnull(owner))
	owner = M
	owner.register_ability(src)
	if(bound)
		action?.grant(M)
		update_action()
	else if(always_bind)
		quickbind()

/datum/ability/proc/disassociate(mob/M)
	ASSERT(owner == M)
	if(bound)
		action?.remove(owner)
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
	if((ability_check_flags & ABILITY_CHECK_STANDING) && owner.lying)
		return FALSE
	if((ability_check_flags & ABILITY_CHECK_FREE_HAND) && !(owner.has_free_hand()))
		return FALSE
	if((ability_check_flags & ABILITY_CHECK_STUNNED) && (!IS_CONSCIOUS(owner) || owner.stunned || owner.weakened || owner.incapacitated()))
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
	if((ability_check_flags & ABILITY_CHECK_FREE_HAND) && !(owner.has_free_hand()))
		return "You cannot do that without a free hand."
	if((ability_check_flags & ABILITY_CHECK_STUNNED) && (!IS_CONSCIOUS(owner) || owner.stunned || owner.weakened || owner.incapacitated()))
		return "You cannot do that while incapacitated."

/**
 * static data for tgui panel
 */
/datum/ability/ui_static_data(mob/user)
	return list(
		"$tgui" = tgui_id,
		"$src" = REF(src),
		"interact_type" = interact_type,
		"can_bind" = !always_bind && (interact_type != ABILITY_INTERACT_NONE),
		"bound" = bound,
		"name" = name,
		"desc" = desc,
	)

/**
 * action datums for abilities
 */
/datum/action/ability
	abstract_type = /datum/action/ability
	target_type = /datum/ability
