/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = 1
	opened = 0
	var/locked = 1
	var/broken = 0
	var/large = 1
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200

/obj/structure/closet/secure_closet/can_open()
	if(src.locked)
		return 0
	return ..()

/obj/structure/closet/secure_closet/close()
	if(..())
		if(broken)
			icon_state = src.icon_off
		return 1
	else
		return 0

/obj/structure/closet/secure_closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			src.locked = !src.locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/secure_closet/proc/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close the locker first."))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNING("The locker appears to be broken."))
		return
	if(user.loc == src)
		to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
		return
	if(src.allowed(user))
		src.locked = !src.locked
		playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				to_chat(O, SPAN_NOTICE("The locker has been [locked ? null : "un"]locked by [user]."))
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("Access Denied"))

/obj/structure/closet/secure_closet/attackby(obj/item/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/storage/laundry_basket))
			return ..(W,user)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if(src.large)
				src.MouseDroppedOn(G.affecting, user)	//act like they were dragged onto the closet
			else
				to_chat(user, SPAN_NOTICE("The locker is too small to stuff [G.affecting] into!"))
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		user.transfer_item_to_loc(W, loc)
	else if(istype(W, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, SPAN_DANGER("The locker has been sliced open by [user] with \an [W]"), SPAN_DANGER("You hear metal being sliced and sparks flying.")))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
	else if(W.is_wrench())
		if(sealed)
			if(anchored)
				user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
			else
				user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
			if(do_after(user, 20 * W.tool_speed))
				if(!src) return
				to_chat(user, SPAN_NOTICE("You [anchored? "un" : ""]secured \the [src]!"))
				anchored = !anchored
				return
	else if(istype(W,/obj/item/packageWrap) || istype(W,/obj/item/weldingtool))
		return ..(W,user)
	else
		togglelock(user)

/obj/structure/closet/secure_closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message(SPAN_WARNING("\The [src] has been broken by \the [user] with \an [emag_source]!"), "You hear a faint electrical spark.")
		else
			visible_message(SPAN_WARNING("\The [src] sparks and breaks open!"), "You hear a faint electrical spark.")
		return 1

/obj/structure/closet/secure_closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(src.locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/secure_closet/AltClick()
	..()
	verb_togglelock()

/obj/structure/closet/secure_closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr)) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr) || isrobot(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/secure_closet/update_icon()//Putting the sealed stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	cut_overlays()

	if(!opened)
		if(broken)
			icon_state = icon_off
		else if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(sealed)
			add_overlay("sealed")
	else
		icon_state = icon_opened

/obj/structure/closet/secure_closet/req_breakout()
	if(!opened && locked)
		return 1
	return ..() //It's a secure closet, but isn't locked.

/obj/structure/closet/secure_closet/break_open()
	desc += " It appears to be broken."
	broken = 1
	locked = 0
	..()
