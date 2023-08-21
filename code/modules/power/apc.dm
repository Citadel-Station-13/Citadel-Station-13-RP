GLOBAL_LIST_EMPTY(apcs)

/// EMP effect duration is divided by this number if the APC has "critical" flag
#define CRITICAL_APC_EMP_PROTECTION 10

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto
/// Power channel is off and will stay that way dammit
#define POWERCHAN_OFF      0
/// Power channel is off until power rises above a threshold
#define POWERCHAN_OFF_AUTO 1
/// Power channel is on until there is no power
#define POWERCHAN_ON       2
/// Power channel is on until power drops below a threshold
#define POWERCHAN_ON_AUTO  3

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
	req_access = list(ACCESS_ENGINEERING_APC)

	//? Appearance
	/// overlay caches generated
	var/static/overlay_cache_generated = FALSE
	/// cached images, because we have to change color so we can't use just text unless we hardcode the colors
	var/static/list/overlay_cache_equip
	/// cached images, because we have to change color so we can't use just text unless we hardcode the colors
	var/static/list/overlay_cache_light
	/// cached images, because we have to change color so we can't use just text unless we hardcode the colors
	var/static/list/overlay_cache_envir

	//? Area Handling
	#warn hook registered_area
	/// the area we're registered to
	var/area/registered_area

	//? Nightshift Handling
	/// nightshift setting
	var/nightshift_setting = APC_NIGHTSHIFT_AUTO
	/// last nightshift switch by user
	var/nightshift_last_user_switch

	//? Power Handling
	/// breaker: on/off
	var/breaker = TRUE
	/// internal capacitor capacity in joules
	var/buffer_capacity = 25000
	/// internal capacitor joules; this is auto-set at init based on if we have a cell / power if null.
	var/buffer
	/// our power cell
	var/obj/item/cell/cell
	/// starting power cell type
	var/cell_type = /obj/item/cell/apc
	/// starting power cell charge in %
	var/start_charge = 100
	/// charging enabled
	var/charging_enabled = FALSE
	/// currently charging
	var/charging = FALSE
	/// power channels enabled
	var/channels_enabled = POWER_BITS_ALL
	/// power channels auto
	var/channels_auto = POWER_BITS_ALL
	/// power channels currently on
	var/channels_active = POWER_BITS_ALL
	/// last power used
	var/list/last_power_using = EMPTY_POWER_CHANNEL_LIST
	/// burst usage for channels since last process()
	var/list/burst_power_using = EMPTY_POWER_CHANNEL_LIST
	/// percentage (as 0.0 to 1.0) of cell remaining to turn a channel off at
	/// if no cell, it turns off immediately upon insufficient power from mains.
	var/list/channel_thresholds = APC_CHANNEL_THRESHOLDS_DEFAULT
	/// alarm threshold as ratio
	/// if no cell, this doesn't alarm as long as it has enough power.
	var/alarm_threshold = 0.3

	#warn rest

	var/area/area
	var/areastring = null
	var/chargelevel = 0.0005  // Cap for how fast APC cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/grid_check = FALSE
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/obj/machinery/power/terminal/terminal = null
	var/main_status = 0
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	var/wiresexposed = 0
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10
	var/datum/wires/apc/wires = null
	var/emergency_lights = FALSE
	var/update_state = -1
	var/update_overlay = -1
	var/is_critical = 0
	var/global/status_overlays = 0
	var/failure_timer = 0
	var/force_update = 0
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ
	var/alarms_hidden = FALSE //If power alarms from this APC are visible on consoles

/obj/machinery/apc/Initialize(mapload, set_dir, constructing)
	if(!overlay_cache_generated)
		generate_overlay_caches()
	. = ..()
	GLOB.apcs += src

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
	GLOB.apcs -= src

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

#warn what
/obj/machinery/apc/drain_energy(datum/actor, amount, flags)
	charging = FALSE
	// makes sure fully draining apc cell won't break cell charging

	var/drained = 0

	if(terminal?.powernet)
		terminal.powernet.trigger_warning()
		// no conversion - amount = kj, draw_power is in kw
		drained += terminal.powernet.draw_power(amount)

	//The grid rarely gives the full amount requested, or perhaps the grid
	//isn't connected (wire cut), in either case we draw what we didn't get
	//from the cell instead.
	if((drained < amount) && cell)
		drained += cell.drain_energy(actor, amount, flags)

	return drained

// APCs are pixel-shifted, so they need to be updated.
/obj/machinery/apc/setDir(new_dir)
	. = ..()
	if(!.)
		return
	update_dir()

/obj/machinery/apc/proc/update_dir()
	pixel_x = (src.dir & 3)? 0 : (src.dir == 4 ? 24 : -24)
	pixel_y = (src.dir & 3)? (src.dir ==1 ? 24 : -24) : 0
	terminal?.setDir(dir)

#warn what
/obj/machinery/apc/proc/energy_fail(var/duration)
	failure_timer = max(failure_timer, round(duration))

/obj/machinery/apc/proc/auto_build()
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
		if(W.w_class != ITEMSIZE_NORMAL)
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
				var/obj/structure/cable/N = T.get_cable_node()
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
				new /obj/item/frame/apc(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut from the wall by [user.name] with the [WT.name].</span>",\
					"<span class='notice'>You cut the APC frame from the wall.</span>",\
					"You hear welding.")
			qdel(src)
			return
	else if (opened && ((machine_stat & BROKEN) || hacker || emagged))
		if (istype(W, /obj/item/frame/apc) && (machine_stat & BROKEN))
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
				&& W.w_class >= ITEMSIZE_SMALL )
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
			//Placeholder until someone can do take_damage() for APCs or something.
			to_chat(user,"<span class='notice'>The [src.name] looks too sturdy to bash open with \the [W.name].</span>")

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

/obj/machinery/apc/process(delta_time)


	if(machine_stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return
	if(failure_timer)
		update()
		queue_icon_update()
		failure_timer--
		force_update = 1
		return

	#warn above

	var/using_joules = 0
	for(var/channel in 1 to POWER_CHANNEL_COUNT)
		var/channel_total = area.power_usage_static[channel] + burst_power_using[channel]
		burst_power_using[channel] = 0
		using_power_last[channel] = channel_total
		using_joules += channel_total

	#warn below

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2


	#warn placeholder
	// start handling draw
	var/needed = 0
	// fetch & accumulate
	for(var/i in 1 to POWER_CHANNEL_COUNT)
		needed += static_power_used[i] = area.power_usage_static[i]
	// draw power from grid
	var/wanted_kw = round((needed + (buffer < buffer_capacity? buffer_capacity - buffer : 0)) * 0.001)
	var/grid_drawn = draw_grid_power(wanted_kw, TRUE)
	// subtract
	needed -= grid_drawn * 1000
	// difference?
	if(needed < 0)
		// recharge buffer
		buffer = min(buffer_capacity, buffer - needed)
	else
		// drain buffer
		buffer = max(0, buffer - needed)


	#warn guh

	if(cell && !shorted && !grid_check)
		// draw power from cell as before to power the area
		var/cellused = min(cell.charge, DYNAMIC_W_TO_CELL_UNITS(lastused_total, 1))	// clamp deduction to a max, amount left in cell
		cell.use(cellused)
		// TODO: the rest of this code is war crime territory
		// TODO: rewrite APCs. entirely.
		// if we're empty just kill it all
		if(cell.percent() < 1)
			// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			autoflag = 0

		// we're lazy and i'm not writing a real accumulator, and we need to recharge in units of 1 due to floating point bullshit
		// hence..
		// we recharge at most lastused kw rounded down
		var/kw = round(lastused_total * 0.001)
		lazy_draw_accumulator += lastused_total - kw * 1000
		if(lazy_draw_accumulator > 1000)
			kw += round(lazy_draw_accumulator * 0.001)
			lazy_draw_accumulator = lazy_draw_accumulator % 1000
		if(excess > kw)
			var/draw = draw_power(kw)
			cell.give(DYNAMIC_KW_TO_CELL_UNITS(draw, 1))

		// Set channels depending on how much charge we have left
		update_channels()

		// now trickle-charge the cell
		lastused_charging = 0 // Clear the variable for new use.
		if(src.attempt_charging())
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(DYNAMIC_KW_TO_CELL_UNITS(excess, 1), cell.maxcharge * chargelevel, cell.maxcharge - cell.charge)
				var/charged = draw_power(DYNAMIC_CELL_UNITS_TO_KW(ch, 1)) // Removes the power we're taking from the grid
				cell.give(DYNAMIC_KW_TO_CELL_UNITS(charged, 1)) // actually recharge the cell
				lastused_charging = charged * 1000
				lastused_total += lastused_charging // Sensors need this to stop reporting APC charging as "Other" load
			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.percent() >= 99)	// TODO: apc refactor - this is the only way for now, otherrwise we'll never stop charging as we don't ever charge to full entirely
			charging = 2
		else if(charging == 2)		// if charging is supposedly fully charged but we're not actually fully charged, shunt back to charging
			charging = 1

		if(chargemode)
			if(!charging)
				var/charge_tick = cell.maxcharge * chargelevel
				charge_tick = DYNAMIC_CELL_UNITS_TO_KW(charge_tick, 1)
				if(excess > charge_tick)
					chargecount++
				else
					chargecount = 0

				if(chargecount >= 5)

					chargecount = 0
					charging = 1

		else // chargemode off
			charging = 0
			chargecount = 0

	else // no cell, switch everything off
		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		power_alarm.triggerAlarm(loc, src, hidden=alarms_hidden)
		autoflag = 0

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = 0
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

/obj/machinery/apc/proc/update_channels()
	// Allow the APC to operate as normal if the cell can charge
	if(charging && longtermpower < 10)
		longtermpower += 1
	else if(longtermpower > -10)
		longtermpower -= 2

	if((cell.percent() > 30) || longtermpower > 0)              // Put most likely at the top so we don't check it last, effeciency 101
		if(autoflag != 3)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			autoflag = 3
			power_alarm.clearAlarm(loc, src)
	else if((cell.percent() <= 30) && (cell.percent() > 15) && longtermpower < 0)                       // <30%, turn off equipment
		if(autoflag != 2)
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			power_alarm.triggerAlarm(loc, src, hidden=alarms_hidden)
			autoflag = 2
	else if(cell.percent() <= 15)        // <15%, turn off lighting & equipment
		if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			power_alarm.triggerAlarm(loc, src, hidden=alarms_hidden)
			autoflag = 1
	else                                   // zero charge, turn all off
		if(autoflag != 0)
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			power_alarm.triggerAlarm(loc, src, hidden=alarms_hidden)
			autoflag = 0

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

/obj/machinery/apc/proc/reset()
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
	last_power_using = EMPTY_POWER_USAGE_LIST
	burst_power_using = EMPTY_POWER_USAGE_LIST

	channels_enabled = POWER_BITS_ALL
	channels_auto = POWER_BITS_ALL
	charging_enabled = TRUE
	charging = FALSE
	breaker = FALSE

	requires_update = full_update_channels() || requires_update

	if(requires_update)
		update_icon()
		registered_area?.power_change()

	#warn impl
	//reset various counters so that process() will start fresh
	chargecount = initial(chargecount)
	autoflag = initial(autoflag)
	longtermpower = initial(longtermpower)
	failure_timer = initial(failure_timer)

//? Appearance

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
	. += "apcox-[locked? 1 : 0]"
	. += "apco3-[charging + 1]"
	if(breaker)
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

//? Channels

/obj/machinery/apc/proc/set_channel_setting(channel, new_setting, defer_updates)
	var/bit = power_channel_bits[channel]
	switch(new_setting)
		if(APC_CHANNEL_AUTO)
			channels_auto |= bit
		if(APC_CHANNEL_ON)
			channels_enabled |= bit
			channels_auto &= ~bit
		if(APC_CHANNEL_OFF)
			channels_enabled &= ~bit
			channels_auto &= ~bit
	update_channel_setting(channel, defer_updates)

/obj/machinery/apc/proc/set_channel_threshold(channel, new_threshold, defer_updates)
	channel_thresholds[channel] = clamp(new_threshold, 0, 1)
	update_channel_setting(channel, defer_updates)

/**
 * @return true/false based on if any channel was changed
 */
/obj/machinery/apc/proc/full_update_channels(defer_updates)
	. = FALSE
	for(var/i in 1 to POWER_CHANNEL_COUNT)
		. = update_channel_setting(i, TRUE) || .
	if(. && !defer_updates)
		update_icon()
		// todo: optimize
		registered_area?.power_change()

/**
 * @return true/false based on if the channel was changed
 */
/obj/machinery/apc/proc/update_channel_setting(channel, defer_updates)
	#warn impl

/obj/machinery/apc/proc/should_enable_channel(channel)
	#warn impl

//? Movement

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

//? Nightshift

/obj/machinery/apc/proc/currently_considered_night()
	return SSnightshift.nightshift_active

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
	set_nightshift_active(should_be_nightshift())

/obj/machinery/apc/proc/reset_nightshift_setting(forced_setting = initial(nightshift_setting))
	set_nightshift_setting(forced_setting, TRUE)

/obj/machinery/apc/proc/set_nightshift_active(active)
	registered_area.set_nightshift(active)

//? Power Usage - General

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

//? Power Usage - Burst

/**
 * something is trying to use a dynamic amount of burst power
 *
 * @params
 * * amount - how much
 * * channel - power channel
 * * allow_partial - allow partial usage
 * * over_time - (optional) amount of deciseconds this is over, used for smoothing
 *
 * @return power drawn
 */
/obj/machinery/apc/proc/supply_burst_power(amount, channel, allow_partial, over_time)

#warn impl all

//? Terminal

/obj/machinery/apc/proc/destroy_terminal()
	QDEL_NULL(terminal)

/obj/machinery/apc/proc/create_terminal()
	if(!isnull(terminal))
		return
	terminal = new /obj/machinery/power/terminal(loc, dir, src)

/obj/machinery/apc/terminal_destroyed(obj/machinery/power/terminal/terminal)
	if(terminal == src.terminal)
		src.terminal = null

//? UI

/obj/machinery/apc/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AreaPowerController", name) // 510, 460
		ui.open()

#warn finish rest of UI

/obj/machinery/apc/ui_data(mob/user)
	. = list()
	.["nightshiftSetting"] = nightshift_setting
	.["nightshiftActive"] = registered_area?.nightshift
	.["channelsEnabled"] = channels_enabled
	.["channelsAuto"] = channels_auto
	.["channelsActive"] = channels_active
	.["channelThresholds"] = channel_thresholds
	.["chargeEnabled"] = charging_enabled
	.["chargeActive"] = charging
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

// todo: codegen the directional paths with a macro

/obj/machinery/apc/direction_bump  //For the love of god there's so many fucking var edits of the APC, use these instead pleaaaaase -Bloop

/obj/machinery/apc/direction_bump/east
	name = "east bump"
	dir = 4
	pixel_x = 28

/obj/machinery/apc/direction_bump/west
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/direction_bump/north
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/direction_bump/south
	name = "south bump"
	pixel_y = -28

//Critical//
/obj/machinery/apc/critical
	is_critical = 1

/obj/machinery/apc/critical/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28

/obj/machinery/apc/critical/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/critical/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/critical/south_bump
	name = "south bump"
	pixel_y = -28

/// High capacity cell APCs
/obj/machinery/apc/high
	cell_type = /obj/item/cell/high

/obj/machinery/apc/high/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28
/obj/machinery/apc/high/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/high/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/high/south_bump
	name = "south bump"
	pixel_y = -28

/// Super capacity cell APCS
/obj/machinery/apc/super
	cell_type = /obj/item/cell/super

/obj/machinery/apc/super/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28
/obj/machinery/apc/super/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/super/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/super/south_bump
	name = "south bump"
	pixel_y = -28


/// Critical APCs with super cells
/obj/machinery/apc/super/critical
	is_critical = 1

/obj/machinery/apc/super/critical/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28
/obj/machinery/apc/super/critical/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/super/critical/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/super/critical/south_bump
	name = "south bump"
	pixel_y = -28

/// APCS with hyper cells. How lewd
/obj/machinery/apc/hyper
	cell_type = /obj/item/cell/hyper

/obj/machinery/apc/hyper/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28
/obj/machinery/apc/hyper/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/hyper/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/hyper/south_bump
	name = "south bump"
	pixel_y = -28

/// APCs with alarms hidden. Use these for POI's and offmap stuff so engineers dont get notified that shitty_ruins4 is running out of power -Bloop
/obj/machinery/apc/alarms_hidden
	alarms_hidden = TRUE

/obj/machinery/apc/alarms_hidden/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28

/obj/machinery/apc/alarms_hidden/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/alarms_hidden/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/alarms_hidden/south_bump
	name = "south bump"
	pixel_y = -28

/// APCS with hidden alarms and no power cells
/obj/machinery/apc/alarms_hidden/no_cell
	cell_type = null
	chargelevel = 0

/obj/machinery/apc/alarms_hidden/no_cell/east_bump
	name = "east bump"
	dir = 4
	pixel_x = 28

/obj/machinery/apc/alarms_hidden/no_cell/west_bump
	name = "west bump"
	dir = 8
	pixel_x = -28

/obj/machinery/apc/alarms_hidden/no_cell/north_bump
	name = "north bump"
	dir = 1
	pixel_y = 28

/obj/machinery/apc/alarms_hidden/no_cell/south_bump
	name = "south bump"
	pixel_y = -28
