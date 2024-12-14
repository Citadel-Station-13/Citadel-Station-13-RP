// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables
// Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
///kPa - assume the inside of a dispoal pipe is 1 atm, so that needs to be added.
#define SEND_PRESSURE (700 + ONE_ATMOSPHERE)
///L
#define PRESSURE_TANK_VOLUME 150
///L/s - 4 m/s using a 15 cm by 15 cm inlet
#define PUMP_MAX_FLOW_RATE 90
// todo: /obj/machinery/disposal/chute
/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE
	pass_flags_self = ATOM_PASS_OVERHEAD_THROW
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = FALSE	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = FALSE	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0
	active_power_usage = 2200	//the pneumatic pump power. 3 HP ~ 2200W
	idle_power_usage = 100

// create a new disposal
// find the attached trunk (if present) and init gas resvr.
/obj/machinery/disposal/Initialize(mapload, newdir)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/disposal/LateInitialize()
	trunk = locate() in src.loc
	if(!trunk)
		mode = 0
		flush = FALSE
	else
		trunk.linked = src	// link the pipe trunk to self

	air_contents = new/datum/gas_mixture(PRESSURE_TANK_VOLUME)
	update()

/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked = null
	return ..()

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(var/obj/item/I, var/mob/user)
	if(user.a_intent != INTENT_HELP)
		return ..()

	. = CLICKCHAIN_DO_NOT_PROPAGATE

	if(machine_stat & BROKEN || !I || !user)
		return

	add_fingerprint(user, 0, I)
	if(mode<=0) // It's off
		if(I.is_screwdriver())
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			if(mode==0) // It's off but still not unscrewed
				mode=-1 // Set it to doubleoff l0l
				playsound(src, I.tool_sound, 50, 1)
				to_chat(user, "You remove the screws around the power connection.")
				return
			else if(mode==-1)
				mode=0
				playsound(src, I.tool_sound, 50, 1)
				to_chat(user, "You attach the screws around the power connection.")
				return
		else if(istype(I, /obj/item/weldingtool) && mode==-1)
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			var/obj/item/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src, W.tool_sound, 100, 1)
				to_chat(user, "You start slicing the floorweld off the disposal unit.")

				if(do_after(user,20 * W.tool_speed))
					if(!src || !W.isOn()) return
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/C = new (src.loc)
					src.transfer_fingerprints_to(C)
					C.ptype = 6 // 6 = disposal unit
					C.anchored = 1
					C.density = 1
					C.update()
					qdel(src)
				return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return

	if(istype(I, /obj/item/storage/bag/trash))
		var/obj/item/storage/bag/trash/T = I
		to_chat(user, "<font color=#4F49AF>You empty the bag.</font>")
		for(var/obj/item/O in T.contents)
			T.obj_storage.remove(O, src)
		T.update_icon()
		update()
		return

	if(istype(I, /obj/item/material/ashtray))
		var/obj/item/material/ashtray/A = I
		if(A.contents.len > 0)
			user.visible_message("<span class='notice'>\The [user] empties \the [A.name] into [src].</span>")
			for(var/obj/item/O in A.contents)
				O.forceMove(src)
			A.update_icon()
			update()
			return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			for (var/mob/V in viewers(usr))
				V.show_message("[usr] starts putting [GM.name] into the disposal.", 3)
			if(do_after(usr, 20))
				GM.forceMove(src)
				GM.update_perspective()
				for (var/mob/C in viewers(src))
					C.show_message("<font color='red'>[GM.name] has been placed in \the [src] by [user].</font>", 3)
				qdel(G)

				add_attack_logs(user,GM,"Disposals dunked")
		return

	if(!user.attempt_insert_item_for_installation(I, src))
		return

	to_chat(user, "You place \the [I] into \the [src].")
	for(var/mob/M in viewers(src))
		if(M == user)
			continue
		M.show_message("[user.name] places \the [I] into \the [src].", 3)

	update()

// mouse drop another mob or self
//
/obj/machinery/disposal/MouseDroppedOnLegacy(mob/target, mob/user)
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE) || !istype(target))
		return
	if(target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1)
		return

	//animals cannot put mobs other than themselves into disposal
	if(isanimal(user) && target != user)
		return

	src.add_fingerprint(user)
	var/target_loc = target.loc
	var/msg
	for (var/mob/V in viewers(usr))
		if(target == user && !user.stat && CHECK_ALL_MOBILITY(user, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))
			V.show_message("[usr] starts climbing into the disposal.", 3)
		if(target != user && !user.restrained() && !user.stat && CHECK_ALL_MOBILITY(user, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))
			if(target.anchored) return
			V.show_message("[usr] starts stuffing [target.name] into the disposal.", 3)
	if(!do_after(usr, 20))
		return
	if(target_loc != target.loc)
		return
	if(target == user && !user.stat && CHECK_ALL_MOBILITY(user, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))	// if drop self, then climbed in
											// must be awake, not stunned or whatever
		msg = "[user.name] climbs into \the [src]."
		to_chat(user, "You climb into \the [src].")
	else if(target != user && !user.restrained() && !user.stat && CHECK_ALL_MOBILITY(user, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))
		msg = "[user.name] stuffs [target.name] into \the [src]!"
		to_chat(user, "You stuff [target.name] into \the [src]!")

		add_attack_logs(user,target,"Disposals dunked")
	else
		return
	target.forceMove(src)
	target.update_perspective()

	for (var/mob/C in viewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user as mob)
	if(user.stat || src.flushing)
		return
	if(user.loc == src)
		src.go_out(user)
	return

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)
	user.forceMove(loc)
	user.update_perspective()
	update()
	return

// ai as human but can't flush
/obj/machinery/disposal/attack_ai(mob/user as mob)
	interact(user, 1)

// human interact with machine
/obj/machinery/disposal/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)

	if(machine_stat & BROKEN)
		return

	if(user && user.loc == src)
		to_chat(user, "<font color='red'>You cannot reach the controls from inside.</font>")
		return

	// Clumsy folks can only flush it.
	if(user.IsAdvancedToolUser(1))
		interact(user, 0)
	else
		flush = !flush
		update()
	return

// user interaction
/obj/machinery/disposal/interact(mob/user, var/ai=0)

	src.add_fingerprint(user)
	if(machine_stat & BROKEN)
		user.unset_machine()
		return

	var/dat = "<head><title>Waste Disposal Unit</title></head><body><TT><B>Waste Disposal Unit</B><HR>"

	if(!ai)  // AI can't pull flush handle
		if(flush)
			dat += "Disposal handle: <A href='?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
		else
			dat += "Disposal handle: <B>Disengaged</B> <A href='?src=\ref[src];handle=1'>Engage</A>"

		dat += "<BR><HR><A href='?src=\ref[src];eject=1'>Eject contents</A><HR>"

	if(mode <= 0)
		dat += "Pump: <B>Off</B> <A href='?src=\ref[src];pump=1'>On</A><BR>"
	else if(mode == 1)
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
	else
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

	var/per = 100* air_contents.return_pressure() / (SEND_PRESSURE)

	dat += "Pressure: [round(per, 1)]%<BR></body>"


	user.set_machine(src)
	user << browse(dat, "window=disposal;size=360x170")
	onclose(user, "disposal")

// handle machine interaction

/obj/machinery/disposal/Topic(href, href_list)
	if(usr.loc == src)
		to_chat(usr, "<font color='red'>You cannot reach the controls from inside.</font>")
		return

	if(mode==-1 && !href_list["eject"]) // only allow ejecting if mode is -1
		to_chat(usr, "<font color='red'>The disposal units power is disabled.</font>")
		return
	if(..())
		return

	if(machine_stat & BROKEN)
		return
	if(usr.stat || usr.restrained() || src.flushing)
		return

	if(istype(src.loc, /turf))
		usr.set_machine(src)

		if(href_list["close"])
			usr.unset_machine()
			usr << browse(null, "window=disposal")
			return

		if(href_list["pump"])
			if(text2num(href_list["pump"]))
				mode = 1
			else
				mode = 0
			update()

		if(!isAI(usr))
			if(href_list["handle"])
				flush = text2num(href_list["handle"])
				update()

			if(href_list["eject"])
				eject()
	else
		usr << browse(null, "window=disposal")
		usr.unset_machine()
		return
	return

// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(src.loc)
		AM.pipe_eject(0)
	update()

// update the icon & overlays to reflect mode & status
/obj/machinery/disposal/proc/update()
	cut_overlays()
	if(machine_stat & BROKEN)
		icon_state = "disposal-broken"
		mode = 0
		flush = 0
		return

	var/list/overlays_to_add = list()

	// flush handle
	if(flush)
		overlays_to_add += image('icons/obj/pipes/disposal.dmi', "dispover-handle")

	// only handle is shown if no power
	if(machine_stat & NOPOWER || mode == -1)
		add_overlay(overlays_to_add)
		return

	// 	check for items in disposal - occupied light
	if(contents.len > 0)
		overlays_to_add += image('icons/obj/pipes/disposal.dmi', "dispover-full")

	// charging and ready light
	if(mode == 1)
		overlays_to_add += image('icons/obj/pipes/disposal.dmi', "dispover-charge")
	else if(mode == 2)
		overlays_to_add += image('icons/obj/pipes/disposal.dmi', "dispover-ready")

	add_overlay(overlays_to_add)

// timed process
// charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/process(delta_time)
	if(!air_contents || (machine_stat & BROKEN))			// nothing can happen if broken
		update_use_power(USE_POWER_OFF)
		return

	flush_count++
	if( flush_count >= flush_every_ticks )
		if( contents.len )
			if(mode == 2)
				spawn(0)
					feedback_inc("disposal_auto_flush",1)
					flush()
		flush_count = 0

	src.updateDialog()

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE )	// flush can happen even without power
		flush()

	if(mode != 1) //if off or ready, no need to charge
		update_use_power(USE_POWER_IDLE)
	else if(air_contents.return_pressure() >= SEND_PRESSURE)
		mode = 2 //if full enough, switch to ready mode
		update()
	else
		src.pressurize() //otherwise charge

/obj/machinery/disposal/proc/pressurize()
	if(machine_stat & NOPOWER)			// won't charge if no power
		update_use_power(USE_POWER_OFF)
		return

	var/atom/L = loc						// recharging from loc turf
	var/datum/gas_mixture/env = L.return_air()

	var/power_draw = -1
	if(env && env.temperature > 0)
		var/transfer_moles = (PUMP_MAX_FLOW_RATE/env.volume)*env.total_moles	//group_multiplier is divided out here
		power_draw = pump_gas(src, env, air_contents, transfer_moles, active_power_usage)

	if (power_draw > 0)
		use_power(power_draw)

// perform a flush
/obj/machinery/disposal/proc/flush()

	flushing = 1
	flick("[icon_state]-flush", src)

	var/wrapcheck = 0
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	//Hacky test to get drones to mail themselves through disposals.
	for(var/mob/living/silicon/robot/drone/D in src)
		wrapcheck = 1

	for(var/obj/item/smallDelivery/O in src)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1


	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	sleep(5) // wait for animation to finish


	H.init(src, air_contents)	// copy the contents of disposer to holder
	air_contents = new(PRESSURE_TANK_VOLUME)	// new empty gas resv.

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return


// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat NOPOWER bit
	update()	// update icon
	return


/// Called when holder is expelled from a disposal.
/// Should usually only occur if the pipe network is modified.
/obj/machinery/disposal/proc/expel(obj/structure/disposalholder/H)

	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	if(H) // Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.forceMove(src.loc)
			AM.pipe_eject(0)
			if(!istype(AM,/mob/living/silicon/robot/drone)) //Poor drones kept smashing windows and taking system damage being fired out of disposals. ~Z
				spawn(1)
					if(AM)
						AM.throw_at_old(target, 5, 1)

		H.vent_gas(loc)
		qdel(H)

/obj/machinery/disposal/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	if(istype(AM, /obj/item) && !istype(AM, /obj/projectile))
		if(prob(75))
			AM.forceMove(src)
			visible_message("\The [AM] lands in \the [src].")
			return COMPONENT_THROW_HIT_TERMINATE
		else
			visible_message("\The [AM] bounces off of \the [src]'s rim!")
			return ..()
	return ..()

/obj/machinery/disposal/CanAllowThrough(atom/movable/mover, turf/target)
	if(istype(mover, /obj/projectile))
		return TRUE
	return ..()

/obj/machinery/disposal/wall
	name = "inset disposal unit"
	icon_state = "wall"

	density = FALSE

/obj/machinery/disposal/wall/Initialize()
	. = ..()

	spawn(1 SECOND)	// Fixfix for weird interaction with buildmode or other late-spawning.
		update()

/obj/machinery/disposal/wall/update()
	..()

	switch(dir)
		if(1)
			pixel_x = 0
			pixel_y = -32
		if(2)
			pixel_x = 0
			pixel_y = 32
		if(4)
			pixel_x = -32
			pixel_y = 0
		if(8)
			pixel_x = 32
			pixel_y = 0
