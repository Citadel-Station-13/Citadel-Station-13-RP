/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Creamatorium
 *		Creamatorium trays
 */

/*
 * Morgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in untill someone fetches them."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = 1
	var/obj/structure/m_tray/connected = null
	var/list/occupants = list()
	anchored = 1
	can_be_unanchored = 1

/obj/structure/morgue/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/morgue/proc/get_occupants()
	occupants.Cut()
	for(var/mob/living/carbon/human/H in contents)
		occupants += H
	for(var/obj/structure/closet/body_bag/B in contents)
		occupants += B.get_occupants()

/obj/structure/morgue/proc/update(var/broadcast=0)
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (src.contents.len)
			src.icon_state = "morgue2"
			get_occupants()
			for (var/mob/living/carbon/human/H in occupants)
				if(H.isSynthetic() || H.suiciding || !H.ckey || !H.client || (MUTATION_NOCLONE in H.mutations) || (H.species && H.species.species_flags & NO_SCAN))
					src.icon_state = "morgue2"
					break
				else
					src.icon_state = "morgue3"
					if(broadcast)
						GLOB.global_announcer.autosay("[src] was able to establish a mental interface with occupant.", "[src]", "Medical")
		else
			src.icon_state = "morgue1"
	return

/obj/structure/morgue/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				legacy_ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					legacy_ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					legacy_ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/morgue/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/morgue/attack_hand(mob/user as mob)
	if (src.connected)
		close()
	else
		open()
	src.add_fingerprint(user)
	update()
	return


/obj/structure/morgue/proc/close()
	for(var/atom/movable/A as mob|obj in src.connected.loc)
		if (!( A.anchored ))
			A.forceMove(src)
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	qdel(src.connected)
	src.connected = null


/obj/structure/morgue/proc/open()
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	src.connected = new /obj/structure/m_tray( src.loc )
	step(src.connected, src.dir)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, src.dir)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "morguet"
		src.connected.setDir(src.dir)
	else
		qdel(src.connected)
		src.connected = null


/obj/structure/morgue/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_held_item() != W)
			return
		if ((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = text("Morgue- '[]'", t)
		else
			src.name = "Morgue"
	if(istype(W, /obj/item/tool/wrench))
		if(anchored)
			user.show_message(text("<span class='notice'>[src] can now be moved.</span>"))
			playsound(src, W.tool_sound, 50, 1)
			anchored = FALSE
		else if(!anchored)
			user.show_message(text("<span class='notice'>[src] is now secured.</span>"))
			playsound(src, W.tool_sound, 50, 1)
			anchored = TRUE
	src.add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user as mob)
	if (user.stat)
		return
	if (user in src.occupants)
		open()

/*
 * Morgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morguet"
	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_OVERHEAD_THROW
	anchored = TRUE
	plane = TURF_PLANE
	var/obj/structure/morgue/connected = null

/obj/structure/m_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
			//Foreach goto(26)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/m_tray/MouseDroppedOnLegacy(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, "<span class='warning'>\The [user] stuffs [O] into [src]!</span>")
	return


/*
 * Crematorium
 */

GLOBAL_LIST_BOILERPLATE(all_crematoriums, /obj/structure/morgue/crematorium)

/obj/structure/morgue/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "crema1"
	var/cremating = 0
	var/id = 1
	var/locked = 0

/obj/structure/morgue/crematorium/update()
	if (src.connected)
		src.icon_state = "crema0"
	else
		if (src.contents.len)
			src.icon_state = "crema2"
		else
			src.icon_state = "crema1"
	return

/obj/structure/morgue/crematorium/attack_hand(mob/user as mob)
	if (cremating)
		to_chat(usr, "<span class='warning'>It's locked.</span>")
		return
	if ((src.connected) && (src.locked == 0))
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		//src.connected = null
		qdel(src.connected)
	else if (src.locked == 0)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/m_tray/c_tray( src.loc )
		step(src.connected, dir)
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, dir)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "cremat"
		else
			//src.connected = null
			qdel(src.connected)
	src.add_fingerprint(user)
	update()

/obj/structure/morgue/crematorium/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_held_item() != P)
			return
		if ((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = text("Crematorium- '[]'", t)
		else
			src.name = "Crematorium"
	src.add_fingerprint(user)
	return

/obj/structure/morgue/crematorium/relaymove(mob/user as mob)
	if (user.stat || locked)
		return
	src.connected = new /obj/structure/m_tray/c_tray( src.loc )
	step(src.connected, EAST)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "crema0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "cremat"
	else
		qdel(src.connected)
		src.connected = null
	return

/obj/structure/morgue/crematorium/proc/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in viewers(src))
			to_chat(M,"<span class='warning'>You hear a hollow crackle.</span>")
			return

	else
		if(!!length(src.search_contents_for(/obj/item/disk/nuclear)))
			to_chat(user,"You get the feeling that you shouldn't cremate one of the items in the cremator.")
			return

		for (var/mob/M in viewers(src))
			to_chat(M,"<span class='warning'>You hear a roar as the crematorium activates.</span>")

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if (C.can_feel_pain())
						C.emote("scream")

			M.death(1)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/effect/debris/cleanable/ash(src)
		sleep(30)
		cremating = 0
		locked = 0
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return


/*
 * Crematorium tray
 */
/obj/structure/m_tray/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "cremat"

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	req_access = list(access_crematorium)
	id = 1

/obj/machinery/button/crematorium/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.allowed(user))
		for (var/obj/structure/morgue/crematorium/C in GLOB.all_crematoriums)
			if (C.id == id)
				if (!C.cremating)
					C.cremate(user)
	else
		to_chat(user,"<span class='warning'>Access denied.</span>")


//! ## VR FILE MERGE ## !//
/obj/structure/morgue/crematorium/vr
	var/list/allowed_items = list(/obj/item/organ,
			/obj/item/implant,
			/obj/item/material/shard/shrapnel,
			/mob/living)


/obj/structure/morgue/crematorium/vr/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in viewers(src))
			M.show_message("<span class='warning'>You hear a hollow crackle.</span>", 1)
			return
	else
		if(!!length(src.search_contents_for(/obj/item/disk/nuclear)))
			to_chat(usr, "You get the feeling that you shouldn't cremate one of the items in the cremator.")
			return

		for(var/I in contents)
			if(!(I in allowed_items))
				to_chat(user, "<span class='notice'>\The [src] cannot cremate while there are items inside!</span>")
				return
			if(istype(I, /mob/living))
				var/mob/living/cremated = I
				for(var/Z in cremated.contents)
					if(!(Z in allowed_items))
						to_chat(user, "<span class='notice'>\The [src] cannot cremate while there are items inside!</span>")
						return

		for (var/mob/M in viewers(src))
			M.show_message("<span class='warning'>You hear a roar as the crematorium activates.</span>", 1)

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if (C.can_feel_pain())
						C.emote("scream")

			M.death(1)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/effect/debris/cleanable/ash(src)
		sleep(30)
		cremating = 0
		locked = 0
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return
