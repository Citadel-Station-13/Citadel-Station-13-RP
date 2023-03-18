/**
 * weather datums
 * it's what the name implies
 * instanced per holder for editing purposes
 * try not to allocate anything expensive in here
 *
 * even if these are instanced, we try not to back-reference weather holders.
 * instead, it is provided as an argument in procs.
 * this does incur a speed loss, but is overall better for modularity.
 */
/datum/weather
	abstract_type = /datum/weather
	//? identity
	/// name
	var/name = "unknown weather"
	/// desc - player facing
	var/desc = "you shouldn't see this."
	/// canonical name - overrides name for player facing if set
	var/display_name
	/// transient thing created by admin/debug purposes; delete at end
	var/transient = FALSE
	#warn hook

	//? duration - this is added ontop of transition times.
	/// use gaussian?
	var/duration_gaussian = TRUE
	/// duration high if not gaussian
	var/duration_high
	/// duration low if not gaussian
	var/duration_low
	/// duration center if gaussian
	var/duration_center = 2 MINUTES
	/// duration stddev if gaussian
	var/duration_deviation = 1 MINUTES
	#warn hook

	//? temperature
	/// current temperature mod - if temp low/high aren't set we use this
	var/temp_mod = 0
	/// temperature low - uniform random
	var/temp_low
	/// temperature high - uniform random
	var/temp_high
	#warn hook

	//? lighting
	/// cloud cover - if light cover low/high aren't set we use this. this is ratio of incoming light we block
	var/light_cover = 0
	/// cloud cover
	var/light_cover_low
	/// cloud cover
	var/light_cover_high
	/// intrinsic light power - if light power low/high aren't set we use this. this is how much light we *emit*
	var/light_power = 0
	/// intrinsic light power
	var/light_power_low
	/// intrinsic light power
	var/light_power_high
	/// intrinsic light color - if intrinsic light color left/right aren't set we use this. this is color of light we *emit*
	var/light_color = "#ffffff"
	/// intrinsic light color for interpolation
	var/light_color_left
	/// intrinsic light color for interpolation
	var/light_color_right
	/// color to "bend" incoming light from sector cycles towards with interpolation
	var/light_filter_color = "#ff0000"
	/// color interpolation strength for filtering
	var/light_filter_strength = 0
	#warn hook

	//? sounds
	/// our soundloop - typepath, inits into instance when needed
	var/datum/looping_sound/outdoors_sound
	/// our soundloop - typepath, inits into instance when needed
	var/datum/looping_sound/indoors_sound
	#warn hook

	//? graphics
	/// has tile graphics
	var/tile_graphics = FALSE
	/// if existent, default behavior is to set tile graphics to this
	var/tile_icon = 'icons/screen/weather/tile.dmi'
	/// if existent, default behavior is to set tile graphics to this
	var/tile_state
	/// has particles
	var/particle_graphics = FALSE
	/// if existent, default behavior is to add this particle. can be a particle or typepath, or a list of particles or typepaths.
	var/particle_instances
	#warn hook

	//? wind
	/// current wind - if wind low and high aren't set we just use this
	var/wind_str = 0
	/// wind strength in slowdown amount
	var/wind_low
	/// wind strength in slowdown amount
	var/wind_high

	//? ticking - definitions
	/// do we need to tick at all? if so, set this to delay, and tick() will be called every that much time-ish.
	var/ticks = FALSE
	/// do we need to tick turfs? you must set ticks_turfs_every or ticks_turfs_per if this is set.
	var/ticks_turfs = FALSE
	/// turf tick rate: roughly time for all turfs. overridden by ticks_turfs_per.
	var/ticks_turfs_every
	/// instead of ticking all turfs, instead tick a random turf every. overrides ticks_turfs_every.
	var/ticks_turfs_per
	/// do we need to tick mobs?
	var/ticks_mobs = FALSE
	/// mob tick rate: roughly time per tick for all mobs
	var/ticks_mobs_every = 10 SECONDS
	#warn hook & make sure mobs / turfs get removed on, well, remove.

	//? sky cover
	/// do we obscure sky?
	var/sky_cover = FALSE
	/// obscuration level - if below sector cycle level, anything above us is obscured.
	var/sky_level = SECTOR_CYCLE_LEVEL_DEFAULT_OBSCURE
	/// what the person sees when they look up; this is if we're not blocked.
	var/sky_message = "Some unknown meteorological phenomenom is obscuring your view."
	#warn hook

	//? messages
	/// outdoors messages, key = string, value = weight
	var/list/outdoors_messages
	/// indoors messages, key = string, value = weight
	var/list/indoors_messages
	/// transition messages, key = string, value = weight
	var/list/transition_messages_outdoors
	/// transition messages, key = string, value = weight
	var/list/transition_messages_indoors
	#warn hook

	//? advanced
	/// components to attach; typepaths, gets init'd in start.
	var/list/datum/weather_component/weather_components
	#warn hook

/**
 * what to do on start
 */
/datum/weather/proc/start(datum/weather_holder/holder)

/**
 * what to do on end
 */
/datum/weather/proc/end(datum/weather_holder/holder)

/**
 * called when a mob enters us and on begin for all mobs in sector
 */
/datum/weather/proc/mob_enter(datum/weather_holder/holder, mob/M)

/**
 * called when a mob exits us and on end for all mobs in sector
 */
/datum/weather/proc/mob_exit(datum/weather_holder/holder, mob/M)

#warn impl all

/**
 * called to init blackboard
 *
 * @params
 * * last_data - unimplemented: the last data that was on us before we were switched to another weather.
 */
/datum/weather/proc/tick_init_data(list/last_data)
	return list()

/**
 * called to tick general
 */
/datum/weather/proc/tick(datum/weather_holder/holder)

/**
 * called to tick a mob
 */
/datum/weather/proc/tick_mob(datum/weather_holder/holder, mob/M)

/**
 * called to tick a turf
 */
/datum/weather/proc/tick_turf(datum/weather_holder/holder, turf/T)

#warn hook all

/**
 * checks if we have any visuals whatsoever
 */
/datum/weather/proc/has_visuals()
	return tile_graphics || particle_graphics
