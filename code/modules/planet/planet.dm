// This holds information about a specific 'planetside' area, such as its time, weather, etc.  This will most likely be used to model Sif,
// but away missions may also have use for this.

// todo: /datum/sector
/datum/planet
	var/name = "a rock"
	var/desc = "Someone neglected to write a nice description for this poor rock."

	var/datum/time/current_time = new() // Holds the current time for sun positioning.  Note that we assume day and night is the same length because simplicity.
	var/sun_process_interval = 1 HOUR
	var/sun_last_process = null // world.time

	var/datum/weather_holder/weather_holder

	// todo: KILL THIS WITH FIRE
	var/list/expected_z_levels = list()

	var/list/turf/simulated/floor/planet_floors = list()
	var/list/turf/unsimulated/wall/planetary/planet_walls = list()

	var/needs_work = 0 // Bitflags to signal to the planet controller these need (properly deferrable) work. Flags defined in controller.

	var/sun_name = "the sun" // For flavor.

	var/moon_name = null // Purely for flavor. Null means no moon exists.
	var/moon_phase = null // Set if above is defined.

	//* Sunlight *//

	/// 0 means midnight, 1 means noon.
	var/sun_position = 0
	/// This a multiplier used to apply to the brightness of ambient lighting.  0.3 means 30% of the brightness of the sun.
	var/sun_brightness_modifier = 0.5

	#warn impl
	/// Set when we enqueue an update.
	/// * will always be set before current
	var/sun_lighting_wanted_color
	/// Set when we enqueue an update.
	/// * will always be set before current
	var/sun_lighting_wanted_brightness
	/// Set when we perform an update
	var/sun_lighting_current_color
	/// Set when we perform an update
	var/sun_lighting_current_brightness
	/// Is sunlight currently updating? Do not begin another ambient lighting update if so.
	/// * A global lock is used as well, but this keeps us from waiting on it
	///   if our own lock is already held, as our locking system is far more efficient
	///   when it comes to handling too many calls.
	var/sun_lighting_update_running = FALSE
	/// Has sunlight been modified and requires an update?
	var/sun_lighting_update_dirty = FALSE

/datum/planet/New()
	..()
	if(isnull(weather_holder))
		weather_holder = new(src)
	else if(ispath(weather_holder))
		weather_holder = new weather_holder(src)
	current_time = current_time.make_random_time()
	if(moon_name)
		moon_phase = pick(list(
			MOON_PHASE_NEW_MOON,
			MOON_PHASE_WAXING_CRESCENT,
			MOON_PHASE_FIRST_QUARTER,
			MOON_PHASE_WAXING_GIBBOUS,
			MOON_PHASE_FULL_MOON,
			MOON_PHASE_WANING_GIBBOUS,
			MOON_PHASE_LAST_QUARTER,
			MOON_PHASE_WANING_CRESCENT
			))
	update_sun()

/datum/planet/process(delta_time, last_fire)
	if(current_time)
		var/difference = world.time - last_fire
		current_time = current_time.add_seconds((difference / 10) * PLANET_TIME_MODIFIER)
	update_weather() // We update this first, because some weather types decease the brightness of the sun.
	if(sun_last_process <= world.time - sun_process_interval)
		update_sun()

// This changes the position of the sun on the planet.
/datum/planet/proc/update_sun()
	sun_last_process = world.time

/datum/planet/proc/update_weather()
	if(weather_holder)
		weather_holder.process()

/datum/planet/proc/set_sun_lighting(new_brightness, new_color)
	sun_lighting_wanted_color = new_color
	sun_lighting_wanted_brightness = new_brightness
	sun_lighting_update_dirty = TRUE

/**
 * Immediately runs a sunlight udpate.
 * * Only one of these may run, globally, at a time.
 * * Only one of these may be *enqueued or running*, on a planet, at a time.
 */
/datum/planet/proc/update_sun_lighting()
	if(sun_lighting_update_running)
		return
	sun_lighting_update_running = TRUE

	var/ran_times = 0
	while(sun_lighting_update_dirty)
		if(ran_times > 10)
			stack_trace("ran loop too many times; stop boiling the planet with lighting updates!")
			break
		sun_lighting_update_dirty = FALSE
		update_sun_lighting_impl()

	sun_lighting_update_running = FALSE

/datum/planet/proc/update_sun_lighting_impl()
	if(sun_lighting_current_brightness == sun_lighting_wanted_brightness && \
		sun_lighting_current_color == sun_lighting_wanted_color)
		return

	var/current_color = sun_lighting_current_color
	var/current_brightness = sun_lighting_current_brightness
	var/wanted_color = sun_lighting_wanted_color
	var/wanted_brightness = sun_lighting_wanted_brightness

	sun_lighting_wanted_brightness = sun_lighting_current_brightness
	sun_lighting_wanted_color = sun_lighting_current_color

	for(var/turf/simulated/T as anything in planet_floors)
		T.replace_ambient_light(
			current_color,
			wanted_color,
			current_brightness,
			wanted_brightness,
		)
		CHECK_TICK
