/obj/machinery/door/window
	name = "interior door"
	desc = "A strong door."
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "left"
	pass_flags_self = ATOM_PASS_GLASS
	armor_type = /datum/armor/door/windoor
	var/base_state = "left"
	hit_sound_brute = 'sound/effects/Glasshit.ogg'
	integrity = 140
	integrity_max = 140
	visible = 0.0
	use_power = USE_POWER_OFF
	atom_flags = ATOM_BORDER
	opacity = 0
	var/obj/item/airlock_electronics/electronics = null
	explosion_resistance = 5
	air_properties_vary_with_direction = 1

/obj/machinery/door/window/Initialize(mapload)
	. = ..()
	update_nearby_tiles()
	if (src.req_access && src.req_access.len)
		src.icon_state = "[src.icon_state]"
		src.base_state = src.icon_state

/obj/machinery/door/window/update_icon()
	if(density)
		icon_state = base_state
	else
		icon_state = "[base_state]open"

/obj/machinery/door/window/proc/shatter(var/display_message = 1)
	new /obj/item/material/shard(src.loc)
	new /obj/item/material/shard(src.loc)
	new /obj/item/stack/cable_coil(src.loc, 1)
	var/obj/item/airlock_electronics/ae
	if(!electronics)
		ae = new/obj/item/airlock_electronics( src.loc )

		if(!src.req_access)    //This apparently has side effects that might
			src.check_access() //update null r_a's? Leaving it just in case.
		ae.conf_req_access = req_access?.Copy()
		ae.conf_req_one_access = req_one_access?.Copy()
	else
		ae = electronics
		electronics = null
		ae.loc = src.loc
	if(operating == -1)
		ae.icon_state = "door_electronics_smoked"
		operating = 0
	src.density = 0
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	qdel(src)

/obj/machinery/door/window/Destroy()
	density = 0
	update_nearby_tiles()
	return ..()

/obj/machinery/door/window/Bumped(atom/movable/AM as mob|obj)
	if (!( ismob(AM) ))
		var/mob/living/bot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.botcard))
				open()
				addtimer(CALLBACK(src, PROC_REF(close)), 50)
		else if(istype(AM, /obj/mecha))
			var/obj/mecha/mecha = AM
			if(density)
				if(mecha.occupant && src.allowed(mecha.occupant))
					open()
					addtimer(CALLBACK(src, PROC_REF(close)), 50)
		return
	if (!( SSticker ))
		return
	if (src.operating)
		return
	if (density && allowed(AM))
		open()
		addtimer(CALLBACK(src, PROC_REF(close)), check_access(null)? 50 : 20)

/obj/machinery/door/window/CanAllowThrough(atom/movable/mover, turf/target)
	if(!(get_dir(mover, loc) & turn(dir, 180)))
		return TRUE
	return ..()

/obj/machinery/door/window/CanAtmosPass(turf/T, d)
	if(d != dir)
		return ATMOS_PASS_NOT_BLOCKED
	return density? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_ZONE_BLOCKED

/obj/machinery/door/window/can_pathfinding_enter(atom/movable/actor, dir, datum/pathfinding/search)
	return (src.dir != dir) || ..() || (has_access(req_access, req_one_access, search.ss13_with_access) && !inoperable())

/obj/machinery/door/window/can_pathfinding_exit(atom/movable/actor, dir, datum/pathfinding/search)
	return (src.dir != dir)  || ..() || (has_access(req_access, req_one_access, search.ss13_with_access) && !inoperable())

/obj/machinery/door/window/can_pathfinding_pass(atom/movable/actor, datum/pathfinding/search)
	return ..() || (has_access(req_access, req_one_access, search.ss13_with_access) && !inoperable())

/obj/machinery/door/window/CheckExit(atom/movable/AM, atom/newLoc)
	if(!(get_dir(src, newLoc) & dir))
		return TRUE
	if(check_standard_flag_pass(AM))
		return TRUE
	return !density

/obj/machinery/door/window/open()
	if (operating == 1 || !density) //doors can still open when emag-disabled
		return 0
	if (!operating) //in case of emag
		operating = 1
	flick("[base_state]opening", src)
	playsound(loc, 'sound/machines/windowdoor.ogg', 100, 1)
	sleep(10)

	explosion_resistance = 0
	density = 0
	update_icon()
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	return 1

/obj/machinery/door/window/close()
	if(operating || density)
		return FALSE
	operating = TRUE
	flick("[base_state]closing", src)
	playsound(loc, 'sound/machines/windowdoor.ogg', 100, 1)

	density = TRUE
	update_icon()
	explosion_resistance = initial(explosion_resistance)
	update_nearby_tiles()

	sleep(10)
	operating = FALSE
	return TRUE

/obj/machinery/door/window/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/window/attack_hand(mob/user, list/params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	src.add_fingerprint(user)

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick("[base_state]deny", src)

	return

/obj/machinery/door/window/emag_act(var/remaining_charges, var/mob/user)
	if (density && operable())
		operating = -1
		flick("[src.base_state]spark", src)
		sleep(6)
		open()
		return 1

/obj/machinery/door/window/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()

	//If it's in the process of opening/closing, ignore the click
	if (src.operating == 1)
		return

	if(istype(I))
		// Fixing.
		if(istype(I, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
			var/obj/item/weldingtool/WT = I
			if(integrity < integrity_max)
				if(WT.remove_fuel(1 ,user))
					to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
					playsound(src, WT.tool_sound, 50, 1)
					if(do_after(user, 40 * WT.tool_speed, target = src))
						set_integrity(integrity_max)
						update_icon()
						to_chat(user, "<span class='notice'>You repair [src].</span>")
			else
				to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
			return

		//Emags and ninja swords? You may pass.
		if (istype(I, /obj/item/melee/energy/blade))
			if(emag_act(10, user))
				var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
				spark_system.set_up(5, 0, src.loc)
				spark_system.start()
				playsound(src.loc, /datum/soundbyte/grouped/sparks, 50, 1)
				playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
				visible_message("<span class='warning'>The glass door was sliced open by [user]!</span>")
			return 1

		//If it's opened/emagged, crowbar can pry it out of its frame.
		if (!density && I.is_crowbar())
			playsound(src, I.tool_sound, 50, 1)
			user.visible_message("[user] begins prying the windoor out of the frame.", "You start to pry the windoor out of the frame.")
			if (do_after(user,40 * I.tool_speed))
				to_chat(user,"<span class='notice'>You pried the windoor out of the frame!</span>")

				var/obj/structure/windoor_assembly/wa = new/obj/structure/windoor_assembly(src.loc)
				if (istype(src, /obj/machinery/door/window/brigdoor))
					wa.secure = "secure_"
				if (src.base_state == "right" || src.base_state == "rightsecure")
					wa.facing = "r"
				wa.setDir(src.dir)
				wa.anchored = 1
				wa.created_name = name
				wa.state = "02"
				wa.step = 2
				wa.update_state()

				if(operating == -1)
					wa.electronics = new/obj/item/circuitboard/broken()
				else
					if(!electronics)
						wa.electronics = new/obj/item/airlock_electronics()
						if(!src.req_access)
							src.check_access()
						wa.electronics.conf_req_access = req_access?.Copy()
						wa.electronics.conf_req_one_access = req_one_access?.Copy()
					else
						wa.electronics = electronics
						electronics = null
				operating = 0
				qdel(src)
				return

	src.add_fingerprint(user, 0, I)

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick("[base_state]deny", src)

	return

/obj/machinery/door/window/brigdoor
	name = "secure door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	armor_type = /datum/armor/door/windoor/reinforced
	integrity = 280
	integrity_max = 280
	var/id = null

/obj/machinery/door/window/brigdoor/shatter()
	new /obj/item/stack/rods(src.loc, 2)
	..()

/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "rightsecure"
	base_state = "rightsecure"
