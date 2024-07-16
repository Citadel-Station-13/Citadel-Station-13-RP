/**
 * used to hold data about a click (melee/ranged/other) action
 *
 * the click may be real or fake.
 *
 * * This is required for item swings / interaction, usually, not just base /event_args/actor.
 */
/datum/event_args/actor/clickchain
	/// optional: attack intent
	var/intent
	/// optional: click params
	var/list/params
	/// optional: target atom
	var/atom/target

	//* Attack Data *//

	/// Overall damage multiplier
	///
	/// todo: implement; needs slight clickchain/melee overhaul
	///
	/// * Allowed to be changed by shieldcalls and other intercepts
	var/damage_multiplier = 1

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, atom/target, list/params, intent)
	..()
	src.target = target
	src.params = params || list()
	src.intent = intent

/datum/event_args/actor/clickchain/clone()
	var/datum/event_args/actor/clickchain/cloned = new(performer, initiator, target, params, intent)
	return cloned
