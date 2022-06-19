/obj/machinery/implantchair
	name = "loyalty implanter"
	desc = "Used to implant occupants with loyalty implants."
	icon = 'icons/obj/machines/implantchair.dmi'
	icon_state = "implantchair"
	density = TRUE
	opacity = 0
	anchored = TRUE

	var/ready = TRUE
	var/malfunction = 0
	var/list/obj/item/implant/loyalty/implant_list = list()
	var/max_implants = 5
	var/injection_cooldown = 600
	var/replenish_cooldown = 6000
	var/replenishing = FALSE
	var/mob/living/carbon/occupant = null
	var/injecting = FALSE



/obj/machinery/implantchair/Initialize(mapload)
	. = ..()
	add_implants()


/obj/machinery/implantchair/attack_hand(mob/user)
	user.set_machine(src)
	var/health_text = ""
	if(occupant)
		if(occupant.health <= -100)
			health_text = SPAN_DANGER("Dead")
		else if(occupant.health < 0)
			health_text = SPAN_DANGER("[round(occupant.health,0.1)]")
		else
			health_text = "[round(occupant.health,0.1)]"

	var/dat ="<B>Implanter Status</B><BR>"

	dat +="<B>Current occupant:</B> [occupant ? "<BR>Name: [occupant]<BR>Health: [health_text]<BR>" : "<FONT color=red>None</FONT>"]<BR>"
	dat += "<B>Implants:</B> [implant_list.len ? "[implant_list.len]" : "<A href='?src=\ref[src];replenish=1'>Replenish</A>"]<BR>"
	if(occupant)
		dat += "[ready ? "<A href='?src=\ref[src];implant=1'>Implant</A>" : "Recharging"]<BR>"
	user.set_machine(src)
	user << browse(dat, "window=implant")
	onclose(user, "implant")


/obj/machinery/implantchair/Topic(href, href_list)
	if((get_dist(src, usr) <= 1) || istype(usr, /mob/living/silicon/ai))
		if(href_list["implant"])
			if(occupant)
				injecting = TRUE
				go_out()
				ready = FALSE
				spawn(injection_cooldown)
					ready = TRUE

		if(href_list["replenish"])
			ready = FALSE
			spawn(replenish_cooldown)
				add_implants()
				ready = TRUE

		updateUsrDialog()
		add_fingerprint(usr)
		return


/obj/machinery/implantchair/attackby(obj/item/G, mob/user)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(!ismob(grab.affecting))
			return
		if(grab.affecting.has_buckled_mobs())
			to_chat(user, SPAN_WARNING( "\The [grab.affecting] has other entities attached to them. Remove them first."))
			return
		var/mob/M = grab.affecting
		if(put_mob(M))
			qdel(G)
	updateUsrDialog()
	return


/obj/machinery/implantchair/proc/go_out(mob/M)
	if(!(occupant))
		return
	if(M == occupant) // so that the guy inside can't eject himself -Agouri
		return
	occupant.forceMove(loc)
	occupant.update_perspective()
	if(injecting)
		implant(occupant)
		injecting = FALSE
	src.occupant = null
	icon_state = "implantchair"
	return


/obj/machinery/implantchair/proc/put_mob(mob/living/carbon/M)
	if(!iscarbon(M))
		to_chat(usr, SPAN_WARNING("\The [src] cannot hold this!"))
		return
	if(occupant)
		to_chat(usr, SPAN_WARNING("\The [src] is already occupied!"))
		return
	M.forceMove(src)
	M.update_perspective()
	occupant = M
	src.add_fingerprint(usr)
	icon_state = "implantchair_on"
	return TRUE


/obj/machinery/implantchair/proc/implant(mob/M)
	if (!istype(M, /mob/living/carbon))
		return
	if(!implant_list.len)
		return
	for(var/obj/item/implant/loyalty/imp in implant_list)
		if(!imp)
			continue
		if(istype(imp, /obj/item/implant/loyalty))
			for (var/mob/O in viewers(M, null))
				O.show_message(SPAN_WARNING("\The [M] has been implanted by \the [src]."), 1)

			if(imp.handle_implant(M, BP_TORSO))
				imp.post_implant(M)

			implant_list -= imp
			break
	return


/obj/machinery/implantchair/proc/add_implants()
	for(var/i = 0, i<max_implants, i++)
		var/obj/item/implant/loyalty/I = new /obj/item/implant/loyalty(src)
		implant_list += I
	return


/obj/machinery/implantchair/verb/get_out()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != CONSCIOUS)
		return
	go_out(usr)
	add_fingerprint(usr)
	return


/obj/machinery/implantchair/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != CONSCIOUS || machine_stat & (NOPOWER|BROKEN))
		return
	put_mob(usr)
	return
