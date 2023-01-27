//I still dont think this should be a closet but whatever
/obj/structure/closet/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/material/twohanded/fireaxe/fireaxe
	icon_state = "fireaxe1000"
	icon_closed = "fireaxe1000"
	icon_opened = "fireaxe1100"
	anchored = 1
	density = 0
	var/localopened = 0 //Setting this to keep it from behaviouring like a normal closet and obstructing movement in the map. -Agouri
	opened = 1
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0

/obj/structure/closet/fireaxecabinet/PopulateContents()
	. = ..()
	fireaxe = new /obj/item/material/twohanded/fireaxe(src)

/obj/structure/closet/fireaxecabinet/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	//..() //That's very useful, Erro

	// This could stand to be put further in, made better, etc. but fuck you. Fuck whoever
	// wrote this code. Fuck everything about this object. I hope you step on a Lego.
	user.setClickCooldown(10)
	// Seriously why the fuck is this even a closet aghasjdhasd I hate you

	var/hasaxe = 0       //gonna come in handy later~ // FUCK YOUR TILDES.
	if(fireaxe)
		hasaxe = 1

	if (isrobot(usr) || src.locked)
		if(istype(O, /obj/item/multitool))
			to_chat(user, SPAN_WARNING("Resetting circuitry..."))
			playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
			if(do_after(user, 20 * O.tool_speed))
				src.locked = 0
				to_chat(user, SPAN_CAUTION("You disable the locking modules."))
				update_icon()
			return
		else if(istype(O, /obj/item))
			var/obj/item/W = O
			if(src.smashed || src.localopened)
				if(localopened)
					localopened = 0
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				return
			else
				playsound(user, 'sound/effects/Glasshit.ogg', 100, 1) //We don't want this playing every time
			if(W.force < 15)
				to_chat(user, SPAN_NOTICE("The cabinet's protective glass glances off the hit."))
			else
				src.hitstaken++
				if(src.hitstaken == 4)
					playsound(user, 'sound/effects/Glassbr3.ogg', 100, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
					src.smashed = 1
					src.locked = 0
					src.localopened = 1
			update_icon()
		return
	if (istype(O, /obj/item/material/twohanded/fireaxe) && src.localopened)
		if(!fireaxe)
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			fireaxe = O
			if(fireaxe.wielded)
				fireaxe.wielded = FALSE
				fireaxe.update_icon()
			to_chat(user, SPAN_NOTICE("You place the fire axe back in the [src.name]."))
			update_icon()
		else
			if(src.smashed)
				return
			else
				localopened = !localopened
				if(localopened)
					icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				else
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
	else
		if(src.smashed)
			return
		if(istype(O, /obj/item/multitool))
			if(localopened)
				localopened = 0
				icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()
				return
			else
				to_chat(user, SPAN_WARNING("Resetting circuitry..."))
				playsound(user, 'sound/machines/lockenable.ogg', 50, 1)
				if(do_after(user,20 * O.tool_speed))
					src.locked = 1
					to_chat(user, SPAN_CAUTION("You re-enable the locking modules."))
				return
		else
			localopened = !localopened
			if(localopened)
				icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()
			else
				icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()


/obj/structure/closet/fireaxecabinet/attack_hand(mob/user as mob)
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1

	if(src.locked)
		to_chat(user, SPAN_WARNING("The cabinet won't budge!"))
		return

	if(localopened)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat (user, SPAN_NOTICE("You take the fire axe from the [name]."))
			src.add_fingerprint(user)
			update_icon()
		else
			if(src.smashed)
				return
			else
				localopened = !localopened
				if(localopened)
					src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				else
					src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()

	else
		localopened = !localopened //I'm pretty sure we don't need an if(src.smashed) in here. In case I'm wrong and it fucks up teh cabinet, **MARKER**. -Agouri
		if(localopened)
			src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
			spawn(10) update_icon()
		else
			src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
			spawn(10) update_icon()

/obj/structure/closet/fireaxecabinet/attack_tk(mob/user as mob)
	if(localopened && fireaxe)
		fireaxe.forceMove(loc)
		to_chat(user, SPAN_NOTICE("You telekinetically remove the fire axe."))
		fireaxe = null
		update_icon()
		return
	attack_hand(user)

/obj/structure/closet/fireaxecabinet/verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
	set name = "Open/Close"
	set category = "Object"
	set src in oview(1)

	if (isrobot(usr) || src.locked || src.smashed)
		if(src.locked)
			to_chat(usr, SPAN_WARNING("The cabinet won't budge!"))
		else if(src.smashed)
			to_chat(usr, SPAN_NOTICE("The protective glass is broken!"))
		return

	localopened = !localopened
	update_icon()

/obj/structure/closet/fireaxecabinet/verb/remove_fire_axe()
	set name = "Remove Fire Axe"
	set category = "Object"
	set src in oview(1)

	if (isrobot(usr))
		return

	if (localopened)
		if(fireaxe)
			usr.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(usr, SPAN_NOTICE("You take the Fire axe from the [name]."))
		else
			to_chat(usr, SPAN_NOTICE("The [src.name] is empty."))
	else
		to_chat(usr, SPAN_NOTICE("The [src.name] is closed."))
	update_icon()

/obj/structure/closet/fireaxecabinet/attack_ai(mob/user as mob)
	if(src.smashed)
		to_chat(user, SPAN_WARNING("The security of the cabinet is compromised."))
		return
	else
		locked = !locked
		if(locked)
			to_chat(user, SPAN_WARNING("Cabinet locked."))
		else
			to_chat(user, SPAN_NOTICE("Cabinet unlocked."))
		return

/obj/structure/closet/fireaxecabinet/update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1
	icon_state = text("fireaxe[][][][]",hasaxe,src.localopened,src.hitstaken,src.smashed)

/obj/structure/closet/fireaxecabinet/open()
	return

/obj/structure/closet/fireaxecabinet/close()
	return
