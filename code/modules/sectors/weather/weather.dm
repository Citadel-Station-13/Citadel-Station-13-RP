/**
 * weather datums
 * it's what the name implies
 * instanced per holder for editing purposes
 * try not to allocate anything expensive in here
 */
/datum/weather
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

	//? duration
	#warn impl

	//? transition / procgen
	#warn impl

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
	#warn impl

	//? wind
	/// current wind - if wind low and high aren't set we just use this
	var/wind_str = 0
	/// wind strength in slowdown amount
	var/wind_low
	/// wind strength in slowdown amount
	var/wind_high

	//? ticking
	#warn impl

	//? sky cover
	#warn impl

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

/**
 * what to do on start
 */
/datum/weather/proc/start(datum/world_sector/sector)

/**
 * what to do on end
 */
/datum/weather/proc/end(datum/world_sector/sector)

/**
 * called when a mob enters us and on begin for all mobs in sector
 */
/datum/weather/proc/mob_enter(mob/M)

/**
 * called when a mob exits us and on end for all mobs in sector
 */
/datum/weather/proc/mob_exit(mob/M)


#warn impl all

/**
 * checks if we have any visuals whatsoever
 */
/datum/weather/proc/has_visuals()
	return tile_graphics || particle_graphics
