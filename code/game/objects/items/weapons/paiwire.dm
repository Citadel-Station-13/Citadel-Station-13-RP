/obj/item/pai_cable/proc/plugin(obj/machinery/M as obj, mob/user as mob)
	if(istype(M, /obj/machinery/door) || istype(M, /obj/machinery/camera))
		// Can't hack secured_wires doors (vault, etc)
		if(istype(M, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/A = M
			if(A.secured_wires)
				to_chat(user,"<span class='warning'>\The [M] doesn't have any acessible data ports for \the [src]!</span>")
				return
		user.visible_message("[user] inserts [src] into a data port on [M].", "You insert [src] into a data port on [M].", "You hear the satisfying click of a wire jack fastening into place.")
		playsound(user, 'sound/machines/click.ogg', 50, 1)
		user.transfer_item_to_loc(src, M, INV_OP_FORCE)
		machine = M
	else
		user.visible_message("[user] fumbles to find a place on [M] to plug in [src].", "There aren't any ports on [M] that match the jack belonging to [src].")

/obj/item/pai_cable/attack_object(atom/target, mob/user, clickchain_flags, list/params)
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	plugin(target, user)
