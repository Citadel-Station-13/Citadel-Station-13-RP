/obj/item/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	icon = 'icons/obj/device.dmi'
	icon_state = "binoculars"
	damage_force = 5.0
	w_class = WEIGHT_CLASS_SMALL
	throw_force = 5.0
	throw_range = 15
	throw_speed = 3

	//materials_base = list("metal" = 50, MAT_GLASS = 50)


/obj/item/binoculars/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	zoom()
