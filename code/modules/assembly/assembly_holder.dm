/obj/item/assembly_holder
	name = "Assembly"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "holder"
	item_state = "assembly"
	throw_force = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 10

	var/secured = 0
	var/obj/item/assembly/a_left = null
	var/obj/item/assembly/a_right = null
	var/obj/special_assembly = null

/obj/item/assembly_holder/proc/attach(var/obj/item/assembly/D, var/obj/item/assembly/D2, var/mob/user)
	if(!D || !D2)
		return FALSE

	if(!istype(D) || !istype(D2))
		return FALSE

	if(D.secured || D2.secured)
		return FALSE


	if(user)
		user.temporarily_remove_from_inventory(D, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
		user.temporarily_remove_from_inventory(D2, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)

	D.holder = src
	D2.holder = src
	D.forceMove(src)
	D2.forceMove(src)
	a_left = D
	a_right = D2
	name = "[D.name]-[D2.name] assembly"
	update_icon()
	user.put_in_hands_or_drop(src)

	return TRUE

/obj/item/assembly_holder/proc/detached()
	return

/obj/item/assembly_holder/update_icon()
	cut_overlays()
	. = ..()
	if(a_left)
		add_overlay("[a_left.icon_state]_left")
		for(var/O in a_left.attached_overlays)
			add_overlay("[O]_l")
	if(a_right)
		add_overlay("[a_right.icon_state]_right")
		for(var/O in a_right.attached_overlays)
			add_overlay("[O]_r")
	if(master)
		master.update_icon()

/obj/item/assembly_holder/examine(mob/user, dist)
	. = ..()
	if ((in_range(src, user) || src.loc == user))
		if (src.secured)
			. += "\The [src] is ready!"
		else
			. += "\The [src] can be attached!"

/obj/item/assembly_holder/Crossed(atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal())
		return
	if(a_left)
		a_left.Crossed(AM)
	if(a_right)
		a_right.Crossed(AM)

/obj/item/assembly_holder/on_containing_storage_opening(datum/event_args/actor/actor, datum/object_system/storage/storage)
	. = ..()
	. |= a_left?.on_containing_storage_opening(arglist(args))
	. |= a_right?.on_containing_storage_opening(arglist(args))

/obj/item/assembly_holder/Move()
	..()
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()


/obj/item/assembly_holder/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()
	..()

/obj/item/assembly_holder/attackby(var/obj/item/W, var/mob/user)
	if(W.is_screwdriver())
		if(!a_left || !a_right)
			to_chat(user, "<span class='warning'> BUG:Assembly part missing, please report this!</span>")
			return
		a_left.toggle_secure()
		a_right.toggle_secure()
		secured = !secured
		if(secured)
			to_chat(user, "<span class='notice'>\The [src] is ready!</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] can now be taken apart!</span>")
		update_icon()
		return
	else
		..()

/obj/item/assembly_holder/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	src.add_fingerprint(user)
	if(src.secured)
		if(!a_left || !a_right)
			to_chat(user, "<span class='warning'> BUG:Assembly part missing, please report this!</span>")
			return
		// WARNING: DO NOT REMOVE IGNITER TYPECHECKS
		// If you do, grenades will INSTANTLY BLOW UP ON THE USER WHEN USED
		// IN HAND!!
		if(istype(a_left,a_right.type) && !istype(a_left, /obj/item/assembly/igniter))//If they are the same type it causes issues due to window code
			switch(alert("Which side would you like to use?",,"Left","Right"))
				if("Left")	a_left.attack_self(user)
				if("Right")	a_right.attack_self(user)
			return
		else
			if(!istype(a_left,/obj/item/assembly/igniter))
				a_left.attack_self(user)
			if(!istype(a_right,/obj/item/assembly/igniter))
				a_right.attack_self(user)
	else
		var/turf/T = get_turf(src)
		if(!T)
			return FALSE
		if(a_left)
			a_left.holder = null
			a_left.forceMove(T)
		if(a_right)
			a_right.holder = null
			a_right.forceMove(T)
		qdel(src)


/obj/item/assembly_holder/proc/process_activation(var/obj/D, var/normal = 1)
	if(!D)
		return FALSE
	if(!secured)
		visible_message("[icon2html(thing = src, target = world)] *beep* *beep*", "*beep* *beep*")
	if((normal) && (a_right) && (a_left))
		if(a_right != D)
			a_right.pulsed(0)
		if(a_left != D)
			a_left.pulsed(0)
	if(master)
		master.receive_signal()
	return TRUE

/obj/item/assembly_holder/hear_talk(mob/living/M as mob, msg, verb, datum/prototype/language/speaking)
	if(a_right)
		a_right.hear_talk(M,msg,verb,speaking)
	if(a_left)
		a_left.hear_talk(M,msg,verb,speaking)

/obj/item/assembly_holder/timer_igniter
	name = "timer-igniter assembly"

/obj/item/assembly_holder/timer_igniter/New()
	..()

	var/obj/item/assembly/igniter/ign = new(src)
	ign.secured = 1
	ign.holder = src

	var/obj/item/assembly/timer/tmr = new(src)
	tmr.time = 5
	tmr.secured = 1
	tmr.holder = src

	a_left = tmr
	a_right = ign
	secured = 1
	update_icon()
	name = initial(name) + " ([tmr.time] secs)"
