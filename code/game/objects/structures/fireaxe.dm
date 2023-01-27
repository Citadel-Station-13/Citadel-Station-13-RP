//I still dont think this should be a closet but whatever
/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/material/twohanded/fireaxe/fireaxe
	icon = 'icons/obj/closet.dmi'	//Not bothering to move icons out for now. But its dumb still.
	icon_state = "fireaxe1000"
	anchored = 1
	density = 0
	var/open = 0
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0
	var/hasaxe = 1

/obj/structure/fireaxecabinet/Initialize(mapload)
	. = ..()
	fireaxe = new /obj/item/material/twohanded/fireaxe()

/obj/structure/fireaxecabinet/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	//..() //That's very useful, Erro

	// This could stand to be put further in, made better, etc. but fuck you. Fuck whoever
	// wrote this code. Fuck everything about this object. I hope you step on a Lego.
	user.setClickCooldown(10)
	// Seriously why the fuck is this even a closet aghasjdhasd I hate you

	//var/hasaxe = 0       //gonna come in handy later~ // FUCK YOUR TILDES.
	//if(fireaxe)
	//	hasaxe = 1

	if (isrobot(user) || locked)
		if(istype(O, /obj/item/multitool))
			to_chat(user, SPAN_WARNING("Resetting circuitry..."))
			playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
			if(do_after(user, 20 * O.tool_speed))
				locked = 0
				to_chat(user, SPAN_CAUTION("You disable the locking modules."))
				update_icon()
			return
		else if(istype(O, /obj/item))
			var/obj/item/W = O
			if(smashed || open)
				if(open)
					toggle_close_open()
				return
			else
				playsound(user, 'sound/effects/Glasshit.ogg', 100, 1) //We don't want this playing every time
			if(W.force < 15)
				to_chat(user, SPAN_NOTICE("The cabinet's protective glass glances off the hit."))
			else
				hitstaken++
				if(hitstaken == 4)
					playsound(user, 'sound/effects/Glassbr3.ogg', 100, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
					smashed = 1
					locked = 0
					open= 1
			update_icon()
		return
	if (istype(O, /obj/item/material/twohanded/fireaxe) && open)
		if(!fireaxe)
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			fireaxe = O
			if(fireaxe.wielded)
				fireaxe.wielded = FALSE
				fireaxe.update_icon()
			to_chat(user, SPAN_NOTICE("You place the fire axe back in the [name]."))
			update_icon()
		else
			if(smashed)
				return
			else
				toggle_close_open()
	else
		if(smashed)
			return
		if(istype(O, /obj/item/multitool))
			if(open)
				open = 0
				update_icon()
				flick("[icon_state]closing", src)
				return
			else
				to_chat(user, SPAN_WARNING("Resetting circuitry..."))
				playsound(user, 'sound/machines/lockenable.ogg', 50, 1)
				if(do_after(user,20 * O.tool_speed))
					locked = 1
					to_chat(user, SPAN_CAUTION("You re-enable the locking modules."))
				return
		else
			toggle_close_open()


/obj/structure/fireaxecabinet/attack_hand(mob/user as mob)
	//var/hasaxe = 0	//Fuck this. Fuck everything about this. Who wrote this. Why.
	//if(fireaxe)
	//	hasaxe = 1

	if(locked)
		to_chat(user, SPAN_WARNING("The cabinet won't budge!"))
		return

	if(open)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat (user, SPAN_NOTICE("You take the fire axe from the [name]."))
			add_fingerprint(user)
			update_icon()
		else
			if(smashed)
				return
			else
				toggle_close_open()

	else
		toggle_close_open()

/obj/structure/fireaxecabinet/attack_tk(mob/user as mob)
	if(open && fireaxe)
		fireaxe.forceMove(loc)
		to_chat(user, SPAN_NOTICE("You telekinetically remove the fire axe."))
		fireaxe = null
		update_icon()
		return
	attack_hand(user)

/obj/structure/fireaxecabinet/proc/toggle_close_open()
	open = !open
	if(open)
		update_icon()
		flick("[icon_state]opening", src)
	else
		update_icon()
		flick("[icon_state]closing", src)

/obj/structure/fireaxecabinet/verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
	set name = "Open/Close"
	set category = "Object"

	if (isrobot(usr) || locked || smashed)
		if(locked)
			to_chat(usr, SPAN_WARNING("The cabinet won't budge!"))
		else if(smashed)
			to_chat(usr, SPAN_NOTICE("The protective glass is broken!"))
		return

	toggle_close_open()
	update_icon()

/obj/structure/fireaxecabinet/verb/remove_fire_axe()
	set name = "Remove Fire Axe"
	set category = "Object"

	if (isrobot(usr))
		return

	if (open)
		if(fireaxe)
			usr.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(usr, SPAN_NOTICE("You take the Fire axe from the [name]."))
		else
			to_chat(usr, SPAN_NOTICE("The [name] is empty."))
	else
		to_chat(usr, SPAN_NOTICE("The [name] is closed."))
	update_icon()

/obj/structure/fireaxecabinet/attack_ai(mob/user as mob)
	if(smashed)
		to_chat(user, SPAN_WARNING("The security of the cabinet is compromised."))
		return
	else
		locked = !locked
		if(locked)
			to_chat(user, SPAN_WARNING("Cabinet locked."))
		else
			to_chat(user, SPAN_NOTICE("Cabinet unlocked."))
		return

/obj/structure/fireaxecabinet/update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
	hasaxe = 0
	if(fireaxe)
		hasaxe = 1
	icon_state = text("fireaxe[][][][]",hasaxe,open,hitstaken,smashed)
