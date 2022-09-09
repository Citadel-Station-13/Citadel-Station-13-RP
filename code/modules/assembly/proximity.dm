/obj/item/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MAT_STEEL = 800, MAT_GLASS = 200)
	wires = WIRE_PULSE

	secured = 0

	var/scanning = 0
	var/timing = 0
	var/time = 10
	var/hearing_range = 3
	var/range = 2

	var/datum/proxfield/basic/square/monitor

/obj/item/assembly/prox_sensor/Initialize(mapload)
	. = ..()
	monitor = new(src, 1)

/obj/item/assembly/prox_sensor/activate()
	if(!..())
		return FALSE
	timing = !timing
	update_icon()
	return FALSE

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

/obj/item/assembly/prox_sensor/Proximity(datum/proxfield/field, atom/movable/AM)
	if(!istype(AM))
		log_debug("DEBUG: HasProximity called with [AM] on [src] ([usr]).")
		return
	if (istype(AM, /obj/effect/beam))
		return
	if (!isobserver(AM) && AM.move_speed < 12)
		sense()

/obj/item/assembly/prox_sensor/proc/sense()
	if((!holder && !secured) || !scanning || !process_cooldown())
		return FALSE
	pulse(FALSE)
	audible_message(SPAN_INFOPLAIN("[icon2html(src, hearers(src))] *beep* *beep* *beep*"), null, hearing_range)
	for(var/CHM in get_hearers_in_view(hearing_range, src))
		if(ismob(CHM))
			var/mob/LM = CHM
			LM.playsound_local(get_turf(src), 'sound/machines/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
	return TRUE

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
		time = initial(time)

/obj/item/assembly/prox_sensor/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	INVOKE_ASYNC(src, .proc/sense)

/obj/item/assembly/prox_sensor/proc/toggle_scan()
	if(!secured)
		return FALSE
	scanning = !scanning
	update_icon()

/obj/item/assembly/prox_sensor/update_icon()
	cut_overlays()
	LAZYCLEARLIST(attached_overlays)
	if(timing)
		add_overlay("prox_timing")
		LAZYADD(attached_overlays, "prox_timing")
	if(scanning)
		add_overlay("prox_scanning")
		LAZYADD(attached_overlays, "prox_scanning")
	if(holder)
		holder.update_icon()
	if(holder && istype(holder.loc,/obj/item/grenade/chem_grenade))
		var/obj/item/grenade/chem_grenade/grenade = holder.loc
		grenade.primed(scanning)

/obj/item/assembly/prox_sensor/Move()
	..()
	sense()

/obj/item/assembly/prox_sensor/ui_interact(mob/user, datum/tgui/ui)
	if(!secured)
		to_chat(user, SPAN_WARNING("[src] is unsecured!"))
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
