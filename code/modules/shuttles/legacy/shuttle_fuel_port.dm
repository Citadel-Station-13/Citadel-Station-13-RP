
/obj/structure/shuttle_fuel_port
	name = "fuel port"
	desc = "The fuel input port of the shuttle. Holds one fuel tank. Use a crowbar to open and close it."
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "fuel_port"
	density = 0
	anchored = 1
	var/icon_closed = "fuel_port"
	var/icon_empty = "fuel_port_empty"
	var/icon_full = "fuel_port_full"
	var/opened = 0
	var/parent_shuttle
	var/base_tank = /obj/item/tank/phoron

	var/datum/shuttle/bound_shuttle

/obj/structure/shuttle_fuel_port/Initialize(mapload)
	. = ..()
	if(base_tank)
		new base_tank(src)
	redetect_shuttle()

/obj/structure/shuttle_fuel_port/Destroy()
	clear_shuttle()
	return ..()

// TODO: area change detection, this doesn't work
/obj/structure/shuttle_fuel_port/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(get_turf(old_loc) != get_turf(src))
		redetect_shuttle()

/obj/structure/shuttle_fuel_port/proc/redetect_shuttle()
	if(bound_shuttle)
		clear_shuttle()

	var/area/shuttle/shuttle_area = get_area(src)
	if(istype(shuttle_area) && shuttle_area.shuttle)
		bound_shuttle = shuttle_area.shuttle
		bound_shuttle.legacy_fuel_ports += src

/obj/structure/shuttle_fuel_port/proc/clear_shuttle()
	if(!bound_shuttle)
		return
	bound_shuttle.legacy_fuel_ports -= src
	bound_shuttle = null

/obj/structure/shuttle_fuel_port/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!opened)
		to_chat(user, "<spawn class='notice'>The door is secured tightly. You'll need a crowbar to open it.")
		return
	else if(contents.len > 0)
		user.put_in_hands(contents[1])
	update_icon()

/obj/structure/shuttle_fuel_port/update_icon()
	if(opened)
		if(contents.len > 0)
			icon_state = icon_full
		else
			icon_state = icon_empty
	else
		icon_state = icon_closed
	..()

/obj/structure/shuttle_fuel_port/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_crowbar())
		if(opened)
			to_chat(user, "<spawn class='notice'>You tightly shut \the [src] door.")
			playsound(src.loc, 'sound/effects/locker_close.ogg', 25, 0, -3)
			opened = 0
		else
			to_chat(user, "<spawn class='notice'>You open up \the [src] door.")
			playsound(src.loc, 'sound/effects/locker_open.ogg', 15, 1, -3)
			opened = 1
	else if(istype(W,/obj/item/tank))
		if(!opened)
			to_chat(user, "<spawn class='warning'>\The [src] door is still closed!")
			return
		if(contents.len == 0)
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			to_chat(user, SPAN_WARNING("You install [W] in [src]."))
	update_icon()

/obj/structure/shuttle_fuel_port/heavy
	base_tank = /obj/item/tank/phoron/pressurized

/obj/structure/shuttle_fuel_port/empty
	base_tank = null	//oops, no gas!
	opened = 1	//shows open so you can diagnose 'oops, no gas' easily
	icon_state = "fuel_port_empty"	//set the default state just to be safe
