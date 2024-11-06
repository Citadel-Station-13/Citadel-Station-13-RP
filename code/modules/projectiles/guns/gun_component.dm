//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A component used in guns with modular parts.
 *
 * * This is **not** an attachment system. This is for things integral to gun operation.
 */
/obj/item/gun_component
	name = "gun component"
	desc = "A thing, that probably goes in a gun. Why are you seeing this?"
	icon = 'icons/modules/projectiles/gun_components.dmi'
	icon_state = "" // empty state

	/// component slot
	///
	/// * This is just a suggestion.
	/// * The actual APIs used are agnostic of this value.
	var/component_slot
	/// should we be hidden from examine?
	var/show_on_examine = TRUE

	/// currently attached gun
	var/obj/item/gun/attached

//* Attach / Detach *//

/**
 * returns if we should fit on a gun
 *
 * * we get the final say
 * * this includes if the gun is already overcrowded! be careful with this
 *
 * @params
 * * gun - the gun we tried to attach to
 * * gun_opinion - what the gun had to say about it
 * * gun_is_full - is the gun out of slots for us? we can still override but this is to separate it from gun_opinion.
 * * actor - person initiating it; this is mostly for message feedback
 * * silent - do not emit message to user on fail
 */
/obj/item/gun_component/proc/fits_on_gun(obj/item/gun/gun, gun_opinion, gun_is_full, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * called on attach
 */
/obj/item/gun_component/proc/on_attach(obj/item/gun/gun, datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called on detach
 */
/obj/item/gun_component/proc/on_detach(obj/item/gun/gun, datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)

//* Information *//

/**
 * Called to query the stat bullet points of this component
 *
 * @return a list of data about us to put in bullet points, in raw HTML
 */
/obj/item/gun_component/proc/summarize_bullet_points(datum/event_args/actor/actor)
	return list()

