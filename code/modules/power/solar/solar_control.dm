/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = 1
	density = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 250
	var/id = 0
	var/cdir = 0
	var/targetdir = 0		// target angle in manual tracking (since it updates every game minute)
	var/gen = 0
	var/lastgen = 0
	var/track = 0			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1� in manual tracking
	var/obj/machinery/power/tracker/connected_tracker = null
	var/list/connected_panels = list()
	var/auto_start = FALSE

// Used for mapping in solar arrays which automatically start itself.
// Generally intended for far away and remote locations, where player intervention is rare.
// In the interest of backwards compatability, this isn't named auto_start, as doing so might break downstream maps.
/obj/machinery/power/solar_control/autostart
	auto_start = TRUE

// Similar to above but controlled by the configuration file.
// Intended to be used for the main solar arrays, so individual servers can choose to have them start automatically or require manual intervention.
/obj/machinery/power/solar_control/config_start
	auto_start = SOLAR_AUTO_START_CONFIG

/obj/machinery/power/solar_control/Initialize(mapload)
	. = ..()
	connect_to_network()
	set_panels(cdir)

/obj/machinery/power/solar_control/Destroy()
	for(var/obj/machinery/power/solar/M in connected_panels)
		M.unset_control()
	if(connected_tracker)
		connected_tracker.unset_control()
	return ..()

/obj/machinery/power/solar_control/proc/auto_start(forced = FALSE)
	// Automatically sets the solars, if allowed.
	if(forced || auto_start == TRUE || (auto_start == SOLAR_AUTO_START_CONFIG && config_legacy.autostart_solars) )
		track = 2 // Auto tracking mode.
		search_for_connected()
		if(connected_tracker)
			set_tracker_angle()
		set_panels(cdir)

// This would use LateInitialize(), however the powernet does not appear to exist during that time.
/legacy_hook/roundstart/proc/auto_start_solars()
	for(var/a in GLOB.solars_list)
		var/obj/machinery/power/solar_control/SC = a
		SC.auto_start()
	return TRUE

/obj/machinery/power/solar_control/can_drain_energy(datum/actor, flags)
	return FALSE

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	GLOB.solars_list.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and not already in solar_list...
		GLOB.solars_list |= src //... add it
	return to_return

/// Search for unconnected panels and trackers in the computer powernet and connect them
/obj/machinery/power/solar_control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S = M
				if(!S.control) //i.e unconnected
					S.set_control(src)
					connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T = M
					if(!T.control) //i.e unconnected
						connected_tracker = T
						T.set_control(src)

/// Called by the SSsun.sun controller, update the facing angle (either manually or via tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(machine_stat & (NOPOWER | BROKEN))
		return

	switch(track)
		if(1)
			if(trackrate) //we're manual tracking. If we set a rotation speed...
				cdir = targetdir //...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			if(connected_tracker)
				set_tracker_angle()

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/update_icon()
	cut_overlays()
	if(machine_stat & BROKEN)
		icon_state = "broken"
		return
	if(machine_stat & NOPOWER)
		icon_state = "c_unpowered"
		return
	icon_state = "solar"
	if(cdir > -1)
		add_overlay(image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir)))
	return

/obj/machinery/power/solar_control/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!..())
		interact(user)

/obj/machinery/power/solar_control/interact(mob/user)
	var/t = "<B><span class='highlight'>Generated power</span></B> : [round(lastgen)] W<BR>"
	t += "<B><span class='highlight'>Star Orientation</span></B>: [cdir]&deg ([angle2text(cdir)])<BR>"
	t += "<B><span class='highlight'>Array Orientation</span></B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	t += "<B><span class='highlight'>Tracking:</span></B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "<span class='linkOn'>Off</span> <A href='?src=\ref[src];track=1'>Timed</A> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <A href='?src=\ref[src];track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	t += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	t += "<A href='?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : [connected_panels.len] connected<BR>"
	t += "Solar tracker : [connected_tracker ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"]</div><BR>"

	t += "<A href='?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/popup = new(user, "solar", name)
	popup.set_content(t)
	popup.open()

	return

/obj/machinery/power/solar_control/attackby(obj/item/I, user as mob)
	if(I.is_screwdriver())
		playsound(src, I.tool_sound, 50, 1)
		if(do_after(user, 20))
			if (src.machine_stat & BROKEN)
				to_chat(user, "<font color=#4F49AF>The broken glass falls out.</font>")
				var/obj/structure/frame/A = new /obj/structure/frame/computer( src.loc )
				new /obj/item/material/shard( src.loc )
				var/obj/item/circuitboard/solar_control/M = new /obj/item/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "computer_3"
				A.anchored = 1
				qdel(src)
			else
				to_chat(user, "<font color=#4F49AF>You disconnect the monitor.</font>")
				var/obj/structure/frame/A = new /obj/structure/frame/computer( src.loc )
				var/obj/item/circuitboard/solar_control/M = new /obj/item/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "computer_4"
				A.anchored = 1
				qdel(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/power/solar_control/process(delta_time)
	lastgen = gen
	gen = 0

	if(machine_stat & (NOPOWER | BROKEN))
		return

	if(connected_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(connected_tracker.powernet != powernet)
			connected_tracker.unset_control()

	if(track==1 && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we need to increase/decrease the angle by 1�...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360 	//... do it
			nexttime += 36000/abs(trackrate) //reset the counter for the next 1�

	update()

	updateDialog()

/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return 0
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return 0

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = clamp((360+src.cdir+text2num(href_list["cdir"]))%360, 0, 359)
			src.targetdir = src.cdir
			if(track == 2) //manual update, so losing auto-tracking
				track = 0
			spawn(1)
				set_panels(cdir)
		if(href_list["tdir"])
			src.trackrate = clamp(src.trackrate+text2num(href_list["tdir"]), -7200, 7200)
			if(src.trackrate) nexttime = world.time + 36000/abs(trackrate)

	if(href_list["track"])
		track = text2num(href_list["track"])
		if(track == 2)
			if(connected_tracker)
				set_tracker_angle()
				set_panels(cdir)
		else if (track == 1) //begin manual tracking
			src.targetdir = src.cdir
			if(src.trackrate) nexttime = world.time + 36000/abs(trackrate)
			set_panels(targetdir)

	if(href_list["search_connected"])
		src.search_for_connected()
		if(connected_tracker && track == 2)
			set_tracker_angle()
		src.set_panels(cdir)

	interact(usr)
	return 1

/obj/machinery/power/solar_control/proc/set_tracker_angle()
	var/angle = 0
	var/datum/planet/our_planet = null
	var/turf/T = get_turf(src)
	if(T.z <= SSplanets.z_to_planet.len)
		our_planet = SSplanets.z_to_planet[z]

	if(our_planet && istype(our_planet))
		var/time_num = text2num(our_planet.current_time.show_time("hh")) + (text2num(our_planet.current_time.show_time("mm"))/60)
		var/day_hours = our_planet.current_time.seconds_in_day / (1 HOURS)
		angle = round((time_num / day_hours) * 360) // day as progress from 0 to 1 * 360
	else
		angle = SSsun.sun.angle

	connected_tracker.set_angle(angle)

//rotates the panel to the passed angle
/obj/machinery/power/solar_control/proc/set_panels(var/cdir)

	for(var/obj/machinery/power/solar/S in connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.update_solar_exposure()//and
		S.update_icon() //update it

	update_icon()


/obj/machinery/power/solar_control/power_change()
	..()
	update_icon()


/obj/machinery/power/solar_control/proc/broken()
	machine_stat |= BROKEN
	update_icon()


/obj/machinery/power/solar_control/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return

/proc/rate_control(var/S, var/V, var/C, var/Min=1, var/Max=5, var/Limit=null) //How not to name vars
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit) return "[href]=-[Limit]'>-</A>"+rate+"[href]=[Limit]'>+</A>"
	return rate
