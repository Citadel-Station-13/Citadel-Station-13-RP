/obj/vehicle/sealed/mecha/micro/sec/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(adding.client)
		adding.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")

/obj/vehicle/sealed/mecha/micro/sec/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(removing.client)
		removing.client.mouse_pointer_icon = initial(src.occupant_legacy.client.mouse_pointer_icon)
