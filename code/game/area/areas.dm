// Areas.dm

/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREA_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING
	plane = PLANE_LIGHTING_ABOVE //In case we color them
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/map_name // Set in New(); preserves the name set by the map maker, even if renamed by the Blueprints.

	var/lightswitch = 1

	var/eject = null

	var/outdoors = FALSE //For space, the asteroid, lavaland, etc. Used with blueprints to determine if we are adding a new area (vs editing a station room)
	var/areasize = 0 //Size of the area in open turfs, only calculated for indoors areas.

	/// If false, loading multiple maps with this area type will create multiple instances.
	var/unique = TRUE

	var/debug = 0
	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1
	var/obj/machinery/power/apc/apc = null
	var/no_air = null
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = null		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/firedoors_closed = 0
	var/list/ambience = list()
	var/list/forced_ambience = null
	var/sound_env = STANDARD_STATION
	var/turf/base_turf //The base turf type of the area, which can be used to override the z-level's base turf
	var/global/global_uid = 0
	var/uid

/area/New()
	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if (unique)
		GLOB.areas_by_type[type] = src
	return ..()

/area/Initialize()
	icon_state = ""
	layer = AREA_LAYER
	uid = ++global_uid
	map_name = name // Save the initial (the name set in the map) name of the area.

/*
	canSmoothWithAreas = typecacheof(canSmoothWithAreas)
*/
	if(!requires_power)
		power_light = TRUE
		power_equip = TRUE
		power_environ = TRUE
		if(dynamic_lighting != DYNAMIC_LIGHTING_FORCED)
			dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	if(dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
		dynamic_lighting = config.starlight? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED	//CONFIG_GET(flag/starlight) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED

	. = ..()

	blend_mode = BLEND_MULTIPLY // Putting this in the constructor so that it stops the icons being screwed up in the map editor.

	if(!IS_DYNAMIC_LIGHTING(src))
		luminosity = 1
	else
		luminosity = 0

	reg_in_areas_in_z()

	return INITIALIZE_HINT_LATELOAD

/area/LateInitialize()
	power_change()		// all machines set to current power level, also updates icon

/area/proc/reg_in_areas_in_z()
	if(contents.len)
		var/list/areas_in_z = SSmapping.areas_in_z
		var/z
		update_areasize()
		for(var/i in 1 to contents.len)
			var/atom/thing = contents[i]
			if(!thing)
				continue
			z = thing.z
			break
		if(!z)
			WARNING("No z found for [src]")
			return
		if(!areas_in_z["[z]"])
			areas_in_z["[z]"] = list()
		areas_in_z["[z]"] += src

/area/proc/update_areasize()
	if(outdoors)
		return FALSE
	areasize = 0
	for(var/turf/simulated/floor/T in contents)
		areasize++

/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
	STOP_PROCESSING(SSobj, src)
	return ..()

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
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
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

// Either close or open firedoors depending on current alert statuses
/area/proc/firedoors_update()
	if(fire || party || atmosalm)
		firedoors_close()
		// VOREStation Edit - Make the lights colored!
		if(fire)
			for(var/obj/machinery/light/L in src)
				L.set_alert_fire()
		else if(atmosalm)
			for(var/obj/machinery/light/L in src)
				L.set_alert_atmos()
		// VOREStation Edit End
	else
		firedoors_open()
		// VOREStation Edit - Put the lights back!
		for(var/obj/machinery/light/L in src)
			L.reset_alert()
		// VOREStation Edit End

// Close all firedoors in the area
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

// Open all firedoors in the area
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

/area/proc/powered(var/chan)		// return true if the area has power to given channel

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

	return 0

// called when power status changes
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		updateicon()

/area/proc/usage(var/chan)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += used_light
		if(EQUIP)
			used += used_equip
		if(ENVIRON)
			used += used_environ
		if(TOTAL)
			used += used_light + used_equip + used_environ
	return used

/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0

/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

/area/Entered(atom/movable/A)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, A)
	SEND_SIGNAL(A, COMSIG_ENTER_AREA, src) //The atom that enters the area

	if(!istype(A,/mob/living))	return

	var/mob/living/L = A
	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if((oldarea.has_gravity == 0) && (newarea.has_gravity == 1) && (L.m_intent == "run")) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)
		L.update_gravity()

	L.lastarea = newarea
	play_ambience(L)

/*	if(!isliving(M))
		return

	var/mob/living/L = M
	if(!L.ckey)
		return

	// Ambience goes down here -- make sure to list each area separately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(L.client && !L.client.ambience_playing && L.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		L.client.ambience_playing = 1
		SEND_SOUND(L, sound('sound/ambience/shipambience.ogg', repeat = 1, wait = 0, volume = 35, channel = CHANNEL_BUZZ))

	if(!(L.client && (L.client.prefs.toggles & SOUND_AMBIENCE)))
		return //General ambience check is below the ship ambience so one can play without the other

	if(prob(35))
		var/sound = pick(ambientsounds)

		if(!L.client.played)
			SEND_SOUND(L, sound(sound, repeat = 0, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
			L.client.played = TRUE
			addtimer(CALLBACK(L.client, /client/proc/ResetAmbiencePlayed), 600)
*/


/area/Exited(atom/movable/M)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, M)
	SEND_SIGNAL(M, COMSIG_EXIT_AREA, src) //The atom that exits the area

var/list/mob/living/forced_ambience_list = new

/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.is_preference_enabled(/datum/client_preference/play_ambience)))	return

	// If we previously were in an area with force-played ambience, stop it.
	if(L in forced_ambience_list)
		L << sound(null, channel = CHANNEL_AMBIENCE_FORCED)
		forced_ambience_list -= L

	if(forced_ambience)
		if(forced_ambience.len)
			forced_ambience_list |= L
			var/sound/chosen_ambience = pick(forced_ambience)
			if(!istype(chosen_ambience))
				chosen_ambience = sound(chosen_ambience, repeat = 1, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE_FORCED)
			L << chosen_ambience
		else
			L << sound(null, channel = CHANNEL_AMBIENCE_FORCED)
	else if(src.ambience.len && prob(35))
		if((world.time >= L.client.time_last_ambience_played + 1 MINUTE))
			var/sound = pick(ambience)
			L << sound(sound, repeat = 0, wait = 0, volume = 50, channel = CHANNEL_AMBIENCE)
			L.client.time_last_ambience_played = world.time

/area/proc/gravitychange(var/gravitystate = 0, var/area/A)
	A.has_gravity = gravitystate

	for(var/mob/M in A)
		if(has_gravity)
			thunk(M)
		M.update_gravity()

/area/proc/thunk(mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(H.buckled)
			return // Being buckled to something solid keeps you in place.
		if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
			return
		if(H.resting)
			return
		if(H.m_intent == "run")
			H.AdjustStunned(6)
			H.AdjustWeakened(6)
		else
			H.AdjustStunned(3)
			H.AdjustWeakened(3)
		mob << "<span class='notice'>The sudden appearance of gravity makes you fall to the floor!</span>"
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

/area/has_gravity()
	return has_gravity

/area/space/has_gravity()
	return 0

/proc/has_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(A && A.has_gravity())
		return 1
	return 0

/area/proc/shuttle_arrived()
	return TRUE

/area/proc/shuttle_departed()
	return TRUE

/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/hook/startup/proc/setupTeleportLocs()
	for(var/area/AR in GLOB.sortedAreas)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z in using_map.station_levels)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	teleportlocs = sortAssoc(teleportlocs)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in GLOB.sortedAreas)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z in using_map.player_levels)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortAssoc(ghostteleportlocs)

	return 1


/area/proc/move_contents_to(var/area/A, var/turftoleave=null, var/direction = null, placeOnTop = TRUE)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					//You can stay, though.
					if(istype(T,/turf/space))
						refined_src -= T
						refined_trg -= B
						continue moving

					var/turf/X //New Destination Turf

					//Are we doing shuttlework? Just to save another type check later.
					var/shuttlework = 0

					//Shuttle turfs handle their own fancy moving.
					if(istype(T,/turf/simulated/shuttle))
						shuttlework = 1
						var/turf/simulated/shuttle/SS = T
						if(!SS.landed_holder)
							SS.landed_holder = new(null, SS)
						X = SS.landed_holder.land_on(B)

					//Generic non-shuttle turf move.
					else
						var/old_dir1 = T.dir
						var/old_icon_state1 = T.icon_state
						var/old_icon1 = T.icon
						var/old_underlays = T.underlays.Copy()
						var/old_decals = T.decals ? T.decals.Copy() : null

						X = placeOnTop? B.PlaceOnTop(T.type) : B.ChangeTurf(T.type)
						X.setDir(old_dir1)
						X.icon_state = old_icon_state1
						X.icon = old_icon1
						X.copy_overlays(T, TRUE)
						X.underlays = old_underlays
						X.decals = old_decals

					//Move the air from source to dest
					var/turf/simulated/ST = T
					if(istype(ST) && ST.zone)
						var/turf/simulated/SX = X
						if(!SX.air)
							SX.make_air()
						SX.air.copy_from(ST.zone.air)
						ST.zone.remove(ST)

					//Move the objects. Not forceMove because the object isn't "moving" really, it's supposed to be on the "same" turf.
					for(var/obj/O in T)
						O.loc = X
						O.update_light()

					//Move the mobs unless it's an AI eye or other eye type.
					for(var/mob/M in T)
						if(istype(M, /mob/observer/eye)) continue // If we need to check for more mobs, I'll add a variable
						M.loc = X
						if(istype(M, /mob/living))
							var/mob/living/LM = M
							LM.check_shadow() // Need to check their Z-shadow, which is normally done in forceMove().

					if(shuttlework)
						var/turf/simulated/shuttle/SS = T
						SS.landed_holder.leave_turf()
					else if(turftoleave)
						T.ChangeTurf(turftoleave)
					else
						T.ScrapeAway()

					refined_src -= T
					refined_trg -= B
					continue moving


/area/proc/copy_contents_to(var/area/A , var/platingRequired = 0 )
	//Takes: Area. Optional: If it should copy to areas that don't have plating
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	// Does *not* affect gases etc; copied turfs will be changed via ChangeTurf, and the dir, icon, and icon_state copied. All other vars will remain default.

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	var/list/toupdate = new/list()

	var/copiedobjs = list()


	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon
					var/old_overlays = T.overlays.Copy()
					var/old_underlays = T.underlays.Copy()

					if(platingRequired)
						if(istype(B, SSmapping.level_trait(B.z, ZTRAIT_BASETURF)))
							continue moving

					var/turf/X = B
					X.ChangeTurf(T.type)
					X.setDir(old_dir1)
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi
					X.overlays = old_overlays
					X.underlays = old_underlays

					var/list/objs = new/list()
					var/list/newobjs = new/list()
					var/list/mobs = new/list()
					var/list/newmobs = new/list()

					for(var/obj/O in T)

						if(!istype(O,/obj))
							continue

						objs += O


					for(var/obj/O in objs)
						newobjs += DuplicateObject(O , 1)


					for(var/obj/O in newobjs)
						O.loc = X

					for(var/mob/M in T)

						if(!istype(M,/mob) || istype(M, /mob/observer/eye)) continue // If we need to check for more mobs, I'll add a variable
						mobs += M

					for(var/mob/M in mobs)
						newmobs += DuplicateObject(M , 1)

					for(var/mob/M in newmobs)
						M.loc = X

					copiedobjs += newobjs
					copiedobjs += newmobs

//					var/area/AR = X.loc

//					if(AR.dynamic_lighting)
//						X.opacity = !X.opacity
//						X.sd_SetOpacity(!X.opacity)			//TODO: rewrite this code so it's not messed by lighting ~Carn

					toupdate += X

					refined_src -= T
					refined_trg -= B
					continue moving

	if(toupdate.len)
		for(var/turf/simulated/T1 in toupdate)
			air_master.mark_for_update(T1)

	return copiedobjs

// A hook so areas can modify the incoming args
/area/proc/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	return flags
