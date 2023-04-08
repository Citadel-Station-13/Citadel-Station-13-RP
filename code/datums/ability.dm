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
	/// for toggle interacts: are we enabled?
	var/enabled = FALSE

#warn impl

/**
 * generates our action button if it doesn't exist
 *
 * @return our action button.
 */
/datum/ability/proc/generate_action()
	if(!isnull(action))
		return action
	action = new(src)
	action.button_icon = action_icon
	action.button_icon_state = action_state
	action.background_icon = background_icon
	action.background_icon_state = background_state
	return action

/datum/ability/proc/update_action()
	#warn impl

/datum/ability/ui_action_click(datum/action/action, mob/user)
	. = ..()
	action_trigger(user)

/datum/ability/proc/action_trigger(mob/user)
	attempt_trigger(user)

/**
 * called to try to trigger.
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/attempt_trigger(mob/user, toggling)
	if(!check_trigger(toggling))
		return
	on_trigger(toggling)

/**
 * called to check a trigger.
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/check_trigger(mob/user, toggling)
	#warn standard implements for cooldown/whatever.
	return available_check()

/**
 * called on trigger
 *
 * @params
 * * user - triggering user. this is usually owner, but sometimes isn't.
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/on_trigger(mob/user, toggling)
	if(interact_type != ABILITY_INTERACT_TOGGLE)
		return
	if(!isnull(toggling) && toggling == enabled)
		return
	if(isnull(toggling))
		toggling = !enabled
	if(enabled && !toggling)
		disable()
	else if(!enabled && toggling)
		enable()

/datum/ability/proc/enable()
	enabled = TRUE
	update_action()
	on_enable()

/datum/ability/proc/disable()
	enabled = FALSE
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
	if(bound)
		action?.grant(M)

/datum/ability/proc/disassociate(mob/M)
	ASSERT(owner == M)
	if(bound)
		action?.remove(M)
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
