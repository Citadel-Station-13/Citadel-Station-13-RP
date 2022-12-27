/obj/item/mining_scanner
	name = "mining scanner"
	desc = "A nondescript scanner usually used by miners."
	#warn icon
	icon = 'icons/modules/mining/tools/scanner.dmi'
	icon_state = ""
	// todo: new rnd lol
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 150)

	//! aboveground scanning
	/// can aboveground scan
	var/scans_excavation = TRUE
	/// aboveground ore scan range
	var/excavation_scan_range = 10
	/// aboveground ore scan range max
	var/excavation_scan_range_max = 14
	/// aboveground auto scan toggle
	var/excavation_scan_auto = FALSE
	/// last excavation scan
	var/excavation_scan_last = 0
	/// auto scan timerid
	var/excavation_scan_auto_timerid
	/// cooldown
	var/excavation_scan_cooldown = 3 SECONDS
	/// scan in progress
	var/excavation_scanning = FALSE
	/// excavation scan sound
	var/excavation_scan_sound
	#warn sound

	//! underground scanning
	/// can underground scan
	var/scans_drilling = TRUE
	/// underground ore scan range
	var/drilling_scan_range = 3
	/// max underground ore scan range
	var/drilling_scan_range_max = 5
	/// show exact amounts
	var/drilling_scan_exact_amount = FALSE
	/// show exact ores
	var/drilling_scan_exact_ore = FALSE
	/// underground ore scan time
	var/drilling_scan_delay = 3 SECONDS
	/// underground ore scan in progress
	var/drilling_scanning = FALSE
	/// drilling scan sound
	var/drilling_scan_sound
	#warn sound

/obj/item/mining_scanner/Destroy()
	set_auto_scanning(FALSE)
	return ..()

/obj/item/mining_scanner/ui_static_data(mob/user)
	. = ..()
	.["scan_range_drill"] = drilling_scan_range
	.["scan_range_drill_max"] = drilling_scan_range_max
	.["scan_range_excav"] = excavation_scan_range
	.["scan_range_excav_max"] = excavation_scan_range_max
	.["auto"] = excavation_scan_auto

/obj/item/mining_scanner/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("auto")
			set_auto_scanning(!excavation_scan_auto)
		if("above_range")
			var/newrange = text2num(params["range"])
			if(isnull(newrange))
				return
			excavation_scan_range = clamp(newrange, 0, excavation_scan_range_max)
		if("under_range")
			var/newrange = text2num(params["range"])
			if(isnull(newrange))
				return
			drilling_scan_range = clamp(newrange, 0, drilling_scan_range_max)

#warn tgui for modifications

/obj/item/mining_scanner/proc/set_auto_scanning(state)
	state = !!state
	excavation_scan_auto = state
	// reset
	if(excavation_scan_auto_timerid)
		deltimer(excavation_scan_auto_timerid)
		excavation_scan_auto_timerid = null
	if(state)
		addtimer(CALLBACK(src, .proc/excavation_scan), min(world.time, excavation_scan_last + excavation_scan_cooldown), TIMER_STOPPABLE | TIMER_LOOP)
	send_tgui_data_immediate(data = list("auto" = state))

/obj/item/mining_scanner/proc/excavation_scan(mob/user, range)
	#warn support autoscan

/obj/item/mining_scanner/proc/do_excavation_scan(mob/user, range, turf/center)
	#warn impl

/obj/item/mining_scanner/proc/drilling_scan(mob/user, range)
	if(drilling_scanning || !istype(user))
		return
	drilling_scanning = TRUE
	user.visible_message(
		SPAN_NOTICE("[user] starts sweeping [src] in a wide arc as it emits a soft hum..."),
		SPAN_NOTICE("You start sweeping [src] in a wide arc as it starts scanning for underground resources...")
	)
	if(!do_after(user, drilling_scan_delay, get_turf(user)))
		drilling_scanning = FALSE
		return
	var/list/found = do_drilling_scan(user, range, get_turf(user))
	to_chat(user, "***Underground Ores***")
	to_chat(user, found.Join("<br>"))
	drilling_scanning = FALSE

/obj/item/mining_scanner/proc/do_drilling_scan(mob/user, range, turf/center)
	var/list/ids = query_underground_ores_estimate(center, range)
	. = list()
	for(var/id in ids)

	#warn filter base don if drilling scan is exact in amount and ore
