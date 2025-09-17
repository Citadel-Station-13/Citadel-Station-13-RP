//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: DECLARE_MOB_VERB(), managed verbs maybe

/mob/verb/verb_activate_inhand()
	set name = "Activate Held Object"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	activate_inhand()

/mob/proc/keybind_activate_inhand()
	activate_inhand()

/**
 * Activates the object in your held hand (default action)
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/activate_inhand(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.attack_self(src, actor)

/mob/verb/verb_unique_inhand()
	set name = "Unique Held Action"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	unique_inhand()

/mob/proc/keybind_unique_inhand()
	unique_inhand()

/**
 * Activates the object in your held hand (unique action)
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/unique_inhand(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.unique_action(actor)

/mob/verb/verb_defensive_toggle()
	set name = "Defend Using Held"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	defensive_toggle()

/mob/proc/keybind_defensive_toggle()
	defensive_toggle()

/**
 * Attempts to use the function on 'active defensive toggle' on the object in your active hand.
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/defensive_toggle(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.defensive_toggle(actor)

/mob/verb/verb_defensive_trigger()
	set name = "Counter With Held"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	defensive_trigger()

/mob/proc/keybind_defensive_trigger()
	defensive_trigger()

/**
 * Attempts to use the function on 'active defensive trigger' on the object in your active hand.
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/defensive_trigger(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	get_active_held_item()?.defensive_trigger(actor)

/mob/verb/verb_wield_inhand()
	set name = "Wield Held Item"
	set category = VERB_CATEGORY_OBJECT
	set src = usr

	wield_inhand()

/mob/proc/keybind_wield_inhand()
	wield_inhand()

/**
 * Attempts to wield the item in your hand.
 *
 * * Sent from keybinds or a verb
 */
/mob/proc/wield_inhand(datum/event_args/actor/actor = new /datum/event_args/actor(src))
	// yes, get component is asinine sometimes
	// i don't care though, this is such a small feature
	var/obj/item/I = get_active_held_item()
	if(!I)
		actor?.chat_feedback(SPAN_WARNING("You are not holding anything to wield."))
		return
	if(istype(I, /obj/item/offhand/wielding))
		var/obj/item/offhand/wielding/unwield_this_offhand = I
		unwield_this_offhand.host.unwield()
		return
	var/datum/component/wielding/comp = I.GetComponent(/datum/component/wielding)
	if(!comp)
		actor?.chat_feedback(SPAN_WARNING("That can't be wielded."))
		return
	if(comp.wielder)
		comp.unwield()
	else
		comp.wield(src)
