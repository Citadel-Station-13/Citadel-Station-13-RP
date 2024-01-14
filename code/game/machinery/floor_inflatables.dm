/**
 * A compartment in the floor for storing an inflatable wall, which is automatically deployed when air alarms trigger
 */

/obj/machinery/floor_inflatables
	name = "floor mounted inflatables"
	icon = 'icons/obj/doors/hazard/floor_inflatables.dmi'
	icon_state = "setup"
	density = 0
	opacity = 0
	var/obj/item/inflatable/stored

/obj/machinery/floor_inflatables/Initialize(mapload)
	. = ..()
	stored = new(src)
	var/area/A = get_area(src)
	ASSERT(istype(A))
	LAZYADD(A.all_doors, src)
	update_icon()

/obj/machinery/floor_inflatables/update_icon(updates)
	. = ..()
	if(stored)
		icon_state = "setup"
	else
		icon_state = "deployed"

/obj/machinery/floor_inflatables/proc/trigger()
	if(!stored)
		return
	if(istype(stored))
		stored.inflate(location = get_turf(src))
	else
		stored.forceMove(get_turf(src))
	stored = null
	update_icon()

/obj/machinery/floor_inflatables/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user, 0, C)
	add_fingerprint(user, 0, src)
	if(istype(C))
		if(C.w_class <= ITEMSIZE_NORMAL)
			C.forceMove(src)
			stored = C
			to_chat(user, "You slide [C] into the compartment and close it.")
			update_icon()
		else
			to_chat(user, "[C] is to large for [src]")

/obj/machinery/floor_inflatables/attack_hand(mob/user, list/params)
	. = ..()
	var/confirm = input(user, "Do you want to trigger [src]'s deployment?","Trigger Floormount") as null|anything in list("Yes","No")
	if(confirm && confirm == "Yes")
		trigger()
