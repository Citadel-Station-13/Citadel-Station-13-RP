/**
 * world sectors
 *
 * the successor of /datum/planet
 * handles effect processing/what not for clusters of zlevels
 *
 * --- time ---
 *
 * time is calculated from realtime as a starting point of days.
 * we would use UNIX time if byond wasn't stupid but alas.
 */
/datum/world_sector
	//? identity
	/// canonical name in code
	var/name = "Unnamed Sector"
	/// canonical description in code
	var/desc = "A poor sector that was neglected and has no description."
	/// our id - must be unique and immnutable once registered!
	var/id
	/// next id
	var/static/id_next = 0

	//? time
	/// do we canonically go off galactic time? this has nothing to do with our actual ticking
	var/use_galactic_time =
	/// seconds in a day
	var/seconds_in_day = HOURS_TO_SECONDS(24)
	/// arbitrary seconds to offset by
	var/seconds_to_offset = 0
	/// seconds into the day that world.time = 0 is. is automatically computed from seconds in day and seconds to offset.
	var/tmp/seconds_at_start
	/// arbitrary days to offset by
	var/days_to_offset = 0
	/// days since 2000 at world.time = 0. automatically computed from days_to_offset and seconds_in_day.
	var/tmp/days_at_start
	/// days in a year
	var/days_in_year = 356
	/// months in year - we will calculate month and moon phase automatically
	var/months_in_year = 12

	//? ticking
	/// flags for what's needing to be ticked
	var/sector_updates = NONE
	#warn impl - daytime update
	#warn impl - weather update

	//? lighting
	/// last applied light color
	var/tmp/light_applied_color
	/// last applied light strength
	var/tmp/light_applied_power

	//? weather
	/// our weather holder - inits into an instance, initially a type
	var/datum/weather_holder/weather_holder
	/// current weather if any just for quick referencing
	var/tmp/datum/weather/weather
	/// how relatively extreme weather is here. WARNING: CHANGE THIS VALUE SPARINGLY OR SO GOD HELP YOU. range: [0, infinity] as multiplier
	var/weather_eccentricity = 1
	/// cached cloud cover from regular cycle/season lighting
	var/tmp/weather_light_covering = 0
	/// cached weather light strength
	var/tmp/weather_light_power = 0
	/// cached weather light color
	var/tmp/weather_light_color = "#ffffff"
	/// cached weather temperatuer adjust
	var/tmp/weather_temp_adjust = 0
	#warn impl / hook / whatever

	//? cycles & seasons
	/// our season holder - inits into an instance, initially a type
	var/datum/season_holder/season_holder = /datum/season_holder/earth
	/// current season - computed at init
	var/tmp/datum/season/season_cached
	/// cycle datums - list of typepaths created in init
	var/list/datum/sector_cycle/cycles = list(
		/datum/sector_cycle/main/day
	)
	/// cached strength of main cycle
	var/tmp/wycle_strength_main = 0
	/// cached strengths of cycles with registration
	var/tmp/list/cycle_strengths
	/// cached cycle light color
	var/tmp/cycle_light_color = "#ffffff"
	/// cached cycle light power
	var/tmp/cycle_light_power = 0
	/// cached cycle temp adjust
	var/tmp/cycle_temp_adjust = 0

	//? atmospherics
	// todo: no gas mixture apply-to-level support yet
	/// our atmosphere datum - holds both our gas string and our *base* temperature
	var/datum/atmosphere/atmosphere = /datum/atmosphere/vacuum
	/// max temperature *adjust* at 100% day/night skew
	var/daynight_temperature_max = 0
	/// min temperature *adjust* at -100% day/night skew
	var/daynight_temperature_min = 0
	/// forced temperature adjust
	var/temperature_adjust = 0
	/// cached current effective temperature (atmosphere, cycles, weather) todo: season temp
	var/temperature_cached
	#warn impl

	//? instance variables
	/// instantiated in world
	var/instantiated = FALSE
	/// current zlevels - intentionally not a world_struct
	var/list/z_indices
	/// registered mobs
	var/list/mob/relevant_mobs
	/// are visuals registered?
	var/visuals_initialized = FALSE
	/// our level group for when multiple levels want the same sector type but not to be in the same sector
	var/level_group
	/// unsimulated planetary walls
	//  todo: make these level border walls instead eventually maybe
	var/list/turf/unsimulated/wall/planetary/level_borders = list()
	/// simulated planetary turfs
	//  todo: no simulated just turf? var/air_status...
	var/list/turf/simulated/floor/level_floors = list()
	#warn setup needs to put this stuff in

	//? visuals
	/// our vis holder, applied to all parallax holders on our zlevel
	var/atom/movable/screen/sector_parallax/render_holder
	/// our tile holder, applied to all outdoor turfs on our zlevel
	var/atom/movable/sector_visuals/tile_holder

/datum/world_sector/New()
	id = "[++id_next]"

//? atmospherics

/datum/world_sector/proc/init_atmos()
	init_atmosphere()
	update_cached_temperature()
	#warn impl

/datum/world_sector/proc/init_atmosphere()
	if(ispath(atmosphere))
		atmosphere = new atmosphere

/datum/world_sector/proc/update_cached_temperature()
	var/old = temperature_cached
	#warn impl
	if(old == temperature_cached)
		return
	update_turf_temperatures()

/datum/world_sector/proc/update_turf_temperatures()
	for(var/turf/unsimulated/wall/planetary/border as anything in level_borders)
		border.set_temperature(temperature_cached)

/datum/world_sector/proc/set_temperature_adjust(val)
	temperature_adjust = val
	update_cached_temperature()

//? sun, moon, sunlight, moonlight

/datum/world_sector/proc/init_moon_phase()

/datum/world_sector/proc/sun_power()

/datum/world_sector/proc/moon_power()

/datum/world_sector/proc/update_light()




#warn impl all

//? cycles

/**
 * inits our cycle datums
 */
/datum/world_sector/proc/init_cycles()
	#warn impl
	#warn check that no more than one main, and main exists if any sync

/**
 * pushes cycle ratios / powers / statuses. doesn't update anything by itself.
 */
/datum/world_sector/proc/update_cycles()
	#warn

//? seasons

/**
 * initializes seasons
 */
/datum/world_sector/proc/init_season()
	if(ispath(season_holder, /datum/season_holder))
		season_holder = new season_holder
	season_cached = compute_season()

/**
 * sees what season we should be
 */
/datum/world_sector/proc/compute_season()
	var/our_ratio = days_at_start % days_in_year
	our_ratio -= season_holder.offset_ratio
	if(our_ratio < 0)
		our_ratio += 1
	for(var/datum/season/S as anything in season_holder.seasons)
		our_ratio -= S.computed_ratio
		if(our_ratio <= 0)
			// gottem
			return S
	CRASH("couldn't compute valid season. is everything set right?")

/**
 * gets season
 */
/datum/world_sector/proc/get_season()
	RETURN_TYPE(/datum/season)
	return season_cached

//? time

/**
 * initializes or resets time system
 */
/datum/world_sector/proc/init_time()
	seconds_at_start = ((world.realtime * 0.1) + seconds_to_offset) % seconds_in_day
	days_at_start = round(((world.realtime * 0.1) / seconds_in_day) + days_to_offset)

/**
 * gets deciseconds into the day
 */
/datum/world_sector/proc/time_of_day()
	. = (seconds_at_start) + (world.time * 0.1)
	if(. > seconds_in_day)
		seconds_at_start -= seconds_in_day
		. -= seconds_in_day
	. *= 10

/**
 * render timestamp for hh:mm:ss
 */
/datum/world_sector/proc/render_time(include_seconds)
	return include_seconds? time2text(time_of_day(), "hh:mm:ss", 0) : time2text(time_of_day(), "hh:mm", 0)

//? zlevels & init

/**
 * inits us with no levels initially
 */
/datum/world_sector/proc/init_empty()
	z_indices = list()
	init()

/**
 * inits us to a set of zlevels
 */
/datum/world_sector/proc/init_levels(list/indices)
	for(var/i in indices)
		if(!add_level(i))
			teardown()
			. = FALSE
			CRASH("Failed to init levels.")
	return TRUE

/**
 * general init
 */
/datum/world_sector/proc/init()
	PROTECTED_PROC(TRUE)
	// 1. time, day, etc
	init_time()
	// 2. compute season
	init_season()
	// 3. init cycles
	init_cycles()
	// 4. init weather
	#warn impl
	// 5. init atmos
	init_atmos()

/**
 * tears down for destruction
 * usually a horrible idea but hey
 */
/datum/world_sector/proc/teardown()
	for(var/i in z_indices)
		remove_level(i)
	#warn impl

/**
 * removes us from a zlevel
 */
/datum/world_sector/proc/remove_level(index)
	#warn impl

/**
 * adds us to a zlevel
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/world_sector/proc/add_level(index)
	#warn impl - check index conflict / dupe

/**
 * returns list of levels
 */
/datum/world_sector/proc/get_levels()
	return z_indices?.Copy() || list()

/**
 * returns if a level is in us
 */
/datum/world_sector/proc/has_level(index)
	return (index in z_indices)

/**
 * returns if a level is at the top
 */
/datum/world_sector/proc/top_level(index)
	ASSERT(index in z_indices)
	var/turf/T = locate(1, 1, index)
	return !T.Above()

//? mobs

/**
 * registers a mob to us - do this when a mob enters our level or we're created on a level
 */
/datum/world_sector/proc/register_mob(mob/M)
	if(!relevant_mob(M))
		return
	M.mob_flags |= MOB_SECTOR_REGISTERED

/**
 * unregisters a mob from us - do this when a mob leaves our level or we're deleted
 */
/datum/world_sector/proc/unregister_mob(mob/M)
	M.mob_flags &= (~MOB_SECTOR_REGISTERED)

/**
 * ensure a mob still has stuff like rendering overlays and whatnot
 */
/datum/world_sector/proc/reassert_mob(mob/M)
	return isliving(M) || isEye(M)

/**
 * checks if a mob is relevant to us
 */
/datum/world_sector/proc/relevant_mob(mob/M)
	return isliving(M)

/mob/onTransitZ(old_z, new_z)
	. = ..()
	var/datum/world_sector/old_sector = SSmapping.sector_by_z(old_z)
	var/datum/world_sector/new_sector = SSmapping.sector_by_z(new_z)
	old_sector?.unregister_mob(src)
	new_sector?.register_mob(src)

/mob/proc/reconsider_sector_relevance()
	var/datum/world_sector/current_sector = SSmapping.sector_by_z(get_z(src))
	if(!current_sector)
		return
	if(current_sector.relevant_mob(src))
		if(mob_flags & MOB_SECTOR_REGISTERED)
			current_sector.reassert_mob(src)
			return
		current_sector.register_mob(src)
	else
		if(!(mob_flags & MOB_SECTOR_REGISTERED))
			return
		current_sector.unregister_mob(src)
