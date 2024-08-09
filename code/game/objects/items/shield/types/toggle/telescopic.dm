/obj/item/shield/transforming/telescopic
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon = 'icons/items/shields/transforming.dmi'
	icon_state = "telescopic"
	base_icon_state = "telescopic"
	slot_flags = NONE

	damage_force = 5
	active_damage_force = 10
	inactive_damage_force = 5

	w_class = WEIGHT_CLASS_NORMAL
	active_weight_class = WEIGHT_CLASS_BULKY
	inactive_weight_class = WEIGHT_CLASS_NORMAL

	activation_sound = 'sound/weapons/empty.ogg'

	throw_force = 5
	throw_speed = 3
	throw_range = 5

/obj/item/shield/transforming/telescopic/on_activate(datum/event_args/actor/actor, silent)
	. = ..()
	slot_flags = SLOT_BACK
	actor.chat_feedback(
		SPAN_WARNING("You extend \the [src]."),
		target = src,
	)

/obj/item/shield/transforming/telescopic/on_deactivate(datum/event_args/actor/actor, silent)
	. = ..()
	slot_flags = NONE
	actor.chat_feedback(
		SPAN_WARNING("You collapse \the [src]."),
		target = src,
	)
