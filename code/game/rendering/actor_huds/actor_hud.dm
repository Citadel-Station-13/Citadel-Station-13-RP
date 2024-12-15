//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * actor huds are:
 *
 * * used by one (1) client
 * * bound to one (1) mob
 * * renders the state of that mob if needed
 * * renders the state of the client's intent / will otherwise
 *
 * Add/remove screen/image procs are **stateless**.
 * `screens()` and `images()` gather everything up.
 * This is to save some CPU / memory as it's rare to need everything rather
 * than just 'patch' the client's render.
 */
/datum/actor_hud
	/// the mob we're bound to right now
	///
	/// * this is our actor
	var/mob/actor
	/// the client we're made for
	///
	/// * this is our controller
	var/client/owner
	/// our holder
	///
	/// * just a collection of actor huds
	var/datum/actor_hud_holder/holder

/datum/actor_hud/New(datum/actor_hud_holder/holder)
	src.holder = holder
	src.owner = holder.owner

/datum/actor_hud/Destroy()
	unbind_from_mob()
	return ..()

/datum/actor_hud/proc/bind_to_mob(mob/target)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(actor == target)
		return TRUE
	else if(actor)
		unbind_from_mob()
	actor = target
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(bound_actor_deleted))
	on_mob_bound(target)
	return TRUE

/datum/actor_hud/proc/unbind_from_mob()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!actor)
		return
	UnregisterSignal(actor, COMSIG_PARENT_QDELETING)
	var/mob/old = actor
	actor = null
	on_mob_unbound(old)

/datum/actor_hud/proc/bound_actor_deleted(datum/source)
	ASSERT(source == actor)
	unbind_from_mob()

/datum/actor_hud/proc/on_mob_bound(mob/target)
	return

/datum/actor_hud/proc/on_mob_unbound(mob/target)
	return

/**
 * syncs hud
 */
/datum/actor_hud/proc/sync_to_preferences(datum/hud_preferences/preference_set)
	for(var/atom/movable/screen/screen_object in screens())
		screen_object.sync_to_preferences(preference_set)

/**
 * returns all screens we should apply to a client
 */
/datum/actor_hud/proc/screens()
	return list()

/**
 * returns all images we should apply to a client
 */
/datum/actor_hud/proc/images()
	return list()

/**
 * wrapper; use this instead of directly editing client variables.
 *
 * * arg can be a list or a single object
 */
/datum/actor_hud/proc/add_screen(atom/movable/what)
	owner.screen += what

/**
 * wrapper; use this instead of directly editing client variables.
 *
 * * arg can be a list or a single object
 */
/datum/actor_hud/proc/remove_screen(atom/movable/what)
	owner.screen -= what

/**
 * wrapper; use this instead of directly editing client variables.
 *
 * * arg can be a list or a single object
 */
/datum/actor_hud/proc/add_image(image/what)
	owner.images += what

/**
 * wrapper; use this instead of directly editing client variables.
 *
 * * arg can be a list or a single object
 */
/datum/actor_hud/proc/remove_image(image/what)
	owner.images -= what
