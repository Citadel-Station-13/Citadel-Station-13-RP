GLOBAL_LIST_BOILERPLATE(apcs, /obj/machinery/apc)

/**
 * APCs
 *
 * Power scale: Watts
 * Power is up-converted to kilowatts for grid.
 *
 * dev notes for the next time i'm insane enough to refactor power for no reason:
 * - more wires, more remote controls
 * - wiremod?
 * - brownout support (probably far in the future or impossible due to performance)
 *
 * todo: get rid of usage of machine flag 'MAINT' ? unify 'BROKEN' flag with atom flags? maybe? machines have really weird flags.
 * todo: get rid of wiresexposed and move to panel_open
 *
 * ~silicons
 */
#warn repath to /obj/machinery/apc on maps from /obj/machinery/power/apc.
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc, 22)
/obj/machinery/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	icon = 'icons/machinery/apc.dmi'
	icon_state = "apc0"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	use_power = USE_POWER_OFF
	active_power_usage = 0
	idle_power_usage = 0
	armor_type = /datum/armor/object/medium
	req_access = list(ACCESS_ENGINEERING_APC)

	//* Appearance *//
	/// overlay caches generated
	var/static/overlay_cache_generated = FALSE
	/// cached images, because we have to change color so we can't use just text unless we hardcode the colors
	var/static/list/overlay_cache_equip
	/// cached images, because we have to change color so we can't use just text unless we hardcode the colors
	var/static/list/overlay_cache_light
	/// cached images, because we have to change color so we can't use just text unless we hardcode the colors
	var/static/list/overlay_cache_envir

	//* Area *//
	#warn hook registered_area
	/// the area we're registered to
	var/area/registered_area

	//* Nightshift *//
	/// nightshift setting
	var/nightshift_setting = APC_NIGHTSHIFT_AUTO
	/// last nightshift switch by user
	var/nightshift_last_user_switch

	//* Power - Alarm *//
	/// alarm threshold as ratio
	/// if no cell, this doesn't alarm as long as it has enough power.
	var/alarm_threshold = 0.3

	//* Power - Breaker *//
	/// breaker toggled
	var/breaker_toggled = TRUE
	/// last time
	/// are we *actually* operating?
	///
	/// * requires [breaker_toggled] to be TRUE
	/// * requires [load_auto_online] to be TRUE (updated by process loop)
	/// * reqiures [error_check_until] to be null or lower than world.time
	var/load_active = TRUE
	/// are we allowed to turn on [load_active]?
	/// this way the apc can automatically shut off when there's
	/// insufficient power instead of oscillating every tick
	var/load_auto_online = TRUE
	/// io regulators faulted until world.time
	///
	/// caused by things like:
	/// * grid checks
	/// * overloads
	var/error_check_until

	//* Power - Buffer *//
	/// internal capacitor capacity in joules
	///
	/// * DO NOT SET THIS BELOW 50,000. the buffer is massive for anti-oscillation purposes.
	var/buffer_capacity = 50000 // 50 kilowatts for a second, or half a kilowatt for a minute and a half
	/// internal capacitor joules; this is auto-set at init based on if we have a cell / power if null.
	var/buffer
	/// internal tuning variable
	///
	/// * do not mess with this unless you know what you are doing
	var/buffer_recharge_heuristic = 0.3

	//* Power - Cell *//
	/// our power cell
	var/obj/item/cell/cell
	/// starting power cell type
	var/cell_type = /obj/item/cell/apc
	/// starting power cell charge in %
	var/cell_start_percent = 100

	//* Power - Charging *//
	/// charging enabled
	var/charging_enabled = FALSE
	/// charge rate limit in kw
	var/charging_draw = 5

	//* Power - Channels *//
	/// power channels that are active
	var/channels_active = POWER_BITS_ALL
	/// power channels enabled
	var/channels_toggled = POWER_BITS_ALL
	/// power channels set to auto
	var/channels_auto = POWER_BITS_ALL
	/// power channels that should be offline if they're on auto; updated by processing loop
	var/channels_auto_online = POWER_BITS_ALL
	/// percentage (as 0.0 to 1.0) of cell remaining to turn a channel off at
	/// if no cell, it turns off immediately upon insufficient power from mains.
	///
	/// * the actual on/off thresholds are implementation-defined; this is just a suggestion.
	/// * this is because smoothing / anti-oscillation doesn't play nicely with thresholds
	/// * as a rule of thumb, restoration takes a full minute after it's off.
	var/list/channel_thresholds = APC_CHANNEL_THRESHOLDS_DEFAULT

	//* Power - Load Balancing *//
	/// power tier - for load balancing
	var/load_balancing_priority = POWER_BALANCING_TIER_MEDIUM
	/// power tier - changeable
	var/load_balancing_modify = TRUE

	//* Power - Processing *//
	/// currently charging
	var/last_charging = FALSE
	/// last total power used, static and burst
	var/last_total_load = 0
	/// difference between power that could be pulled from the grid, and the amount needed.
	var/last_total_deficit = 0
	/// last channel power used, static and burst
	var/list/last_channel_load = EMPTY_POWER_CHANNEL_LIST
	/// burst usage for channels since last process() in joules
	/// this is directly deducted and will not be drained again during process().
	var/list/current_burst_load = EMPTY_POWER_CHANNEL_LIST
	/// last time a channel had to be kicked offline
	var/last_channel_drop = 0
	/// last time we had to be kicked offline entirely
	var/last_full_drop = 0
	/// heuristic: next world.time we can attempt to re-online
	///
	/// * this is for both full drop and channel drops
	/// * this will actively suppress load_active!
	/// * this will actively suppress any attempts at re-enabling channels!
	var/next_online_pulse = 0


	//* Security *//
	/// cover locked
	var/cover_locked = TRUE
	/// interface locked
	var/interface_locked = TRUE

	#warn below

	//? Power Handling
	/// if power alarms from this apc are visible on consoles
	//! warning: legacy
	var/alarms_hidden = FALSE
	/// buffer-less: used to estimate how much power we'll need on average
	/// if powered off, most burst usages won't work, but, we'll still guesstimate static load.
	var/load_heuristic = 0
	/// buffer-any: randomized process() ticks before we try to reinstate power
	var/load_resume = 0

	#warn rest

	var/area/area
	var/areastring = null
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/grid_check = FALSE
	var/aidisabled = 0
	var/obj/machinery/power/terminal/terminal = null
	var/main_status = 0
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	var/wiresexposed = 0
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/datum/wires/apc/wires = null
	var/emergency_lights = FALSE
	var/is_critical = 0
	var/failure_timer = 0
	var/force_update = 0

	//Used for shuttles, workaround for broken mounting
	//TODO: Remove when legacy walls are nuked
	var/old_wall = FALSE

/obj/machinery/apc/Initialize(mapload, set_dir, constructing)
	if(!overlay_cache_generated)
		generate_overlay_caches()
	. = ..()

	wires = new(src)

	if(!isnull(set_dir))
		setDir(set_dir)
	else
		update_dir()

	if(!constructing)
		auto_build()
	else
		#warn ???
		area = get_area(src)
		area.apc = src
		opened = 1
		operating = 0
		name = "[area.name] APC"
		machine_stat |= MAINT
		src.update_icon()

/obj/machinery/apc/Destroy()

	#warn below

	src.update()
	area.apc = null
	area.set_power_channels(NONE)

	#warn above

	QDEL_NULL(wires)
	QDEL_NULL(terminal)
	QDEL_NULL(cell)

	//! legacy
	// Malf AI, removes the APC from AI's hacked APCs list.
	if((hacker) && (hacker.hacked_apcs) && (src in hacker.hacked_apcs))
		hacker.hacked_apcs -= src
	power_alarm.clearAlarm(loc, src)
	//! end

	return ..()

/obj/machinery/apc/get_cell()
	return cell

/obj/machinery/apc/drop_products(method, atom/where)
	. = ..()
	if(!isnull(cell))
		cell.forceMove(where)
		cell = null
	new /obj/item/stack/material/steel(where, method == ATOM_DECONSTRUCT_DISASSEMBLED? 2 : 1)

/obj/machinery/apc/drain_energy(datum/actor, amount, flags)
	var/amount_initial = amount

	if(terminal?.is_connected())
		amount -= terminal.drain_energy(arglist(args))

	// if there isn't enough, hit cell
	if(amount > 0 && cell)
		amount -= cell.drain_energy(arglist(args))

	// if there isn't enough, do we have buffer?
	if(buffer > 1000) // buffer is in joules
		var/kj_available = floor(buffer / 1000)
		var/kj_used = min(amount, kj_available)
		buffer -= kj_available * 1000
		amount -= kj_used

	return amount_initial - amount

// APCs are pixel-shifted, so they need to be updated.
/obj/machinery/apc/setDir(new_dir)
	. = ..()
	if(!.)
		return
	update_dir()

/obj/machinery/apc/proc/update_dir()
	if(old_wall)
		return

	base_pixel_x = 0
	base_pixel_y = 0
	var/turf/T = get_step(src, turn(dir, 180))
	if(T.get_wallmount_anchor())
		switch(dir)
			if(SOUTH)
				base_pixel_y = 22
			if(NORTH)
				base_pixel_y = -22
			if(EAST)
				base_pixel_x = -22
			if(WEST)
				base_pixel_x = 22
	reset_pixel_offsets()

	if(terminal)
		terminal.setDir(turn(src.dir, 180)) // Terminal has same dir as master

#warn below

#warn what
/obj/machinery/apc/proc/energy_fail(var/duration)
	failure_timer = max(failure_timer, round(duration))

/obj/machinery/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.setDir(turn(dir, 180))
	terminal.master = src

/obj/machinery/apc/proc/autobuild()
	has_electronics = 2 //installed and secured
	// is starting with a power cell installed, create it and set its charge level
	QDEL_NULL(cell)
	if(cell_type)
		cell = new cell_type(src)
		cell.charge = cell.maxcharge * (start_charge / 100)

	//! legacy code
	has_electronics = 2 //installed and secured
	var/area/A = get_area(src)
	A.apc = src
	//if area isn't specified use current
	if(isarea(A) && src.areastring == null)
		src.area = A
		name = "\improper [area.name] APC"
	else
		src.area = get_area_name(areastring)
		name = "\improper [area.name] APC"
	if(istype(area, /area/submap))
		alarms_hidden = TRUE
	//! legacy code end

	create_terminal()
	update_icon()

	addtimer(CALLBACK(src, PROC_REF(update)), 5)

/obj/machinery/apc/examine(mob/user, dist)
	. = ..()
	if(Adjacent(user))
		if(machine_stat & BROKEN)
			. += "This APC is broken."
			return
		if(opened)
			if(has_electronics && terminal)
				. += "The cover is [opened==2?"removed":"open"] and [ cell ? "a power cell is installed" : "the power cell is missing"]."
			else if (!has_electronics && terminal)
				. += "The frame is wired, but the electronics are missing."
			else if (has_electronics && !terminal)
				. += "The electronics are installed, but not wired."
			else
				. += "It's just an empty metal frame."

		else
			if (wiresexposed)
				. += "The cover is closed and the wires are exposed."
			else if ((locked && emagged) || hacker) //Some things can cause locked && emagged. Malf AI causes hacker.
				. += "The cover is closed, but the panel is unresponsive."
			else if(!locked && emagged) //Normal emag does this.
				. += "The cover is closed, but the panel is flashing an error."
			else
				. += "The cover is closed."

//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/apc/attackby(obj/item/W, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if (istype(user, /mob/living/silicon) && get_dist(src,user)>1)
		return src.attack_hand(user)
	src.add_fingerprint(user)
	if (W.is_crowbar() && opened)
		if (has_electronics==1)
			if (terminal)
				to_chat(user,"<span class='warning'>Disconnect the wires first.</span>")
				return
			playsound(src, W.tool_sound, 50, 1)
			to_chat(user,"You begin to remove the power control board...") //lpeters - fixed grammar issues //Ner - grrrrrr
			if(do_after(user, 50 * W.tool_speed))
				if (has_electronics==1)
					has_electronics = 0
					if ((machine_stat & BROKEN))
						user.visible_message(\
							"<span class='warning'>[user.name] has broken the charred power control board inside [src.name]!</span>",\
							"<span class='notice'>You broke the charred power control board and remove the remains.</span>",
							"You hear a crack!")
					else
						user.visible_message(\
							"<span class='warning'>[user.name] has removed the power control board from [src.name]!</span>",\
							"<span class='notice'>You remove the power control board.</span>")
						new /obj/item/module/power_control(loc)
		else if (opened!=2) //cover isn't removed
			opened = 0
			update_icon()
	else if (W.is_crowbar() && !(machine_stat & BROKEN) )
		if(coverlocked && !(machine_stat & MAINT))
			to_chat(user,"<span class='warning'>The cover is locked and cannot be opened.</span>")
			return
		else
			opened = 1
			update_icon()
	else if	(istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		if(cell)
			to_chat(user,"The [src.name] already has a power cell installed.")
			return
		if (machine_stat & MAINT)
			to_chat(user,"<span class='warning'>You need to install the wiring and electronics first.</span>")
			return
		if(W.w_class != WEIGHT_CLASS_NORMAL)
			to_chat(user,"\The [W] is too [W.w_class < 3? "small" : "large"] to work here.")
			return
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		cell = W
		user.visible_message(\
			"<span class='warning'>[user.name] has inserted a power cell into [src.name]!</span>",\
			"<span class='notice'>You insert the power cell.</span>")
		chargecount = 0
		update_icon()
	else if	(W.is_screwdriver())	// haxing
		if(opened)
			if (cell)
				to_chat(user,"<span class='warning'>Remove the power cell first.</span>")
				return
			else
				if (has_electronics==1 && terminal)
					has_electronics = 2
					machine_stat &= ~MAINT
					playsound(src.loc, W.tool_sound, 50, 1)
					to_chat(user,"You screw the circuit electronics into place.")
				else if (has_electronics==2)
					has_electronics = 1
					machine_stat |= MAINT
					playsound(src.loc, W.tool_sound, 50, 1)
					to_chat(user,"You unfasten the electronics.")
				else /* has_electronics==0 */
					to_chat(user,"<span class='warning'>There is nothing to secure.</span>")
					return
				update_icon()
		else
			wiresexposed = !wiresexposed
			to_chat(user,"The wires have been [wiresexposed ? "exposed" : "unexposed"].")
			playsound(src, W.tool_sound, 50, 1)
			update_icon()

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))			// trying to unlock the interface with an ID card
		if(emagged)
			to_chat(user,"The panel is unresponsive.")
		else if(opened)
			to_chat(user,"You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user,"You must close the wire panel.")
		else if(machine_stat & (BROKEN|MAINT))
			to_chat(user,"Nothing happens.")
		else if(hacker)
			to_chat(user,"<span class='warning'>Access denied.</span>")
		else
			if(src.allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
				locked = !locked
				to_chat(user,"You [ locked ? "lock" : "unlock"] the APC interface.")
				update_icon()
			else
				to_chat(user,"<span class='warning'>Access denied.</span>")
	else if (istype(W, /obj/item/stack/cable_coil) && !terminal && opened && has_electronics!=2)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user,"<span class='warning'>You must remove the floor plating in front of the APC first.</span>")
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 10)
			to_chat(user,"<span class='warning'>You need ten lengths of cable for that.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] adds cables to the APC frame.</span>", \
							"You start adding cables to the APC frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20))
			if (C.amount >= 10 && !terminal && opened && has_electronics != 2)
				var/obj/structure/cable/N = T.get_power_cable_node()
				if (prob(50) && electrocute_mob(usr, N, N))
					var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					if(!CHECK_MOBILITY(user, MOBILITY_CAN_MOVE))
						return
				C.use(10)
				user.visible_message(\
					"<span class='warning'>[user.name] has added cables to the APC frame!</span>",\
					"You add cables to the APC frame.")
				make_terminal()
				terminal.connect_to_network()
	else if (W.is_wirecutter() && terminal && opened && has_electronics!=2)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user,"<span class='warning'>You must remove the floor plating in front of the APC first.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] starts dismantling the [src]'s power terminal.</span>", \
							"You begin to cut the cables...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50 * W.tool_speed))
			if(terminal && opened && has_electronics!=2)
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					if(!CHECK_MOBILITY(user, MOBILITY_CAN_MOVE))
						return
				new /obj/item/stack/cable_coil(loc,10)
				to_chat(user,"<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
				qdel(terminal)
	else if (istype(W, /obj/item/module/power_control) && opened && has_electronics==0 && !((machine_stat & BROKEN)))
		user.visible_message("<span class='warning'>[user.name] inserts the power control board into [src].</span>", \
							"You start to insert the power control board into the frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10))
			if(has_electronics==0)
				has_electronics = 1
				reset()
				to_chat(user,"<span class='notice'>You place the power control board inside the frame.</span>")
				qdel(W)
	else if (istype(W, /obj/item/module/power_control) && opened && has_electronics==0 && ((machine_stat & BROKEN)))
		to_chat(user,"<span class='warning'>The [src] is too broken for that. Repair it first.</span>")
		return
	else if (istype(W, /obj/item/weldingtool) && opened && has_electronics==0 && !terminal)
		var/obj/item/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			to_chat(user,"<span class='warning'>You need more welding fuel to complete this task.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] begins cutting apart [src] with the [WT.name].</span>", \
							"You start welding the APC frame...", \
							"You hear welding.")
		playsound(src, WT.tool_sound, 25, 1)
		if(do_after(user, 50 * WT.tool_speed))
			if(!src || !WT.remove_fuel(3, user)) return
			if (emagged || (machine_stat & BROKEN) || opened==2)
				new /obj/item/stack/material/steel(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut apart by [user.name] with the [WT.name].</span>",\
					"<span class='notice'>You disassembled the broken APC frame.</span>",\
					"You hear welding.")
			else
				new /obj/item/frame2/apc(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut from the wall by [user.name] with the [WT.name].</span>",\
					"<span class='notice'>You cut the APC frame from the wall.</span>",\
					"You hear welding.")
			qdel(src)
			return
	else if (opened && ((machine_stat & BROKEN) || hacker || emagged))
		if (istype(W, /obj/item/frame2/apc) && (machine_stat & BROKEN))
			if(cell)
				to_chat(user, "<span class='warning'>You need to remove the power cell first.</span>")
				return
			user.visible_message("<span class='warning'>[user.name] begins replacing the damaged APC cover with a new one.</span>",\
								"You begin to replace the damaged APC cover...")
			if(do_after(user, 50))
				user.visible_message("<span class='notice'>[user.name] has replaced the damaged APC cover with a new one.</span>",\
					"You replace the damaged APC cover with a new one.")
				qdel(W)
				machine_stat &= ~BROKEN
				reset()
				if (opened==2)
					opened = 1
				update_icon()
		else if (istype(W, /obj/item/multitool) && (hacker || emagged))
			if(cell)
				to_chat(user, "<span class='warning'>You need to remove the power cell first.</span>")
				return
			user.visible_message("<span class='warning'>[user.name] connects their [W.name] to the APC and begins resetting it.</span>",\
								"You begin resetting the APC...")
			if(do_after(user, 50))
				user.visible_message("<span class='notice'>[user.name] resets the APC with a beep from their [W.name].</span>",\
									"You finish resetting the APC.")
				playsound(src.loc, 'sound/machines/chime.ogg', 25, 1)
				reset()
	else
		if ((machine_stat & BROKEN) \
				&& !opened \
				&& W.damage_force >= 5 \
				&& W.w_class >= WEIGHT_CLASS_SMALL )
			user.visible_message("<span class='danger'>The [src.name] has been hit with the [W.name] by [user.name]!</span>", \
				"<span class='danger'>You hit the [src.name] with your [W.name]!</span>", \
				"You hear a bang!")
			if(prob(20))
				opened = 2
				user.visible_message("<span class='danger'>The APC cover was knocked down with the [W.name] by [user.name]!</span>", \
					"<span class='danger'>You knock down the APC cover with your [W.name]!</span>", \
					"You hear a bang!")
				update_icon()
		else
			if (istype(user, /mob/living/silicon))
				return src.attack_hand(user)
			if (!opened && wiresexposed && (istype(W, /obj/item/multitool) || W.is_wirecutter() || istype(W, /obj/item/assembly/signaler)))
				return src.attack_hand(user)

// attack with hand - remove cell (if cover open) or interact with the APC

//Altclick APCs to toggle the controlls
/obj/machinery/apc/AltClick(mob/user)
	if(user.Adjacent(src))
		if(src.allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
			locked = !locked
			to_chat(user,"You [ locked ? "lock" : "unlock"] the APC interface.")
			update_icon()
		else
			to_chat(user,"<span class='warning'>Access denied.</span>")

/obj/machinery/apc/emag_act(var/remaining_charges, var/mob/user)
	if (!(emagged || hacker))		// trying to unlock with an emag card
		if(opened)
			to_chat(user,"You must close the cover to do that.")
		else if(wiresexposed)
			to_chat(user,"You must close the wire panel first.")
		else if(machine_stat & (BROKEN|MAINT))
			to_chat(user,"The [src] isn't working.")
		else
			flick("apc-spark", src)
			if (do_after(user,6))
				emagged = 1
				locked = 0
				to_chat(user,"<span class='notice'>You emag the APC interface.</span>")
				update_icon()
				return 1

/obj/machinery/apc/blob_act()
	if(!wires.is_all_cut())
		wiresexposed = TRUE
		wires.cut_all()
		update_icon()

/obj/machinery/apc/attack_hand(mob/user, list/params)
//	if (!can_use(user)) This already gets called in interact() and in topic()
//		return
	if(!user)
		return
	src.add_fingerprint(user)

	//Human mob special interaction goes here.
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user

		if(H.species.can_shred(H))
			user.setClickCooldown(user.get_attack_speed())
			user.visible_message("<span call='warning'>[user.name] slashes at the [src.name]!</span>", "<span class='notice'>You slash at the [src.name]!</span>")
			playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

			var/allcut = wires.is_all_cut()

			if(beenhit >= pick(3, 4) && wiresexposed != 1)
				wiresexposed = 1
				src.update_icon()
				src.visible_message("<span call='warning'>The [src.name]'s cover flies open, exposing the wires!</span>")

			else if(wiresexposed == 1 && allcut == 0)
				wires.cut_all()
				src.update_icon()
				src.visible_message("<span call='warning'>The [src.name]'s wires are shredded!</span>")
			else
				beenhit += 1
			return

	if(usr == user && opened && (!issilicon(user)))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.update_icon()

			src.cell = null
			user.visible_message("<span class='warning'>[user.name] removes the power cell from [src.name]!</span>",\
								 "<span class='notice'>You remove the power cell.</span>")
			charging = 0
			src.update_icon()
		return
	if(machine_stat & (BROKEN|MAINT))
		return
	// do APC interaction
	src.interact(user)

/obj/machinery/apc/attack_ai(mob/user)
	add_hiddenprint(user)
	ui_interact(user)

/obj/machinery/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed && !istype(user, /mob/living/silicon/ai))
		wires.Interact(user)
		return	//The panel is visibly dark when the wires are exposed, so we shouldn't be able to interact with it.

	return ui_interact(user)

/obj/machinery/apc/proc/toggle_breaker()
	operating = !operating
	src.update()
	update_icon()

//Returns 1 if the APC should attempt to charge
/obj/machinery/apc/proc/attempt_charging()
	return (chargemode && charging == 1 && operating)


// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
/obj/machinery/apc/proc/autoset(cur_state, on)
	switch(cur_state)
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged

// damage and destruction acts
/obj/machinery/apc/emp_act(severity)
	// Fail for 8-12 minutes (divided by severity)
	// Division by 2 is required, because machinery ticks are every two seconds. Without it we would fail for 16-24 minutes.
	if(is_critical)
		// Critical APCs are considered EMP shielded and will be offline only for about half minute. Prevents AIs being one-shot disabled by EMP strike.
		// Critical APCs are also more resilient to cell corruption/power drain.
		energy_fail(rand(240, 360) / severity / CRITICAL_APC_EMP_PROTECTION)
		if(cell)
			cell.emp_act(severity+2)
	else
		// Regular APCs fail for normal time.
		energy_fail(rand(240, 360) / severity)
		//Cells are partially shielded by the APC frame.
		if(cell)
			cell.emp_act(severity+1)

	update_icon()
	..()

/obj/machinery/apc/legacy_ex_act(severity)

	switch(severity)
		if(1)
			//set_broken() //now qdel() do what we need
			if (cell)
				LEGACY_EX_ACT(cell, 1, null) // more lags woohoo
			qdel(src)
			return
		if(2)
			if (prob(75))
				set_broken()
				if (cell && prob(50))
					LEGACY_EX_ACT(cell, 2, null)
		if(3)
			if (prob(50))
				set_broken()
				if (cell && prob(50))
					LEGACY_EX_ACT(cell, 3, null)
		if(4)
			if (prob(25))
				set_broken()
				if (cell && prob(50))
					LEGACY_EX_ACT(cell, 3, null)
	return

/obj/machinery/apc/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/apc/proc/set_broken()
	// Aesthetically much better!
	spawn(rand(2,5))
		src.visible_message("<span class='warning'>[src]'s screen flickers suddenly, then explodes in a rain of sparks and small debris!</span>")
		machine_stat |= BROKEN
		operating = 0
		update_icon()
		update()

// overload the lights in this APC area

/obj/machinery/apc/proc/overload_lighting(var/chance = 100)
	if(/* !get_connection() || */ !operating || shorted || grid_check)
		return
	if( cell && cell.charge>=20)
		cell.use(20);
		spawn(0)
			for(var/obj/machinery/light/L in area)
				if(prob(chance))
					L.on = 1
					L.broken()
				sleep(1)

/obj/machinery/apc/proc/flicker_lights(var/chance = 100)
	for(var/obj/machinery/light/L in area)
		L.flicker(rand(15,25))

/obj/machinery/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		return (val==1) ? 0 : val
	else if(val == 3)
		return 1
	else
		return 0

// Malfunction: Transfers APC under AI's control
/obj/machinery/apc/proc/ai_hack(var/mob/living/silicon/ai/A = null)
	if(!A || !A.hacked_apcs || hacker || aidisabled || A.stat == DEAD)
		return 0
	src.hacker = A
	A.hacked_apcs += src
	locked = 1
	update_icon()
	return 1

/obj/machinery/apc/overload(var/obj/machinery/power/source)
	if(is_critical)
		return

	if(prob(30)) // Nothing happens.
		return

	if(prob(40)) // Lights blow.
		overload_lighting()

	if(prob(40)) // Spooky flickers.
		for(var/obj/machinery/light/L in area)
			L.flicker(rand(20,30))

	if(prob(25)) // Bluescreens.
		emagged = 1
		locked = 0
		update_icon()

	if(prob(25)) // Cell gets damaged.
		if(cell)
			cell.corrupt()

	if(prob(10)) // Computers get broken.
		for(var/obj/machinery/computer/comp in area)
			LEGACY_EX_ACT(comp, 3, null)

	if(prob(5)) // APC completely ruined.
		set_broken()

/obj/machinery/apc/do_grid_check()
	if(is_critical)
		return
	grid_check = TRUE
	spawn(15 MINUTES) // Protection against someone deconning the grid checker after a grid check happens, preventing infinte blackout.
		if(src && grid_check == TRUE)
			grid_check = FALSE

/obj/machinery/apc/proc/update_area()//From apc_vr.dm
	var/area/NA = get_area(src)
	if(!(NA == area))
		if(area.apc == src)
			area.apc = null
		NA.apc = src
		area = NA
		name = "[area.name] APC"
	update()

#warn above

/obj/machinery/apc/proc/reset(includes_physical = FALSE, reset_cell = FALSE)
	var/requires_update = FALSE

	//! legacy
	if(hacker)
		if(istype(hacker))
			if(islist(hacker.hacked_apcs))
				hacker.hacked_apcs -= src
		hacker = null
		requires_update = TRUE

	if(emagged)
		emagged = FALSE
		requires_update = TRUE

	power_alarm.clearAlarm(loc, src)
	//! end

	// bit cheaty, but reset power usage lists
	last_load = 0
	load_heuristic = 0
	last_channel_load = EMPTY_POWER_USAGE_LIST
	current_burst_load = EMPTY_POWER_USAGE_LIST

	channels_enabled = POWER_BITS_ALL
	channels_auto = POWER_BITS_ALL
	charging_enabled = TRUE
	charging = FALSE
	load_toggled = FALSE
	breaker_tripped = FALSE

	requires_update = full_update_channels() || requires_update

	if(includes_physical)
		#warn cover
	if(reset_cell)
		QDEL_NULL(cell)
		create_cell()
		create_buffer()

	if(requires_update)
		update_icon()
		registered_area?.power_change()

	#warn impl
	//reset various counters so that process() will start fresh
	chargecount = initial(chargecount)
	autoflag = initial(autoflag)
	longtermpower = initial(longtermpower)
	failure_timer = initial(failure_timer)


//* Alarms *//

/obj/machinery/apc/proc/full_update_alarm()
	if(isnull(cell))
		#warn so we want to alarm / clear alarm based on if there's enough power to fuel the machinery
	else
		if(cell.percent() > alarm_threshold * 100)
			power_alarm.clearAlarm(loc, src)
		else
			power_alarm.triggerAlarm(loc, src, hidden = alarms_hidden)

//* Appearance *//

/obj/machinery/apc/update_icon()
	. = ..()
	update_lighting()

/obj/machinery/apc/proc/update_lighting()
	if((machine_stat & (BROKEN|MAINT)) || opened || panel_open)
		set_light(0)
	else if(emagged || !isnull(hacker) || failure_timer)
		set_light(2, 0.5, "#00eccff")
	else
		var/color
		switch(charging)
			if(0)
				color = "#f86060"
			if(1)
				color = "#a8b0f8"
			if(2)
				color = "#82ff4c"
		set_light(2, 0.5, color)

/obj/machinery/apc/update_icon_state()
	#warn sigh
	if(opened)
		var/base_state = "apc[isnull(cell)? 2 : 1]"
		if(opened == 1)
			if(machine_stat & (BROKEN|MAINT))
				icon_state = "apcmaint"
			else
				icon_state = base_state
		else if(opened == 2)
			icon_state = "[base_state]-nocover"
	else if(machine_stat & BROKEN)
		icon_state = "apc-b"
	else if(wiresexposed)
		icon_state = "apcewires"
	else if(emagged || !isnull(hacker) || failure_timer)
		icon_state = "apcemag"
	else
		icon_state = "apc0"

	return ..()

/obj/machinery/apc/update_overlays()
	. = ..()
	if((machine_stat & (BROKEN | MAINT)) || opened || panel_open)
		// open, don't bother
		return
	//! warning: legacy below
	. += "apcox-[cover_locked? 1 : 0]"
	. += "apco3-[charging + 1]"
	if(load_toggled)
		. += (channels_auto & POWER_BIT_ENVIR)? \
			((channels_active & POWER_BIT_ENVIR)? overlay_cache_envir[APC_CHANNEL_STATE_ON_AUTO] : overlay_cache_envir[APC_CHANNEL_STATE_OFF_AUTO]) : \
			((channels_active & POWER_BIT_ENVIR)? overlay_cache_envir[APC_CHANNEL_STATE_ON] : overlay_cache_envir[APC_CHANNEL_STATE_OFF])
		. += (channels_auto & POWER_BIT_LIGHT)? \
			((channels_active & POWER_BIT_LIGHT)? overlay_cache_light[APC_CHANNEL_STATE_ON_AUTO] : overlay_cache_light[APC_CHANNEL_STATE_OFF_AUTO]) : \
			((channels_active & POWER_BIT_LIGHT)? overlay_cache_light[APC_CHANNEL_STATE_ON] : overlay_cache_light[APC_CHANNEL_STATE_OFF])
		. += (channels_auto & POWER_BIT_EQUIP)? \
			((channels_active & POWER_BIT_EQUIP)? overlay_cache_equip[APC_CHANNEL_STATE_ON_AUTO] : overlay_cache_equip[APC_CHANNEL_STATE_OFF_AUTO]) : \
			((channels_active & POWER_BIT_EQUIP)? overlay_cache_equip[APC_CHANNEL_STATE_ON] : overlay_cache_equip[APC_CHANNEL_STATE_OFF])

/obj/machinery/apc/proc/generate_overlay_caches()
	overlay_cache_equip = list()
	overlay_cache_light = list()
	overlay_cache_envir = list()
	var/list/list_of_lists = list(overlay_cache_equip, overlay_cache_light, overlay_cache_envir)
	var/channel = 1
	for(var/list/cache_list as anything in list_of_lists)
		cache_list.len = 4
		var/mutable_appearance/generating = new /mutable_appearance
		generating.icon_state = "apco[channel]"
		generating.color = COLOR_LIME
		cache_list[APC_CHANNEL_STATE_ON] = generating
		generating.icon_state = "apco[channel]"
		generating.color = COLOR_BLUE
		cache_list[APC_CHANNEL_STATE_ON_AUTO] = generating
		generating.icon_state = "apco[channel]"
		generating.color = COLOR_RED
		cache_list[APC_CHANNEL_STATE_OFF] = generating
		generating.icon_state = "apco[channel]"
		generating.color = COLOR_ORANGE
		cache_list[APC_CHANNEL_STATE_OFF_AUTO] = generating
		++channel

#warn above

//* Breaker *//

/obj/machinery/apc/proc/set_breaker_toggled(toggled, defer_update)
	src.breaker_toggled = toggled
	if(!defer_update)
		reconsider_active()
	push_ui_data(data = list("breakerToggled" = breaker_toggled))

/obj/machinery/apc/proc/set_load_active(value, defer_update)
	load_active = value
	if(!defer_update)
		full_update_channels()

/obj/machinery/apc/proc/reconsider_active(defer_update)
	var/can_be_active = TRUE
	if(!load_auto_online)
		can_be_active = FALSE
	else if(!breaker_toggled)
		can_be_active = FALSE
	else if(error_check_until > world.time)
		can_be_active = FALSE

	if(can_be_active == load_active)
		return
	if(!defer_update)
		set_load_active(can_be_active)

/**
 * checks if we're online / emitting at all
 *
 * @return TRUE / FALSE
 */
/obj/machinery/apc/proc/is_online()
	return load_active

//* Channels *//

/**
 * checks if a channel is online
 *
 * @return TRUE / FALSE
 */
/obj/machinery/apc/proc/is_channel_online(channel)
	return !!(channels_active & POWER_CHANNEL_TO_BIT(channel))

/**
 * sets a channel to a specific mode
 */
/obj/machinery/apc/proc/set_channel_setting(channel, new_setting, defer_updates)
	var/bit = power_channel_bits[channel]
	switch(new_setting)
		if(APC_CHANNEL_AUTO)
			channels_auto |= bit
			channels_enabled |= bit
		if(APC_CHANNEL_ON)
			channels_enabled |= bit
			channels_auto &= ~bit
		if(APC_CHANNEL_OFF)
			channels_enabled &= ~bit
			channels_auto &= ~bit
	update_channel_status(channel, defer_updates)

/obj/machinery/apc/proc/set_channel_threshold(channel, new_threshold, defer_updates)
	channel_thresholds[channel] = clamp(new_threshold, 0, 1)
	update_channel_status(channel, defer_updates)

/**
 * @return true/false based on if any channel was changed
 */
/obj/machinery/apc/proc/full_update_channels(defer_updates, reconsider_active = TRUE)
	. = FALSE
	if(reconsider_active)
		update_load_active(TRUE)
	for(var/i in 1 to POWER_CHANNEL_COUNT)
		. = update_channel_status(i, TRUE, FALSE) || .
	if(. && !defer_updates)
		update_icon()
		// todo: optimize
		registered_area?.power_change()

/**
 * @return TRUE / FALSE based on if the channel was changed
 */
/obj/machinery/apc/proc/update_channel_status(channel, defer_updates, reconsider_active)
	if(reconsider_active)
		update_load_active()
	var/channel_bit = POWER_CHANNEL_TO_BIT(channel)
	// the ! is to boolean-coerce
	var/should_be_inactive = compute_channel_status(channel, defer_updates)
	var/is_inactive = !(channels_active & channel_bit)
	// this only works if it's boolean-coerced
	if(should_be_inactive != is_inactive)
		return
	if(should_be_inactive)
		channels_active &= ~channel_bit
	else
		channels_active |= channel_bit
	if(!defer_updates)
		registered_area?.power_change()

/**
 * check if the channel should be active
 */
/obj/machinery/apc/proc/compute_channel_status(channel, defer_updates)
	var/channel_bit = POWER_CHANNEL_TO_BIT(channel)
	if(!load_active)
		return FALSE
	if(!(channels_toggled & channel_bit))
		return FALSE
	if((channels_auto & channel_bit) && !(channels_auto_online & channel_bit))
		return FALSE
	return TRUE

//* Init *//

/**
 * inits cell to what it should be at creation
 *
 * * do not call this if this is an APC being constructed.
 */
/obj/machinery/apc/proc/create_cell(update_icon = TRUE)
	QDEL_NULL(cell)
	if(!cell_type)
		if(update_icon)
		update_icon()
		return
	cell = new cell_type
	cell.charge = cell.maxcharge * cell_start_percent * 0.01
	if(update_icon)
		update_icon()

/**
 * inits power buffer to what it should be at creation
 *
 * * do not call this if this is an APC being constructed.
 */
/obj/machinery/apc/proc/create_buffer()
	if(cell && cell_start_percent > 0)
		buffer = buffer_capacity
	else if(terminal?.is_connected())
		buffer = buffer_capacity
	else
		buffer = 0

//* Movement *//

/obj/machinery/apc/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!isnull(terminal) && (terminal.loc != loc))
		terminal.forceMove(loc)

/obj/machinery/apc/setDir(new_dir)
	. = ..()
	update_pixel_offsets()

/obj/machinery/apc/update_pixel_offsets()
	base_pixel_x = 0
	base_pixel_y = 0
	var/turf/T = get_step(get_turf(src), dir)
	if(istype(T) && T.density)
		switch(dir)
			if(SOUTH)
				base_pixel_y = -22
			if(NORTH)
				base_pixel_y = 22
			if(EAST)
				base_pixel_x = 22
			if(WEST)
				base_pixel_x = -22
	if(!isnull(terminal) && terminal.dir != dir)
		terminal.setDir(dir)
	reset_pixel_offsets()

//* Nightshift *//

/obj/machinery/apc/proc/update_nightshift(automatic)
	set_nightshift_active(should_be_nightshift(), automatic)

/obj/machinery/apc/proc/currently_considered_night()
	return SSnightshift.nightshift_active && (registered_area.nightshift_level & SSnightshift.nightshift_level)

/obj/machinery/apc/proc/should_be_nightshift()
	switch(nightshift_setting)
		if(APC_NIGHTSHIFT_ALWAYS)
			return TRUE
		if(APC_NIGHTSHIFT_NEVER)
			return FALSE
		if(APC_NIGHTSHIFT_AUTO)
			return currently_considered_night()

/obj/machinery/apc/proc/set_nightshift_setting(new_setting, automatic, force)
	//! legacy code
	if(automatic && istype(registered_area, /area/shuttle))
		return
	//! end
	nightshift_setting = new_setting
	update_nightshift()

/obj/machinery/apc/proc/reset_nightshift_setting(forced_setting = initial(nightshift_setting))
	set_nightshift_setting(forced_setting, TRUE)

/obj/machinery/apc/proc/set_nightshift_active(active)
	registered_area.set_nightshift(active, automatic)

//* Power Solver *//

/obj/machinery/apc/process(delta_time)
	//! LEGACY
	// if we're broken, do nothing
	if(machine_stat & (BROKEN | MAINT))
		return
	//! END

	// if we don't have an area, bail, this is an error state
	if(!registered_area)
		return

	// prep for cycle

	// do we need to update channels?
	var/should_update_channels = FALSE
	// deficit below 0, in joules
	var/drain_deficit_joules = 0
	// do we need to update icon?
	var/should_update_icon = FALSE
	// total load last cycle
	// this is in watts
	var/total_static_watts = 0
	// total burst used power last cycle
	// this is in joules
	var/total_burst_j = 0

	// does the area require power?
	if(!isnull(registered_area.area_power_override))
		// the area uses power
		for(var/channel in 1 to POWER_CHANNEL_COUNT)
			if(!(registered_area.power_channels & POWER_CHANNEL_TO_BIT(channel)))
				// not on
				continue
			var/channel_total = area.power_usage_static[channel]
			last_channel_load[channel] = channel_total
			current_burst_load[channel] = 0
			total_burst_j += current_burst_load[channel]
			total_static_watts += channel_total
	else
		// the area doesn't
		// todo: the area should reset apcs last used / burst used to 0 when it's set to power override mode
		//       remove this else clause after this is done
		pass()

	// start power_requested_kilowatts, the amount of kilowatts we want to draw from grid
	// add static power to requested draw; we always try to draw that much if we can
	var/power_requested_kilowatts = floor(total_static_watts * 0.001)
	// get the amount of static power that doesn't fit a whole kilowatt
	var/remainder_static_watts = total_static_watts - power_requested_kilowatts * 1000

	if(cell)
		// celled operation
		// do we need to charge the cell?
		// cell charging is always eager.
		if(charging_enabled && cell.charge < cell.maxcharge)
			// we charge slower the closer we are to full to prevent oscillation.
			var/charging_draw = floor(min(max(DYNAMIC_CELL_UNITS_TO_KW(cell.maxcharge - cell.charge, delta_time) / 100, 1), charging_draw))
			power_requested_kilowatts += charging_draw

	// now, an assumption made here is that drawing from the powernet
	// is more expensive than drawing from buffer,
	// as powernet ops are a function call and some indirection
	// while buffer is just a number stored on ourselves.

	// therefore, we process buffer first.

	// buffer
	// the purpose of the buffer is to smooth burst loads.
	// and to be a temporary power buffer when someone's doing grid maintenance.

	// calculate secondary draw in joules
	// this is burst power used plus leftover static power
	// we multiply remainder_static_watts by delta_time to get joules (remainder static is in watts)
	// anything less than 1 joule can be safely thrown out / considered a rounding error
	var/secondary_draw_joules = floor(total_burst_j + remainder_static_watts * delta_time)

	// we hate oscillation
	// if we just directly shunt all of this to the powernet, what we're
	// going to end up with is an oscillation from the buffer
	// filling to max, draining a bit, and then
	// draining max power from the powernet

	// instead what we're going to do is use the massive 50kj buffer to smooth operations
	var/buffer_after = buffer - secondary_draw_joules
	// if we're below what we can do
	// here have some hellish math
	// remember; use delta_time so 2kj is actually a 1kw draw, because powernets
	// are tick-synced but burst draws are not necessarily so.
	var/buffer_requested_kilowatts
	if(buffer_after < 0)
		// recharge a certain ratio plus whatever is needed to get it above 0, ceil'd
		// -buffer_after because buffer_active is negative.
		buffer_requested_kilowatts = ceil((buffer_capacity * buffer_recharge_heuristic - buffer_after) * 0.001 / delta_time)
	else
		// recharge only a certain ratio
		buffer_requested_kilowatts = max(0, floor((buffer_capacity - buffer_after) * buffer_recharge_heuristic * 0.001 / delta_time))
	power_requested_kilowatt += buffer_requested_kilowatts

	//* DRAW STEP *//

	// perform grid draw step, expanding it to watts
	var/grid_acquired_watts = use_grid_power(power_requested_kilowatt, TRUE) * 1000

	// priority 1: do we have enough to power static power?
	if(total_static_watts > grid_acquired_watts)
		// anything missing will be drained from cell
		var/missing_static_watts = total_static_watts - grid_acquired_watts
		var/cell_to_static = DYNAMIC_CELL_UNITS_TO_W(cell.use(DYNAMIC_W_TO_CELL_UNITS(missing_static_watts, delta_time)))
		missing_static_watts -= cell_to_static
		if(missing_static_watts > 0)
			// not enough to cover
			drain_deficit_joules += missing_static_watts
		grid_acquired_watts = 0
	else
		grid_acquired_watts -= total_static_watts

	// priority 2: anything remaining goes into buffer
	var/buffer_recharge_watts = min(grid_acquired_watts, buffer_requested_kilowatts * 1000)
	// watts is multiplied by time, as buffer is in joules
	buffer_after += buffer_recharge_watts * delta_time
	grid_acquired_watts -= buffer_recharge_watts

	// if buffer is near or empty, we're in big trouble
	if(buffer_after < 500)
		// can we drain from cell?
		var/cell_to_buffer = DYNAMIC_CELL_UNITS_TO_J(cell.use(DYNAMIC_J_TO_CELL_UNITS(500 - buffer_after)))
		buffer_after += cell_to_buffer
		if(buffer_after < 500)
			// welp, we're empty!
			drain_deficit_joules += 500 - buffer_after
	// update buffer
	buffer = max(0, buffer_after)

	// priority 3: anything remaining goes into cell
	if(grid_acquired_watts > 0)
		// if there's more power than there should be the cell might be overcharged
		// but surely my math works.
		cell.give(DYNAMIC_W_TO_CELL_UNITS(grid_acquired_watts, delta_time))

	//* END *//

	// if we're in a grid check, check if we shouldn't be
	if(error_check_until && error_check_until < world.time)
		error_check_until = null
		should_update_channels = TRUE

	// if active, check if we need to not be active
	if(drain_deficit_joules)
		// we hit 0, penalize the area longer the more we went below 0
		// we don't need to process anything else, everything is offline
		should_update_channels = TRUE
		load_auto_online = FALSE
		channels_auto_online = NONE
		// todo: adjust penalty based on how long it's been oscillating
		// todo: add a manual IO reboot button to be able to bypass this if power is detected to be sufficient
		// drain_deficit_joules is in J, so if you blow out an APC with a worst-case load of:
		// 1,000 = 3 seconds
		// 10,000 = 10 seconds
		// 100,000 = 30 seconds
		// 1,000,000 = 60 seconds (it hit cap earlier)
		var/penalize_for = 15 SECONDS + min(60 SECONDS, sqrt(drain_deficit_joules))
		next_online_pulse = world.time + penalize_for
	// not fully empty, but check if we need to auto-disable any channels
	else if(load_auto_online && channels_auto_online && channels_auto && cell)
		// this only works if there's a cell, buffer is too volatile to be used for %-based heuristics
		var/cell_ratio = cell.charge / cell.maxcharge
		for(var/i in 1 to POWER_CHANNEL_COUNT)
			var/channel_bit = POWER_CHANNEL_TO_BIT(i)
			var/currently_auto_online = channels_auto_online & channel_bit
			if(!currently_auto_online)
				continue
			var/should_be_online = channel_thresholds[i] <= cell_ratio
			if(should_be_online)
				continue
			channels_auto_online &= ~channel_bit
			should_update_channels = TRUE
			// no oscillating please
			next_online_pulse = world.time + 15 SECONDS
	// if anything is inactive, see if we can reboot things
	if(world.time >= next_online_pulse && (!load_auto_online || (channels_auto_online != POWER_BITS_ALL)))
		// ..but at a maximum of once per 5 seconds
		next_online_pulse = world.time = 5 SECONDS
		if(buffer > 500 && !load_auto_online)
			should_update_channels = TRUE
			load_auto_online = TRUE
		// only update channels if load_auto_online is on, otherwise we can't even operate
		if(!load_auto_online)
			if(cell)
				// use ratio if cell
				var/cell_ratio = cell.charge / cell.maxcharge
				channels_auto_online = NONE
				for(var/i in 1 to POWER_CHANNEL_COUNT)
					if(channel_thresholds[i] > cell_ratio)
						continue
					var/channel_bit = POWER_CHANNEL_TO_BIT(i)
					should_update_channels = TRUE
					channels_auto_online |= channel_bit
			else
				// no automation allowed without cell
				channels_auto_online = POWER_BITS_ALL
				should_update_channels = TRUE

	if(should_update_channels)
		full_update_channels()
	else if(should_update_icon)
		update_icon()


//* Power Usage - General *//

/**
 * draws power from grid to ourselves
 *
 * @params
 * * amount - kw
 * * balance - obey grid balancing? FALSE = use flat power from network
 *
 * @return kw drawn
 */
/obj/machinery/apc/proc/use_grid_power(amount, balance)
	#warn impl

//* Power Usage - Burst *//

/**
 * something is trying to use a dynamic amount of burst power
 *
 * @params
 * * amount - how much in joules
 * * channel - power channel
 * * allow_partial - allow partial usage
 * * over_time - (optional) amount of deciseconds this is over, used for smoothing
 *
 * @return power drawn
 */
/obj/machinery/apc/proc/supply_burst_power(amount, channel, allow_partial, over_time)

#warn impl all

//* Terminal *//

/obj/machinery/apc/proc/destroy_terminal()
	QDEL_NULL(terminal)

/obj/machinery/apc/proc/create_terminal()
	if(!isnull(terminal))
		return
	terminal = new /obj/machinery/power/terminal(loc, dir, src)

/obj/machinery/apc/terminal_destroyed(obj/machinery/power/terminal/terminal)
	if(terminal == src.terminal)
		src.terminal = null

//* UI *//

/obj/machinery/apc/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AreaPowerController", name) // 510, 460
		ui.open()

#warn finish rest of UI

/obj/machinery/apc/ui_data(mob/user)
	. = list()
	.["breakerToggled"] = breaker_toggled
	#warn audit below
	.["nightshiftSetting"] = nightshift_setting
	.["nightshiftActive"] = registered_area?.nightshift
	.["channelsEnabled"] = channels_enabled
	.["channelsAuto"] = channels_auto
	.["channelsActive"] = channels_active
	.["channelThresholds"] = channel_thresholds
	.["chargeEnabled"] = charging_enabled
	.["chargeActive"] = charging
	.["loadBalancePriority"] = load_balancing_priority
	.["loadBalanceAllowed"] = load_balancing_modify
	.["loadActive"] = load_active

	#warn impl below

	var/list/data = list(
		"locked" = locked,
		"normallyLocked" = locked,
		"emagged" = emagged,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(lastused_total),
		"totalCharging" = round(lastused_charging),
		"failTime" = failure_timer * 2,
		"gridCheck" = grid_check,
		"coverLocked" = coverlocked,
		"siliconUser" = issilicon(user) || (isobserver(user) && is_admin(user)), //I add observer here so admins can have more control, even if it makes 'siliconUser' seem inaccurate.
		"emergencyLights" = !emergency_lights,

		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = lastused_equip,
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 3),
					"on"   = list("eqp" = 2),
					"off"  = list("eqp" = 1)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = round(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 3),
					"on"   = list("lgt" = 2),
					"off"  = list("lgt" = 1)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = round(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 3),
					"on"   = list("env" = 2),
					"off"  = list("env" = 1)
				)
			)
		)
	)

	return data + .

/obj/machinery/apc/ui_act(action, params)
	if(..() || !can_use(usr, TRUE))
		return TRUE

	// There's a handful of cases where we want to allow users to bypass the `locked` variable.
	// If can_admin_interact() wasn't only defined on observers, this could just be part of a single-line
	// conditional.
	var/locked_exception = FALSE
	if(issilicon(usr) || action == "nightshift")
		locked_exception = TRUE
	if(isobserver(usr))
		var/mob/observer/dead/D = usr
		if(D.can_admin_interact())
			locked_exception = TRUE

	if(locked && !locked_exception)
		return

	// pre-auth actions
	switch(action)
		if("nightshift")
			var/set_to = text2num(params["state"])
			// no spammies!!
			if(nightshift_last_user_switch > world.time - 5 SECONDS)
				usr.action_feedback(SPAN_WARNING("[src]'s night lighting circuits are still cycling!"))
				return TRUE
			nightshift_last_user_switch = TRUE
			switch(set_to)
				if(APC_NIGHTSHIFT_AUTO)
				if(APC_NIGHTSHIFT_ALWAYS)
				if(APC_NIGHTSHIFT_NEVER)
				else
					return TRUE
			INVOKE_ASYNC(src, PROC_REF(set_nightshift_setting), set_to)
			return TRUE

	#warn auth

	// post-auth actions
	switch(action)
		if("channel")
			var/chan = params["channel"]
			var/set_to = params["state"]
			switch(set_to)
				if(APC_CHANNEL_AUTO)
				if(APC_CHANNEL_ON)
				if(APC_CHANNEL_OFF)
				else
					return TRUE
			set_channel_setting(chan, set_to)
			return TRUE
		if("threshold")
			var/chan = params["channel"]
			var/set_to = text2num(params["threshold"])
			set_channel_threshold(chan, set_to)
			return TRUE

	. = TRUE
	switch(action)
		if("lock")
			if(locked_exception) // Yay code reuse
				if(emagged || (machine_stat & (BROKEN|MAINT)))
					to_chat(usr, "The APC does not respond to the command.")
					return
				locked = !locked
				update_icon()
		if("cover")
			coverlocked = !coverlocked
		if("breaker")
			toggle_breaker()
		if("charge")
			chargemode = !chargemode
			if(!chargemode)
				charging = 0
				update_icon()
		if("reboot")
			failure_timer = 0
			update_icon()
			update()
		if("emergency_lighting")
			emergency_lights = !emergency_lights
			for(var/obj/machinery/light/L in area)
				if(!initial(L.no_emergency)) //If there was an override set on creation, keep that override
					L.no_emergency = emergency_lights
					INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)
				CHECK_TICK
		if("overload")
			if(locked_exception) // Reusing for simplicity!
				overload_lighting()

/obj/machinery/apc/proc/can_use(mob/user as mob, var/loud = 0) //used by attack_hand() and Topic()
	if(!user.client)
		return 0
	if(IsAdminGhost(user)) //This is to allow nanoUI interaction by ghost admins.
		return TRUE
	if(user.stat)
		return 0
	if(inoperable())
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(user.restrained())
		to_chat(user,"<span class='warning'>Your hands must be free to use [src].</span>")
		return 0
	if(user.lying)
		to_chat(user,"<span class='warning'>You must stand to use [src]!</span>")
		return 0
	autoflag = 5
	if(istype(user, /mob/living/silicon))
		var/permit = 0 // Malfunction variable. If AI hacks APC it can control it even without AI control wire.
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if(hacker)
			if(hacker == AI)
				permit = 1
			else if(istype(robot) && robot.connected_ai && robot.connected_ai == hacker) // Cyborgs can use APCs hacked by their AI
				permit = 1

		if(aidisabled && !permit)
			if(!loud)
				to_chat(user, "<span class='danger'>\The AI control for [src] has been disabled!</span>")
			return 0
	else
		if(!in_range(src, user) || !istype(loc, /turf))
			return 0
	var/mob/living/carbon/human/H = user
	if(istype(H) && prob(H.getBrainLoss()))
		to_chat(user, "<span class='danger'>You momentarily forget how to use [src].</span>")
		return 0
	return 1

//* Subtypes

/// APCS no power cells
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/alarms_hidden/no_cell, 22)
/obj/machinery/apc/no_cell
	cell_type = null

//Critical//
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/critical, 22)
/obj/machinery/apc/critical
	is_critical = 1

/// High capacity cell APCs
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/high, 22)
/obj/machinery/apc/high
	cell_type = /obj/item/cell/high

/// Super capacity cell APCS
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/super, 22)
/obj/machinery/apc/super
	cell_type = /obj/item/cell/super

/// Critical APCs with super cells
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/super/critical, 22)
/obj/machinery/apc/super/critical
	is_critical = 1

/// APCS with hyper cells. How lewd
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/hyper, 22)
/obj/machinery/apc/hyper
	cell_type = /obj/item/cell/hyper

/// APCs with alarms hidden. Use these for POI's and offmap stuff so engineers dont get notified that shitty_ruins4 is running out of power -Bloop
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/alarms_hidden, 22)
/obj/machinery/apc/alarms_hidden
	alarms_hidden = TRUE

/// APCS with hidden alarms and no power cells
CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/apc/alarms_hidden/no_cell, 22)
/obj/machinery/apc/alarms_hidden/no_cell
	cell_type = null
