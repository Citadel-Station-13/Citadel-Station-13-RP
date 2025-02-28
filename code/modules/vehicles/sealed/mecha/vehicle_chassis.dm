
/obj/item/vehicle_chassis
	name="Mecha Chassis"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "backbone"
	w_class = WEIGHT_CLASS_HUGE
	var/datum/construction/construct

/obj/item/vehicle_chassis/attackby(obj/item/W, mob/user)
	if(!construct || !construct.action(W, user))
		..()
	return

/obj/item/vehicle_chassis/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	return

/obj/item/vehicle_chassis/fighter
	name="Fighter Chassis"
	icon = 'icons/mecha/fighters_construct64x64.dmi'
	icon_state = "backbone"

/obj/item/vehicle_chassis/micro
	icon = 'icons/mecha/mech_construct_vr.dmi'
	icon_state = "blank"
	w_class = WEIGHT_CLASS_NORMAL
