/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	integrity = 160
	integrity_max = 160
	integrity_failure = 100
	var/occupied = 1

/obj/structure/displaycase/atom_break()
	. = ..()
	playsound(src, "shatter", 70, 1)
	new /obj/item/material/shard(drop_location())
	update_icon()


/obj/structure/displaycase/update_icon()
	if(atom_flags & ATOM_BROKEN)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"


/obj/structure/displaycase/attack_hand(mob/user, list/params)
	if (src.destroyed && src.occupied)
		new /obj/item/gun/energy/captain( src.loc )
		to_chat(user, "<span class='notice'>You deactivate the hover field built into the case.</span>")
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	return ..()
