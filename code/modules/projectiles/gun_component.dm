//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * A component used in guns with modular parts.
 *
 * * This is **not** an attachment system. This is for things integral to gun operation.
 */
/obj/item/gun_component
	name = "gun component"
	desc = "A thing, that probably goes in a gun."

	/// component slot
	///
	/// * This is just a suggestion.
	/// * The actual APIs used are agnostic of this value.
	var/component_slot
	/// should we be hidden from examine?
	var/show_on_examine = TRUE

//* Attach / Detach *//

/**
 * returns if we should fit on a gun
 *
 * we get the final say
 */
/obj/item/gun_component/proc/fits_on_gun(obj/item/gun/gun, gun_opinion)
	return TRUE

/**
 * called on attach
 */
/obj/item/gun_component/proc/on_attach(obj/item/gun/gun)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called on detach
 */
/obj/item/gun_component/proc/on_detach(obj/item/gun/gun)
	SHOULD_CALL_PARENT(TRUE)

//* Information *//

/**
 * Called to query the stat bullet points of this component
 *
 * @return a list of data about us to put in bullet points, in raw HTML
 */
/obj/item/gun_component/proc/summarize_bullet_points(datum/event_args/actor/actor)
	return list()
