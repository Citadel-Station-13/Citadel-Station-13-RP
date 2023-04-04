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
	var/category = "Abilities"

	//? mob
	/// owning mob - can be null if we aren't bound / granted to anyone.
	var/mob/owner
	/// action button
	var/datum/action/button
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
	/// cooldown delay, if we have a cooldown
	var/cooldown = 0
	/// last use world.time
	var/last_used
	/// for toggled abilities, turning off incurs the cooldown - otherwise, cooldown begins on toggling off.
	var/cooldown_toggle_off = TRUE

#warn impl

/datum/ability/proc/action_trigger()
	#warn impl

/**
 * called to try to trigger.
 *
 * @params
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/attempt_trigger(toggling)
	#warn impl

/**
 * called on trigger
 *
 * @params
 * * toggling - null if not toggled ability / not toggling, TRUE / FALSE for on / off.
 */
/datum/ability/proc/on_trigger(toggling)
	return

/datum/ability/proc/quickbind()
	#warn impl

/datum/ability/proc/unbind()
	#warn impl

/datum/ability/proc/associate(mob/M)
	#warn impl

/datum/ability/proc/disassociate(mob/M)
	#warn impl

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
