//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/mob/verb/verb_activate_inhand()
	set name = "Activate Held Object"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	activate_inhand()

/mob/proc/keybind_activate_inhand()
	activate_inhand()

/**
 * Activates the object in your held hand
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/activate_inhand(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.attack_self(src, actor)

/mob/verb/verb_unique_inhand()
	set name = "Unique Action"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	unique_inhand()

/mob/proc/keybind_unique_inhand()
	unique_inhand()

/**
 * Activates the object in your held hand
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/unique_inhand(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.unique_action(actor)

/mob/verb/verb_defensive_toggle()
	set name = "Defend Using Inhand"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	defensive_toggle()

/mob/proc/keybind_defensive_toggle()
	defensive_toggle()

/**
 * Activates the object in your held hand
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/defensive_toggle(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.defensive_toggle(actor)

/mob/verb/verb_defensive_trigger()
	set name = "Counter With Inhand"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	defensive_trigger()

/mob/proc/keybind_defensive_trigger()
	defensive_trigger()

/**
 * Activates the object in your held hand
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/defensive_trigger(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.defensive_trigger(actor)
