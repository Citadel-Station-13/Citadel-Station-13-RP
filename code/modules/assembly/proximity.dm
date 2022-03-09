/obj/item/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200)
	flags = PROXMOVE
	wires = WIRE_PULSE

	secured = 0

	var/scanning = 0
	var/timing = 0
	var/time = 10

	var/range = 2

/obj/item/assembly/prox_sensor/activate()
	if(!..())	return 0//Cooldown check
	timing = !timing
	update_icon()
	return 0


/obj/item/assembly/prox_sensor/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		scanning = 0
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/assembly/prox_sensor/HasProximity(atom/movable/AM as mob|obj)
	if(!istype(AM))
		log_debug("DEBUG: HasProximity called with [AM] on [src] ([usr]).")
		return
	if (istype(AM, /obj/effect/beam))	return
	if (!isobserver(AM) && AM.move_speed < 12)	sense()
	return


/obj/item/assembly/prox_sensor/proc/sense()
	var/turf/mainloc = get_turf(src)
//		if(scanning && cooldown <= 0)
//			mainloc.visible_message("[icon2html(thing = src, target = world)] *boop* *boop*", "*boop* *boop*")
	if((!holder && !secured)||(!scanning)||(cooldown > 0))	return 0
	pulse(0)
	if(!holder)
		mainloc.visible_message("[icon2html(thing = src, target = world)] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()
	return


/obj/item/assembly/prox_sensor/process(delta_time)
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range,mainloc))
			if (A.move_speed < 12)
				sense()

	if(timing && (time >= 0))
		time--
	if(timing && time <= 0)
		timing = 0
		toggle_scan()
		time = 10
	return


/obj/item/assembly/prox_sensor/dropped()
	. = ..()
	INVOKE_ASYNC(src, .proc/sense)

/obj/item/assembly/prox_sensor/proc/toggle_scan()
	if(!secured)	return 0
	scanning = !scanning
	update_icon()
	return


/obj/item/assembly/prox_sensor/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "prox_timing"
		attached_overlays += "prox_timing"
	if(scanning)
		overlays += "prox_scanning"
		attached_overlays += "prox_scanning"
	if(holder)
		holder.update_icon()
	if(holder && istype(holder.loc,/obj/item/grenade/chem_grenade))
		var/obj/item/grenade/chem_grenade/grenade = holder.loc
		grenade.primed(scanning)
	return


/obj/item/assembly/prox_sensor/Move()
	..()
	sense()
	return


/obj/item/assembly/prox_sensor/ui_interact(mob/user, datum/tgui/ui)
	if(!secured)
		to_chat(user, "<span class='warning'>[src] is unsecured!</span>")
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AssemblyProx", name)
		ui.open()

/obj/item/assembly/prox_sensor/ui_data(mob/user)
	var/list/data = ..()

	data["time"] = time * 10
	data["timing"] = timing
	data["range"] = range
	data["maxRange"] = 5
	data["scanning"] = scanning

	return data

/obj/item/assembly/prox_sensor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("scanning")
			toggle_scan()
			return TRUE
		if("timing")
			timing = !timing
			update_icon()
			return TRUE
		if("set_time")
			var/real_new_time = 0
			var/new_time = params["time"]
			var/list/L = splittext(new_time, ":")
			if(LAZYLEN(L))
				for(var/i in 1 to LAZYLEN(L))
					real_new_time += text2num(L[i]) * (60 ** (LAZYLEN(L) - i))
			else
				real_new_time = text2num(new_time)
			time = clamp(real_new_time, 0, 600)
			return TRUE
		if("range")
			range = clamp(params["range"], 1, 5)
			return TRUE
