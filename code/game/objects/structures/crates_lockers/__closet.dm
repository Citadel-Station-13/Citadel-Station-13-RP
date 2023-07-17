/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closets/bases/closet.dmi'
	icon_state = "base"
	density = 1
	w_class = ITEMSIZE_HUGE
	layer = UNDER_JUNK_LAYER

	integrity = 200
	integrity_max = 200

	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/opened = 0
	var/sealed = 0
	var/seal_tool = /obj/item/weldingtool	//Tool used to seal the closet, defaults to welder
	var/wall_mounted = 0 //never solid (You can always pass over it)

	var/breakout = 0 //if someone is currently breaking out. mutex
	var/breakout_time = 2 //2 minutes by default
	breakout_sound = 'sound/effects/grillehit.ogg'	//Sound that plays while breaking out

	var/storage_capacity = 2 * MOB_MEDIUM //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/storage_cost = 40	//How much space this closet takes up if it's stuffed in another closet

	var/open_sound = 'sound/machines/click.ogg'
	var/close_sound = 'sound/machines/click.ogg'

	var/store_misc = 1		//Chameleon item check
	var/store_items = 1		//Will the closet store items?
	var/store_mobs = 1		//Will the closet store mobs?
	var/max_closets = 0		//Number of other closets allowed on tile before it won't close.

	var/list/starts_with
	var/singleton/closet_appearance = /singleton/closet_appearance
	var/broken = FALSE
	var/secure = FALSE
	var/locked = FALSE
	var/use_old_icon_update = FALSE


	var/obj/item/electronics/airlock/lockerelectronics //Installed electronics
	var/lock_in_use = FALSE //Someone is doing some stuff with the lock here, better not proceed further
//	var/secure = FALSE //secure locker or not


/obj/structure/closet/Initialize(mapload)
	. = ..()
	if(mapload && !opened)
		addtimer(CALLBACK(src, .proc/take_contents), 0)
	PopulateContents()
	/*
	if(secure)
		lockerelectronics = new(src)
		lockerelectronics.accesses = req_access
	*/
	// Closets need to come later because of spawners potentially creating objects during init.
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/LateInitialize()
	. = ..()
	if(starts_with)
		create_objects_in_loc(src, starts_with)
		starts_with = null
	if(ispath(closet_appearance))
		var/singleton/closet_appearance/app = GET_SINGLETON(closet_appearance)
		if(app)
			icon = app.icon
			color = null
			update_icon()

/obj/structure/closet/proc/update_icon_old()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/proc/take_contents()
	// if(istype(loc, /mob/living))
	//	return // No collecting mob organs if spawned inside mob
	// I'll leave this out, if someone dies to this from voring someone who made a closet go yell at a coder to
	// fix the fact you can build closets inside living people, not try to make it work you numbskulls.
	var/obj/item/I
	for(I in loc)
		if(I.density || I.anchored || I == src) continue
		I.forceMove(src)
	// adjust locker size to hold all items with 5 units of free store room
	var/content_size = 0
	for(I in contents)
		content_size += CEILING(I.w_class/2, 1)
	if(content_size > storage_capacity-5)
		storage_capacity = content_size + 5

/**
 * The proc that fills the closet with its initial contents.
 */
/obj/structure/closet/proc/PopulateContents()
	return

/obj/structure/closet/examine(mob/user, dist)
	. = ..()
	if(!opened)
		var/content_size = 0
		for(var/obj/item/I in contents)
			if(!I.anchored)
				content_size += CEILING(I.w_class/2, 1)
		if(!content_size)
			. += "It is empty."
		else if(storage_capacity > content_size*4)
			. += "It is barely filled."
		else if(storage_capacity > content_size*2)
			. += "It is less than half full."
		else if(storage_capacity > content_size)
			. += "There is still some free space."
		else
			. += "It is full."

/obj/structure/closet/CanAllowThrough(atom/movable/mover, turf/target)
	if(wall_mounted)
		return TRUE
	return ..()

/obj/structure/closet/proc/can_open()
	if(sealed)
		return FALSE
	if(locked)
		return FALSE
	return TRUE

/obj/structure/closet/proc/can_close()
	var/closet_count = 0
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			if(!closet.anchored)
				closet_count ++
	if(closet_count > max_closets)
		return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.forceMove(loc)

	for(var/obj/I in src)
		I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		M.update_perspective()

/obj/structure/closet/proc/open()
	if(opened)
		return 0

	if(!can_open())
		return 0

	dump_contents()

	icon_state = icon_opened
	opened = 1
	playsound(src, open_sound, 15, 1, -3)
	if(initial(density))
		density = !density
	return 1

/obj/structure/closet/proc/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	var/stored_units = 0

	if(store_misc)
		stored_units += store_misc(stored_units)
	if(store_items)
		stored_units += store_items(stored_units)
	if(store_mobs)
		stored_units += store_mobs(stored_units)
	if(max_closets)
		stored_units += store_closets(stored_units)

	icon_state = icon_closed
	opened = 0

	playsound(src, close_sound, 15, 1, -3)
	if(initial(density))
		density = !density
	return 1

//Cham Projector Exception
/obj/structure/closet/proc/store_misc(var/stored_units)
	var/added_units = 0
	for(var/obj/effect/dummy/chameleon/AD in loc)
		if((stored_units + added_units) > storage_capacity)
			break
		AD.forceMove(src)
		added_units++
	return added_units

/obj/structure/closet/proc/store_items(var/stored_units)
	var/added_units = 0
	for(var/obj/item/I in loc)
		var/item_size = CEILING(I.w_class / 2, 1)
		if(stored_units + added_units + item_size > storage_capacity)
			continue
		if(!I.anchored)
			I.forceMove(src)
			added_units += item_size
	return added_units

/obj/structure/closet/proc/store_mobs(var/stored_units)
	var/added_units = 0
	for(var/mob/living/M in loc)
		if(M.buckled || M.pinned.len)
			continue
		if(stored_units + added_units + M.mob_size > storage_capacity)
			break
		M.forceMove(src)
		M.update_perspective()
		added_units += M.mob_size
	return added_units

/obj/structure/closet/proc/store_closets(var/stored_units)
	var/added_units = 0
	for(var/obj/structure/closet/C in loc)
		if(C == src)	//Don't store ourself
			continue
		if(C.anchored)	//Don't worry about anchored things on the same tile
			continue
		if(C.max_closets)	//Prevents recursive storage
			continue
		if(stored_units + added_units + storage_cost > storage_capacity)
			break
		C.forceMove(src)
		added_units += storage_cost
	return added_units


/obj/structure/closet/proc/toggle(mob/user as mob)
	if(!(opened ? close() : open()))
		to_chat(user, "<span class='notice'>It won't budge!</span>")
		return
	update_icon()

// this should probably use dump_contents()
/obj/structure/closet/legacy_ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as mob|obj in src)//pulls everything out of the locker and hits it with an explosion
				A.forceMove(loc)
				LEGACY_EX_ACT(A, severity + 1, null)
			qdel(src)
		if(2)
			if(prob(50))
				for (var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					LEGACY_EX_ACT(A, severity + 1, null)
				qdel(src)
		if(3)
			if(prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
				qdel(src)

/obj/structure/closet/blob_act()
	damage(100)

/obj/structure/closet/proc/damage(var/damage)
	health -= damage
	if(health <= 0)
		for(var/atom/movable/A in src)
			A.forceMove(loc)
		qdel(src)

/obj/structure/closet/bullet_act(var/obj/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	..()
	damage(proj_damage)

	return

/obj/structure/closet/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			MouseDroppedOn(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(!WT.remove_fuel(0,user))
				if(!WT.isOn())
					return
				else
					to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
					return
			playsound(src, WT.tool_sound, 50)
			new /obj/item/stack/material/steel(loc)
			for(var/mob/M in viewers(src))
				M.show_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WT].</span>", 3, "You hear welding.", 2)
			qdel(src)
			return
		if(istype(W, /obj/item/storage/laundry_basket) && W.contents.len)
			var/obj/item/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message("<span class='notice'>[user] empties \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You empty \the [LB] into \the [src].</span>", \
								 "<span class='notice'>You hear rustling of clothes.</span>")
			return
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		if(!user.attempt_insert_item_for_installation(W, opened? loc : src))
			return
	else if(istype(W, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, loc)
			spark_system.start()
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)

	else if(W.is_wrench())
		if(sealed)
			if(anchored)
				user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
			else
				user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
			if(do_after(user, 20 * W.tool_speed))
				if(!src) return
				to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
				anchored = !anchored
				return

	else if(istype(W, /obj/item/packageWrap))
		return
	else if(istype(W, /obj/item/extraction_pack)) //so fulton extracts dont open closets
		close()
		return
	else if(seal_tool)
		if(istype(W, seal_tool))
			var/obj/item/S = W
			if(istype(S, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = S
				if(!WT.remove_fuel(0,user))
					if(!WT.isOn())
						return
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
			if(do_after(user, 20 * S.tool_speed))
				if(opened)
					return
				playsound(src, S.tool_sound, 50)
				sealed = !sealed
				update_icon()
				for(var/mob/M in viewers(src))
					M.show_message("<span class='warning'>[src] has been [sealed?"sealed":"unsealed"] by [user.name].</span>", 3)
	else if(W.is_wrench())
		if(sealed)
			if(anchored)
				user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
			else
				user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
			playsound(src, W.tool_sound, 50)
			if(do_after(user, 20 * W.tool_speed))
				if(!src) return
				to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
				anchored = !anchored
	else if (!secure)
		attack_hand(user)
	else
		togglelock(user)
	return

/obj/structure/closet/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	broken = TRUE
	update_icon()

/obj/structure/closet/MouseDroppedOnLegacy(atom/movable/O as mob|obj, mob/user as mob)
	if(istype(O, /atom/movable/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O) || user.contents.Find(src)))
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	step_towards(O, loc)
	if(user != O)
		user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
	add_fingerprint(user)
	return

/obj/structure/closet/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return

	if(!open())
		to_chat(user, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/attack_hand(mob/user, list/params)
	add_fingerprint(user)
	if(locked && secure)
		togglelock(user)
	else
		toggle(user)

/obj/structure/closet/AltClick()
	..()
	if(secure)
		verb_togglelock()

/obj/structure/closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE)) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if((ishuman(usr) || isrobot(usr)) && secure)
		src.add_fingerprint(usr)
		src.togglelock(usr)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	add_fingerprint(user)
	if(!toggle())
		to_chat(usr, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/attack_ghost(mob/ghost)
	. = ..()
	if(ghost.client && ghost.client.inquisitive_ghost)
		ghost.examinate(src)
		if (!opened)
			to_chat(ghost, "It contains: [english_list(contents)].")

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return

	if(ishuman(usr) || isrobot(usr))
		add_fingerprint(usr)
		toggle(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/update_icon()//Putting the sealed stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	if(use_old_icon_update)
		update_icon_old()
		return
	if(opened)
		icon_state = "open"
	else if(broken)
		icon_state = "closed_emagged[sealed ? "_welded" : ""]"
	else if(locked)
		icon_state = "closed_locked[sealed ? "_welded" : ""]"
	else
		icon_state = "closed_unlocked[sealed ? "_welded" : ""]"

/obj/structure/closet/attack_generic(var/mob/user, var/damage, var/attack_message = "destroys")
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	dump_contents()
	spawn(1) qdel(src)
	return 1

/obj/structure/closet/proc/req_breakout()
	if(opened)
		return FALSE //Door's open... wait, why are you in it's contents then?
	if(!sealed)
		return FALSE //closed but not sealed...
	if(secure && locked && !opened)
		return TRUE
	return TRUE

/obj/structure/closet/contents_resist(mob/escapee)
	if(breakout)
		return
	if(!req_breakout() && !opened)
		open()
		return

	escapee.setClickCooldown(100)

	//okay, so the closet is either sealed or locked... resist!!!
	to_chat(escapee, "<span class='warning'>You lean on the back of \the [src] and start pushing the door open. (this will take about [breakout_time] minutes)</span>")

	visible_message("<span class='danger'>\The [src] begins to shake violently!</span>")

	spawn(0)
		breakout = 1 //can't think of a better way to do this right now.
		for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
			if(!do_after(escapee, 50)) //5 seconds
				breakout = 0
				return
			if(!escapee || escapee.incapacitated() || escapee.loc != src)
				breakout = 0
				return //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
			//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
			if(!req_breakout())
				breakout = 0
				return

			playsound(src, breakout_sound, 100, 1)
			animate_shake()
			add_fingerprint(escapee)

		//Well then break it!
		breakout = 0
		to_chat(escapee, SPAN_WARNING("You successfully break out!"))
		visible_message(SPAN_DANGER("\The [escapee] successfully broke out of \the [src]!"))
		playsound(src, breakout_sound, 100, 1)
		animate_shake()
		break_open()

/obj/structure/closet/proc/break_open()
	sealed = 0
	update_icon()
	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	if(secure)
		desc += " It appears to be broken."
		broken = 1
		locked = 0
	open()

/obj/structure/closet/proc/animate_shake()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), 8*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

/obj/structure/closet/onDropInto(var/atom/movable/AM)
	return

/obj/structure/closet/AllowDrop()
	return !opened

/obj/structure/closet/return_air_for_internal_lifeform(var/mob/living/L)
	if(loc)
		if(istype(loc, /obj/structure/closet))
			return (loc.return_air_for_internal_lifeform(L))
	return return_air()

/obj/structure/closet/take_damage_legacy(var/damage)
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return
	dump_contents()
	spawn(1) qdel(src)
	return 1

/obj/structure/closet/CanReachOut(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return FALSE

/obj/structure/closet/CanReachIn(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return FALSE

/obj/structure/closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && secure)
		if(prob(50/severity))
			locked = !locked
			update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				req_access = list()
				req_access = list(pick(get_all_station_access()))
	..()

/obj/structure/closet/proc/togglelock(mob/user as mob)
	if(!secure)
		return
	if(opened)
		to_chat(user, "<span class='notice'>Close the locker first.</span>")
		return
	if(broken)
		to_chat(user, "<span class='warning'>The locker appears to be broken.</span>")
		return
	if(user.loc == src)
		to_chat(user, "<span class='notice'>You can't reach the lock from inside.</span>")
		return
	if(allowed(user))
		locked = !locked
		playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				to_chat(O, "<span class='notice'>The locker has been [locked ? null : "un"]locked by [user].</span>")
		update_icon()
	else
		to_chat(user, "<span class='notice'>Access Denied</span>")

/obj/structure/closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken && secure)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		update_icon()

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message("<span class='warning'>\The [src] has been broken by \the [user] with \an [emag_source]!</span>", "You hear a faint electrical spark.")
		else
			visible_message("<span class='warning'>\The [src] sparks and breaks open!</span>", "You hear a faint electrical spark.")
		return 1
