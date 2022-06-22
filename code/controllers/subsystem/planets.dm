SUBSYSTEM_DEF(planets)
	name = "Planets"
	init_order = INIT_ORDER_PLANETS
	priority = FIRE_PRIORITY_PLANETS
	wait = 2 SECONDS
	subsystem_flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/static/list/new_outdoor_turfs = list()
	var/static/list/new_outdoor_walls = list()

	var/static/list/planets = list()
	var/static/list/z_to_planet = list()

	var/static/list/currentrun = list()

	var/static/list/needs_sun_update = list()
	var/static/list/needs_temp_update = list()

/datum/controller/subsystem/planets/Initialize(timeofday)
	admin_notice("<span class='danger'>Initializing planetary weather.</span>", R_DEBUG)
	createPlanets()
	allocateTurfs(TRUE)
	return ..()

/datum/controller/subsystem/planets/proc/createPlanets()
	var/list/planet_datums = GLOB.using_map.planet_datums_to_make
	for(var/P in planet_datums)
		var/datum/planet/NP = new P()
		planets.Add(NP)
		for(var/Z in NP.expected_z_levels)
			if(Z > z_to_planet.len)
				z_to_planet.len = Z
			if(z_to_planet[Z])
				admin_notice("<span class='danger'>Z[Z] is shared by more than one planet!</span>", R_DEBUG)
				continue
			z_to_planet[Z] = NP

/datum/controller/subsystem/planets/proc/addTurf(turf/T)
	if(T.turf_flags & (TURF_PLANET_QUEUED | TURF_PLANET_REGISTERED))
		return
	T.turf_flags |= TURF_PLANET_QUEUED
	new_outdoor_turfs += T

/datum/controller/subsystem/planets/proc/addWall(turf/T)
	if(T.turf_flags & (TURF_PLANET_QUEUED | TURF_PLANET_REGISTERED))
		return
	T.turf_flags |= TURF_PLANET_QUEUED
	new_outdoor_walls += T

/datum/controller/subsystem/planets/proc/removeTurf(turf/T)
	new_outdoor_turfs -= T
	T.turf_flags &= ~(TURF_PLANET_QUEUED | TURF_PLANET_REGISTERED)
	if(z_to_planet.len >= T.z)
		var/datum/planet/P = z_to_planet[T.z]
		if(!P)
			return
		P.planet_floors -= T
		T.vis_contents -= P.weather_holder.visuals
		T.vis_contents -= P.weather_holder.special_visuals

/datum/controller/subsystem/planets/proc/removeWall(turf/T)
	new_outdoor_walls -= T
	T.turf_flags &= ~(TURF_PLANET_QUEUED | TURF_PLANET_REGISTERED)
	if(z_to_planet.len >= T.z)
		var/datum/planet/P = z_to_planet[T.z]
		if(!P)
			return
		P.planet_walls -= T
		T.vis_contents -= P.weather_holder.visuals
		T.vis_contents -= P.weather_holder.special_visuals

/datum/controller/subsystem/planets/proc/allocateTurfs(initial)
	// if initial we're going to do optimizations
	var/planet_z_count = z_to_planet.len
	if(initial)
		// make sure no duplicates are there
		for(var/turf/simulated/S in new_outdoor_turfs)
			S.turf_flags &= ~TURF_PLANET_QUEUED
			S.turf_flags |= TURF_PLANET_REGISTERED
			if(planet_z_count < S.z)
				continue
			var/datum/planet/P = z_to_planet[S.z]
			if(!P)
				continue
			P.planet_floors += S
			S.vis_contents |= P.weather_holder.visuals
			S.vis_contents |= P.weather_holder.special_visuals
			CHECK_TICK
		for(var/turf/unsimulated/wall/planetary/S in new_outdoor_walls)
			S.turf_flags &= ~TURF_PLANET_QUEUED
			S.turf_flags |= TURF_PLANET_REGISTERED
			if(planet_z_count < S.z)
				continue
			var/datum/planet/P = z_to_planet[S.z]
			if(!P)
				continue
			P.planet_walls += S
			CHECK_TICK
		new_outdoor_turfs = list()
		new_outdoor_walls = list()
		return
	var/list/curr = new_outdoor_turfs
	while(curr.len)
		var/turf/simulated/S = curr[curr.len]
		S.turf_flags &= ~TURF_PLANET_QUEUED
		S.turf_flags |= TURF_PLANET_REGISTERED
		curr.len--
		if(!istype(S))
			continue
		if(planet_z_count < S.z)
			continue
		var/datum/planet/P = z_to_planet[S.z]
		if(!P)
			continue
		P.planet_floors += S
		S.vis_contents |= P.weather_holder.visuals
		S.vis_contents |= P.weather_holder.special_visuals
		if(MC_TICK_CHECK)
			return
	curr = new_outdoor_walls
	while(curr.len)
		var/turf/unsimulated/wall/planetary/S = curr[curr.len]
		S.turf_flags &= ~TURF_PLANET_QUEUED
		S.turf_flags |= TURF_PLANET_REGISTERED
		curr.len--
		if(!istype(S))
			continue
		if(planet_z_count < S.z)
			continue
		var/datum/planet/P = z_to_planet[S.z]
		if(!P)
			continue
		P.planet_walls += S
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/planets/fire(resumed = 0)
	if(new_outdoor_turfs.len || new_outdoor_walls.len)
		allocateTurfs()

	if(!resumed)
		src.currentrun = planets.Copy()

	var/list/needs_sun_update = src.needs_sun_update
	while(needs_sun_update.len)
		var/datum/planet/P = needs_sun_update[needs_sun_update.len]
		needs_sun_update.len--
		updateSunlight(P)
		if(MC_TICK_CHECK)
			return

	var/list/needs_temp_update = src.needs_temp_update
	while(needs_temp_update.len)
		var/datum/planet/P = needs_temp_update[needs_temp_update.len]
		needs_temp_update.len--
		updateTemp(P)
		if(MC_TICK_CHECK)
			return

	var/list/currentrun = src.currentrun
	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag * 0.1) : (wait * 0.1)
	while(currentrun.len)
		var/datum/planet/P = currentrun[currentrun.len]
		currentrun.len--

		P.process(dt, last_fire)

		//Sun light needs changing
		if(P.needs_work & PLANET_PROCESS_SUN)
			P.needs_work &= ~PLANET_PROCESS_SUN
			needs_sun_update |= P

		//Temperature needs updating
		if(P.needs_work & PLANET_PROCESS_TEMP)
			P.needs_work &= ~PLANET_PROCESS_TEMP
			needs_temp_update |= P

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/planets/proc/updateSunlight(var/datum/planet/P)
	// Remove old value from corners
	var/list/sunlit_corners = P.sunlit_corners
	var/old_lum_r = -P.sun["lum_r"]
	var/old_lum_g = -P.sun["lum_g"]
	var/old_lum_b = -P.sun["lum_b"]
	if(old_lum_r || old_lum_g || old_lum_b)
		for(var/C in sunlit_corners)
			var/datum/lighting_corner/LC = C
			LC.update_lumcount(old_lum_r, old_lum_g, old_lum_b)
			CHECK_TICK
	sunlit_corners.Cut()

	// Calculate new values to apply
	var/new_brightness = P.sun["brightness"]
	var/new_color = P.sun["color"]
	var/lum_r = new_brightness * GetRedPart  (new_color) / 255
	var/lum_g = new_brightness * GetGreenPart(new_color) / 255
	var/lum_b = new_brightness * GetBluePart (new_color) / 255
	var/static/update_gen = -1 // Used to prevent double-processing corners. Otherwise would happen when looping over adjacent turfs.
	for(var/turf/simulated/T as anything in P.planet_floors)
		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()
		for(var/C in list(T.lc_bottomleft, T.lc_bottomright, T.lc_topleft, T.lc_topright))
			var/datum/lighting_corner/LC = C
			if(LC.update_gen != update_gen && LC.active)
				sunlit_corners += LC
				LC.update_gen = update_gen
				LC.update_lumcount(lum_r, lum_g, lum_b)
		CHECK_TICK
	update_gen--
	P.sun["lum_r"] = lum_r
	P.sun["lum_g"] = lum_g
	P.sun["lum_b"] = lum_b

/datum/controller/subsystem/planets/proc/updateTemp(var/datum/planet/P)
	//Set new temperatures
	for(var/W in P.planet_walls)
		var/turf/unsimulated/wall/planetary/wall = W
		wall.set_temperature(P.weather_holder.temperature)
		CHECK_TICK

/datum/controller/subsystem/planets/proc/weatherDisco()
	var/count = 100000
	while(count > 0)
		count--
		for(var/planet in planets)
			var/datum/planet/P = planet
			if(P.weather_holder)
				P.weather_holder.change_weather(pick(P.weather_holder.allowed_weather_types))
		sleep(3)
