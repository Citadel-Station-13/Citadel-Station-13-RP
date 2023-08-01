/obj/structure/inflatable
	name = "inflatable wall"
	desc = "An inflated membrane. Do not puncture."
	density = 1
	anchored = 1
	opacity = 0
	CanAtmosPass = ATMOS_PASS_DENSITY

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"

	integrity = 30
	integrity_max = 30

	hit_sound_brute = 'sound/effects/Glasshit.ogg'

/obj/structure/inflatable/Initialize(mapload)
	. = ..()
	update_nearby_tiles()

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/inflatable/blob_act()
	puncture()

/obj/structure/inflatable/CtrlClick()
	hand_deflate()

/obj/structure/inflatable/proc/deflate()
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	//to_chat(user, "<span class='notice'>You slowly deflate the inflatable wall.</span>")
	visible_message("[src] slowly deflates.")
	spawn(50)
		var/obj/item/inflatable/R = new /obj/item/inflatable(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)

/obj/structure/inflatable/proc/puncture()
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	visible_message("[src] rapidly deflates!")
	var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
	src.transfer_fingerprints_to(R)
	qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return

	remove_obj_verb(src, /obj/structure/inflatable/verb/hand_deflate)
	deflate()

/obj/structure/inflatable/attack_generic(var/mob/user, var/damage, var/attack_verb)
	health -= damage
	user.do_attack_animation(src)
	if(health <= 0)
		user.visible_message("<span class='danger'>[user] [attack_verb] open the [src]!</span>")
		spawn(1) puncture()
	else
		user.visible_message("<span class='danger'>[user] [attack_verb] at [src]!</span>")
	return 1

/obj/structure/inflatable/take_damage_legacy(var/damage)
	health -= damage
	if(health <= 0)
		visible_message("<span class='danger'>The [src] deflates!</span>")
		spawn(1) puncture()
	return 1

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = 1
	anchored = 1
	opacity = 0

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "door_closed"

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0

/obj/structure/inflatable/door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user, list/params)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = 1
	flick("door_opening",src)
	sleep(10)
	set_density(FALSE)
	set_opacity(FALSE)
	state = 1
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/proc/Close()
	isSwitchingStates = 1
	flick("door_closing",src)
	sleep(10)
	set_density(TRUE)
	set_opacity(FALSE)
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate()
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	visible_message("[src] slowly deflates.")
	spawn(50)
		var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)

/obj/structure/inflatable/door/puncture()
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	visible_message("[src] rapidly deflates!")
	var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
	src.transfer_fingerprints_to(R)
	qdel(src)
