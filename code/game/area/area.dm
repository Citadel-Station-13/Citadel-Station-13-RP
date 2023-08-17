/**
 * # area
 *
 * A grouping of tiles into a logical space, mostly used by map editors
 *
 * *Warning*: Accessing contents in any way, including "in src", "in contents", "contents", etc,
 *     is *extremely* expensive. Do not do it unless it's truly for an one off purpose.
 *     This is because BYOND does not actually internally maintain a contents list for /area;
 *     accessing contents is equivalent to iterating over world and filtering out everything
 *     not in the area.
 */
/area
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = ABOVE_LIGHTING_PLANE //In case we color them
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	//? intrinsics
	/// area flags
	var/area_flags = NONE
	/// stores the next uid to use
	var/global/global_uid = 0
	/// our uid
	var/uid
	/**
	 * If false, loading multiple maps with this area type will create multiple instances.
	 * This is not a flag because you probably should not be touching this at runtime!
	 */
	var/unique = TRUE

	//? defaults
	/// outdoors by default?
	var/initial_outdoors = FALSE
	/// default initial gas mix
	var/initial_gas_mix = GAS_STRING_STP

	//? tracking lists for machinery
	/// holopads - lazyinit'd
	var/list/obj/machinery/holopad/holopads


	//? Nightshift
	/// is nightshift on?
	var/nightshift = FALSE

	//? Parallax
	/// Parallax moving?
	var/parallax_moving = FALSE
	/// Parallax move speed - 0 to disable
	var/parallax_move_speed = 0
	/// Parallax move dir - degrees clockwise from north
	var/parallax_move_angle = 0

	//? Power
	/// force all machinery using area power to be able to receive unlimited power, or no power; null for use area power system.
	/// implies the same setting of area_power_infinite if set.
	var/area_power_override = null
	/// if set to on, apcs don't ever drain and all power usage is just done without hitting APC at all.
	var/area_power_infinite = FALSE
	/// power usages - registered / static
	var/list/power_usage_static = EMPTY_POWER_CHANNEL_LIST
	/// power channels turned on
	var/power_channels = POWER_BITS_ALL

	//? Smoothing
	/// Typepath to limit the areas (subtypes included) that atoms in this area can smooth with. Used for shuttles.
	var/area/area_limited_icon_smoothing

	//? unsorted
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	var/lightswitch = 1

	var/eject = null

	var/debug = 0

	var/music = null

	var/has_gravity = TRUE
	var/obj/machinery/power/apc/apc = null
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = null		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/list/all_arfgs = null		//Similar, but a list of all arfgs adjacent to this area
	var/firedoors_closed = 0
	var/arfgs_active = 0

	var/list/ambience = list()
	var/list/forced_ambience = null
	/// Used to decide what kind of reverb the area makes sound have
	var/sound_env = STANDARD_STATION

	/// Color on minimaps, if it's null (which is default) it makes one at random.
	var/minimap_color

	var/tmp/is_outside = OUTSIDE_NO

/**
 * Called when an area loads
 *
 *  Adds the item to the GLOB.areas_by_type list based on area type
 */
/area/New()
	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if (unique)
		// todo: something is double initing reserve area god damnit...
		// if(GLOB.areas_by_type[type])
		// 	STACK_TRACE("duplicated unique area, someone fucked up")
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
		dynamic_lighting = CONFIG_GET(flag/starlight) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED

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
			INVOKE_ASYNC(A, PROC_REF(power_change))
*/
	STOP_PROCESSING(SSobj, src)
	return ..()

/**
 * Changes the area of T to A. Do not do this manually.
 * Area is expected to be a non-null instance.
 */
/proc/ChangeArea(turf/T, area/A)
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
		if(SSlighting.initialized)
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

	// if(T.is_outside == OUTSIDE_AREA && T.is_outside() != old_outside)
	// 	T.update_weather()

// compatibility wrapper, remove posthaste by making sure nothing checks area has_gravity.
/area/has_gravity()
	return has_gravity

/**
 * DANGER DANGER EXTREMELY EXPENSIVE DO NOT CALL OFTEN
 *
 * THIS IS ON THE REFACTOR
 */
/area/proc/get_contents()
	return contents

/**
 * DANGER DANGER EXTREMELY EXPENSIVE DO NOT CALL OFTEN
 *
 * THIS IS ON THE REFACTOR
 */
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
	for (var/obj/machinery/alarm/AA as anything in GLOB.air_alarms)
		if(AA.loc?.loc != src)
			continue
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

/area/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("check_static_power", "Check Static Power")

/area/vv_do_topic(list/href_list)
	. = ..()
	if(href_list["check_static_power"])
		debug_static_power(usr)

/// Debugging proc to report if static power is correct or not.
/area/proc/debug_static_power(mob/user)
	var/list/was = power_usage_static.Copy()
	retally_power()
	if(user)
		var/list/report = list()
		report += "[src] ([type]) static power trace: was --> actual:"
		for(var/i in 1 to POWER_CHANNEL_COUNT)
			report += "[global.power_channel_names[i]] - [power_usage_static[i] == old[i]? "<span class='good'>" : "<span class='bad'>"][old[i]] --> [power_usage_static[i]]</span>"
		to_chat(user, jointext(report, "<br>"))
	return was ~= power_usage_static

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
		if(H.species.species_flags & NO_SLIP)//diona and similar should not slip from moving onto space either.
			return
		if(H.m_intent == MOVE_INTENT_RUN)
			H.adjust_stunned(20 * 6)
			H.adjust_paralyzed(20 * 6)
		else
			H.adjust_stunned(20 * 3)
			H.adjust_paralyzed(20 * 3)
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


/area/proc/get_apc()
	return apc

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
			if(T.z in (LEGACY_MAP_DATUM).station_levels)
				station = TRUE
				break
			else
				break
		if(station)
			teleportlocs[AR.name] = AR

	teleportlocs = tim_sort(teleportlocs, GLOBAL_PROC_REF(cmp_text_asc), TRUE)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in GLOB.sortedAreas)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z in (LEGACY_MAP_DATUM).player_levels)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = tim_sort(ghostteleportlocs, GLOBAL_PROC_REF(cmp_text_asc), TRUE)

	return 1

//? Dropping

/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

//? Nightshift

/**
 * This is tick checked.
 */
/area/proc/set_nightshift(on, automatic)
	if(on == nightshift)
		return
	nightshift = on
	for(var/obj/machinery/light/L in src)
		L.nightshift_mode(on)
		CHECK_TICK

//? Power

/**
 * returns if the channel is being powered
 */
/area/proc/powered(channel)
	if(!isnull(area_power_override))
		return area_power_override
	return power_channels & global.power_channel_bits[channel]

/**
 * use a dynamic amount of burst power
 *
 * @params
 * * amount - how much
 * * channel - power channel
 * * allow_partial - allow partial usage
 * * over_time - (optional) amount of deciseconds this is over, used for smoothing
 *
 * @return power drawn
 */
/area/proc/use_burst_power(amount, channel, allow_partial, over_time)
	if(!powered(channel))
		return 0
	if(area_power_infinite || (area_power_override == TRUE))
		return amount
	return isnull(apc)? 0 : apc.use_burst_power(amount, channel, allow_partial, over_time)

/**
 * set which power channels are turned on
 */
/area/proc/set_power_channels(channels)
	if(channels == power_channels)
		return
	power_channels = channels
	power_change()

/**
 * EXTREMELY SLOW
 *
 * Retallys area power and makes sure it's up to date.
 */
/area/proc/retally_power()
	power_usage_static = EMPTY_POWER_CHANNEL_LIST
	for(var/obj/machinery/M in src)
		switch(M.use_power)
			if(USE_POWER_ACTIVE)
				power_usage_static[M.power_channel] += M.active_power_usage
				M.registered_power_usage = M.active_power_usage
			if(USE_POWER_IDLE)
				power_usage_static[M.power_channel] += M.idle_power_usage
				M.registered_power_usage = M.idle_power_usage
			if(USE_POWER_CUSTOM)
				if(isnull(M.registered_power_usage))
					continue
				power_usage_static[M.power_channel] += M.registered_power_usage

//? Turf operations - add / remove

/**
 * changes turfs to us
 *
 * @params
 * * turfs - turfs to take.
 */
/area/proc/take_turfs(list/turf/turfs)
	var/list/area/old_areas = list()
	var/turf/T
	for(T as anything in turfs)
		old_areas += T.loc
	contents.Add(turfs)
	for(var/i in 1 to length(turfs))
		T = i
		T.on_change_area(old_areas[i], src)
