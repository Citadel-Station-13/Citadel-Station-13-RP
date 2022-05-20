/**
 * # area
 *
 * A grouping of tiles into a logical space, mostly used by map editors
 */
/area
	/// area flags
	var/area_flags = NONE

	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = ABOVE_LIGHTING_PLANE //In case we color them
	mouse_opacity = 0
	var/lightswitch = 1

	var/eject = null

	var/debug = 0

	/// Will objects this area be needing power?
	var/requires_power = TRUE
	/// This gets overridden to 1 for space in area/.
	var/always_unpowered = FALSE

	/// Power channel status - Is it currently energized?
	var/power_equip = TRUE
	var/power_light = TRUE
	var/power_environ = TRUE

	// Oneoff power usage - Used once and cleared each power cycle
	var/oneoff_equip = 0
	var/oneoff_light = 0
	var/oneoff_environ = 0

	// Continuous "static" power usage - Do not update these directly!
	var/static_equip = 0
	var/static_light = 0
	var/static_environ = 0

	/// Parallax moving?
	var/parallax_moving = FALSE
	/// Parallax move speed - 0 to disable
	var/parallax_move_speed = 0
	/// Parallax move dir - degrees clockwise from north
	var/parallax_move_angle = 0

	var/music = null

	var/has_gravity = 1
	var/obj/machinery/power/apc/apc = null
	var/no_air = null
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = null		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/list/all_arfgs = null		//Similar, but a list of all arfgs adjacent to this area
	var/firedoors_closed = 0
	var/arfgs_active = 0

	var/list/ambience = list()
	var/list/forced_ambience = null
	/// Used to decide what kind of reverb the area makes sound have
	var/sound_env = STANDARD_STATION
	var/global/global_uid = 0
	var/uid

	/// If false, loading multiple maps with this area type will create multiple instances.
	var/unique = TRUE

	/// Color on minimaps, if it's null (which is default) it makes one at random.
	var/minimap_color

	///Typepath to limit the areas (subtypes included) that atoms in this area can smooth with. Used for shuttles.
	var/area/area_limited_icon_smoothing

/**
 * Called when an area loads
 *
 *  Adds the item to the GLOB.areas_by_type list based on area type
 */
/area/New()
	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if (unique)
		GLOB.areas_by_type[type] = src

	uid = ++global_uid

	if(!minimap_color) // goes in New() because otherwise it doesn't fucking work
		// generate one using the icon_state
		if(icon_state && icon_state != "unknown")
			var/icon/I = new(icon, icon_state, dir)
			I.Scale(1,1)
			minimap_color = I.GetPixel(1,1)
		else // no icon state? use random.
			minimap_color = rgb(rand(50,70),rand(50,70),rand(50,70)) // This interacts with the map loader, so it needs to be set immediately
	return ..()

/*
 * Initalize this area
 *
 * intializes the dynamic area lighting and also registers the area with the z level via
 * reg_in_areas_in_z
 *
 * returns INITIALIZE_HINT_LATELOAD
 */
/area/Initialize(mapload)
	icon_state = ""

	if(requires_power)
		luminosity = 0
	else
		power_light = TRUE
		power_equip = TRUE
		power_environ = TRUE

		if(dynamic_lighting == DYNAMIC_LIGHTING_FORCED)
			dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
			luminosity = 0
		else if(dynamic_lighting != DYNAMIC_LIGHTING_IFSTARLIGHT)
			dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	if(dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
		dynamic_lighting = CONFIG_GET(number/starlight) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED

	. = ..()

	reg_in_areas_in_z()

	blend_mode = BLEND_MULTIPLY // Putting this in the constructor so that it stops the icons being screwed up in the map editor.

	if(!IS_DYNAMIC_LIGHTING(src))
		add_overlay(/obj/effect/fullbright)

	return INITIALIZE_HINT_LATELOAD // Areas tradiationally are initialized AFTER other atoms.

/**
 * Sets machine power levels in the area
 */
/area/LateInitialize()
	power_change() // all machines set to current power level, also updates lighting icon

/**
 * Register this area as belonging to a z level
 *
 * Ensures the item is added to the SSmapping.areas_in_z list for this z
 */
/area/proc/reg_in_areas_in_z()
	if(!length(contents))
		return
	var/list/areas_in_z = SSmapping.areas_in_z
	// update_areasize()
	if(!z)
		WARNING("No z found for [src]")
		return
	if(!areas_in_z["[z]"])
		areas_in_z["[z]"] = list()
	areas_in_z["[z]"] += src

/**
 * Destroy an area and clean it up
 *
 * Removes the area from GLOB.areas_by_type and also stops it processing on SSobj
 *
 * This is despite the fact that no code appears to put it on SSobj, but
 * who am I to argue with old coders
 */
/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
/*
	if(base_area)
		LAZYREMOVE(base_area, src)
		base_area = null
	if(sub_areas)
		for(var/i in sub_areas)
			var/area/A = i
			A.base_area = null
			sub_areas -= A
			if(A.requires_power)
				A.power_light = FALSE
				A.power_equip = FALSE
				A.power_environ = FALSE
			INVOKE_ASYNC(A, .proc/power_change)
*/
	STOP_PROCESSING(SSobj, src)
	return ..()

// Changes the area of T to A. Do not do this manually.
// Area is expected to be a non-null instance.
/proc/ChangeArea(var/turf/T, var/area/A)
	if(!istype(A))
		CRASH("Area change attempt failed: invalid area supplied.")
	var/area/old_area = get_area(T)
	if(old_area == A)
		return
	// NOTE: BayStation calles area.Exited/Entered for the TURF T.  So far we don't do that.s
	// NOTE: There probably won't be any atoms in these turfs, but just in case we should call these procs.
	A.contents.Add(T)
	if(old_area)
		// Handle dynamic lighting update if
		if(T.dynamic_lighting && old_area.dynamic_lighting != A.dynamic_lighting)
			if(A.dynamic_lighting)
				T.lighting_build_overlay()
			else
				T.lighting_clear_overlay()
		for(var/atom/movable/AM in T)
			old_area.Exited(AM, A)
	for(var/atom/movable/AM in T)
		A.Entered(AM, old_area)
	for(var/obj/machinery/M in T)
		M.power_change()

// compatibility wrapper, remove posthaste by making sure nothing checks area has_gravity.
/area/has_gravity()
	return has_gravity

/area/proc/get_contents()
	return contents

/area/proc/get_cameras()
	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	return cameras

/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		var/obj/machinery/alarm/atmosalarm = alarm_source //maybe other things can trigger these, who knows
		if(istype(atmosalarm))
			atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level, hidden = atmosalarm.alarms_hidden)
		else
			atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.machine_stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		atmosalm = danger_level
		//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
		if (danger_level < 1 || danger_level >= 2)
			firedoors_update()

		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		return 1
	return 0

/// Either close or open firedoors depending on current alert statuses
/area/proc/firedoors_update()
	if(fire || party || atmosalm)
		firedoors_close()
		arfgs_activate()
		if(fire) // Make the lights colored!
			for(var/obj/machinery/light/L in src)
				L.set_alert_fire()
		else if(atmosalm)
			for(var/obj/machinery/light/L in src)
				L.set_alert_atmos()
	else
		firedoors_open()
		arfgs_deactivate()
		for(var/obj/machinery/light/L in src) // Put the lights back!
			L.reset_alert()

/// Close all firedoors in the area
/area/proc/firedoors_close()
	if(!firedoors_closed)
		firedoors_closed = TRUE
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_CLOSED
				else if(!E.density)
					spawn(0)
						E.close()

/// Open all firedoors in the area
/area/proc/firedoors_open()
	if(firedoors_closed)
		firedoors_closed = FALSE
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_OPEN
				else if(E.density)
					spawn(0)
						E.open()

/// Activate all retention fields!
/area/proc/arfgs_activate()
	if(!arfgs_active)
		arfgs_active = TRUE
		if(!all_arfgs)
			return
		for(var/obj/machinery/atmospheric_field_generator/E in all_arfgs)
			E.generate_field() //don't need to check powered state like doors, the arfgs handles it on its end
			E.wasactive = TRUE

/// Deactivate retention fields!
/area/proc/arfgs_deactivate()
	if(arfgs_active)
		arfgs_active = FALSE
		if(!all_arfgs)
			return
		for(var/obj/machinery/atmospheric_field_generator/E in all_arfgs)
			E.disable_field()
			E.wasactive = FALSE


/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		updateicon()
		firedoors_update()

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		updateicon()
		firedoors_update()

/area/proc/readyalert()
	if(!eject)
		eject = 1
		updateicon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		updateicon()
	return

/area/proc/partyalert()
	if (!( party ))
		party = 1
		updateicon()
		firedoors_update()
	return

/area/proc/partyreset()
	if (party)
		party = 0
		updateicon()
		firedoors_update()
	return

/area/proc/updateicon()
	if ((fire || eject || party) && (!requires_power||power_environ) && !istype(src, /area/space))//If it doesn't require power, can still activate this proc.
		if(fire && !eject && !party)
			icon_state = null // Let lights take care of it
		/*else if(atmosalm && !fire && !eject && !party)
			icon_state = "bluenew"*/
		else if(!fire && eject && !party)
			icon_state = "red"
		else if(party && !fire && !eject)
			icon_state = "party"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null


/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/


/**
 * Returns int 1 or 0 if the area has power for the given channel
 *
 * evalutes a mixture of variables mappers can set, requires_power, always_unpowered and then
 * per channel power_equip, power_light, power_environ
 */
/area/proc/powered(chan) // return true if the area has power to given channel

	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return FALSE

/**
 * Called when the area power status changes
 *
 * Updates the area icon, calls power change on all machinees in the area, and sends the `COMSIG_AREA_POWER_CHANGE` signal.
 */
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change() // reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_appearance()

/area/proc/usage(var/chan, var/include_static = TRUE)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += oneoff_light + (include_static * static_light)
		if(EQUIP)
			used += oneoff_equip + (include_static * static_equip)
		if(ENVIRON)
			used += oneoff_environ + (include_static * static_environ)
		if(TOTAL)
			used += oneoff_light + (include_static * static_light)
			used += oneoff_equip + (include_static * static_equip)
			used += oneoff_environ + (include_static * static_environ)
	return used

/**
 * Clear all non-static power usage in area
 *
 * Clears all power used for the dynamic equipment, light and environment channels
 */
/area/proc/clear_usage()
	oneoff_equip = 0
	oneoff_light = 0
	oneoff_environ = 0

/**
 * Add a power value amount to the stored used_x variables
 */
/area/proc/use_power_oneoff(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			oneoff_equip += amount
		if(LIGHT)
			oneoff_light += amount
		if(ENVIRON)
			oneoff_environ += amount
	return amount

/// This is used by machines to properly update the area of power changes.
/area/proc/power_use_change(old_amount, new_amount, chan)
	use_power_static(new_amount - old_amount, chan) // Simultaneously subtract old_amount and add new_amount.

/// Not a proc you want to use directly unless you know what you are doing; see use_power_oneoff above instead.
/area/proc/use_power_static(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			static_equip += amount
		if(LIGHT)
			static_light += amount
		if(ENVIRON)
			static_environ += amount

/// This recomputes the continued power usage; can be used for testing or error recovery, but is not called every tick.
/area/proc/retally_power()
	static_equip = 0
	static_light = 0
	static_environ = 0
	for(var/obj/machinery/M in src)
		switch(M.power_channel)
			if(EQUIP)
				static_equip += M.get_power_usage()
			if(LIGHT)
				static_light += M.get_power_usage()
			if(ENVIRON)
				static_environ += M.get_power_usage()


//////////////////////////////////////////////////////////////////

/area/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("check_static_power", "Check Static Power")

/area/vv_do_topic(list/href_list)
	. = ..()
	if(href_list["check_static_power"])
		if(!check_rights(R_DEBUG))
			return
		src.check_static_power(usr)
		href_list["datumrefresh"] = "\ref[src]"

/// Debugging proc to report if static power is correct or not.
/area/proc/check_static_power(var/user)
	set name = "Check Static Power"
	var/actual_static_equip = static_equip
	var/actual_static_light = static_light
	var/actual_static_environ = static_environ
	retally_power()
	if(user)
		var/list/report = list("[src] ([type]) static power tally:")
		report += "EQUIP:   Actual: [actual_static_equip] Correct: [static_equip] Difference: [actual_static_equip - static_equip]"
		report += "LIGHT:   Actual: [actual_static_light] Correct: [static_light] Difference: [actual_static_light - static_light]"
		report += "ENVIRON: Actual: [actual_static_environ] Correct: [static_environ] Difference: [actual_static_environ - static_environ]"
		to_chat(user, report.Join("\n"))
	return (actual_static_equip == static_equip && actual_static_light == static_light && actual_static_environ == static_environ)

//////////////////////////////////////////////////////////////////

GLOBAL_LIST_EMPTY(forced_ambiance_list)

/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!L?.is_preference_enabled(/datum/client_preference/play_ambiance))
		return

	// If we previously were in an area with force-played ambiance, stop it.
	if(L in GLOB.forced_ambiance_list)
		L.stop_sound_channel(CHANNEL_AMBIENCE_FORCED)
		GLOB.forced_ambiance_list -= L

	if(forced_ambience)
		if(forced_ambience.len)
			GLOB.forced_ambiance_list |= L
			var/sound/chosen_ambiance = pick(forced_ambience)
			if(!istype(chosen_ambiance))
				chosen_ambiance = sound(chosen_ambiance, repeat = 1, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE_FORCED)
			SEND_SOUND(L, chosen_ambiance)
		else
			L.stop_sound_channel(CHANNEL_AMBIENCE_FORCED)
	else if(src.ambience.len && prob(35))
		if((world.time >= L.client.time_last_ambience_played + 1 MINUTE))
			var/sound = pick(ambience)
			SEND_SOUND(L, sound(sound, repeat = 0, wait = 0, volume = 50, channel = CHANNEL_AMBIENCE))
			L.client.time_last_ambience_played = world.time

/area/proc/gravitychange(var/gravitystate = 0, var/area/A)
	A?.has_gravity = gravitystate

	for(var/mob/M in A)
		if(has_gravity)
			thunk(M)
		M.update_floating( M.Check_Dense_Object() )

/area/proc/thunk(mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(H.buckled)
			return // Being buckled to something solid keeps you in place.
		if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.clothing_flags & NOSLIP))
			return
		if(H.species.flags & NO_SLIP)//diona and similar should not slip from moving onto space either.
			return
		if(H.m_intent == MOVE_INTENT_RUN)
			H.AdjustStunned(6)
			H.AdjustWeakened(6)
		else
			H.AdjustStunned(3)
			H.AdjustWeakened(3)
		to_chat(mob, "<span class='notice'>The sudden appearance of gravity makes you fall to the floor!</span>")
		playsound(get_turf(src), "bodyfall", 50, 1)

/area/proc/prison_break()
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC.operating)
		for(var/obj/machinery/power/apc/temp_apc in src)
			temp_apc.overload_lighting(70)
		for(var/obj/machinery/door/airlock/temp_airlock in src)
			temp_airlock.prison_open()
		for(var/obj/machinery/door/window/temp_windoor in src)
			temp_windoor.open()

/area/proc/shuttle_arrived()
	for(var/obj/machinery/power/apc/A in contents)
		A.update_area()
	return TRUE

/area/proc/shuttle_departed()
	return TRUE

/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

// A hook so areas can modify the incoming args
/area/proc/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	return flags

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/

// TODO: nuke this entire system from orbit and rewrite from scratch ~silicons
// "i am far too lazy" WELL GUESS WHAT IM DEALING WITH YOUR STUPID SHIT NOW
var/list/teleportlocs = list()

/proc/setupTeleportLocs()
	for(var/area/AR in GLOB.sortedAreas)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station))
			continue
		if(teleportlocs.Find(AR.name))
			continue
		var/station = FALSE
		for(var/turf/T in AR.contents)
			if(T.z in GLOB.using_map.station_levels)
				station = TRUE
				break
			else
				break
		if(station)
			teleportlocs[AR.name] = AR

	teleportlocs = sortTim(teleportlocs, /proc/cmp_text_asc, TRUE)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in GLOB.sortedAreas)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z in GLOB.using_map.player_levels)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortTim(ghostteleportlocs, /proc/cmp_text_asc, TRUE)

	return 1
