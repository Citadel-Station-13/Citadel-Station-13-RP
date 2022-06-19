/obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_construction"
	anchored = FALSE
	opacity = NONE
	density = TRUE
	var/wired = FALSE

/obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

/obj/structure/firedoor_assembly/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/cable_coil) && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = C
		if (cable.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You need one length of coil to wire \the [src]."))
			return
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 40) && !wired && anchored)
			if (cable.use(1))
				wired = TRUE
				to_chat(user, SPAN_NOTICE("You wire \the [src]."))

	else if(C.is_wirecutter() && wired )
		playsound(src.loc, C.usesound, 100, TRUE)
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 40))
			if(!src) return
			to_chat(user, SPAN_NOTICE("You cut the wires!"))
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = FALSE

	else if(istype(C, /obj/item/circuitboard/airalarm) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
			user.visible_message(
				SPAN_WARNING("[user] has inserted a circuit into \the [src]!"),
				SPAN_NOTICE("You have inserted the circuit into \the [src]!"))
			new /obj/machinery/door/firedoor(src.loc)
			qdel(C)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You must secure \the [src] first!"))
	else if(C.is_wrench())
		anchored = !anchored
		playsound(src.loc, C.usesound, 50, 1)
		user.visible_message(
			SPAN_WARNING("[user] has [anchored ? "" : "un" ]secured \the [src]!"),
			SPAN_NOTICE("You have [anchored ? "" : "un" ]secured \the [src]!"))
		update_icon()
	else if(!anchored && istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user.visible_message(
				SPAN_WARNING("[user] dissassembles \the [src]."),
				SPAN_NOTICE("You start to dissassemble \the [src]."))
			if(do_after(user, 40))
				if(!src || !WT.isOn()) return
				user.visible_message(
					SPAN_WARNING("[user] has dissassembled \the [src]."),
					SPAN_NOTICE("You have dissassembled \the [src]."))
				new /obj/item/stack/material/steel(src.loc, 2)
				qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel."))
	else
		..(C, user)
