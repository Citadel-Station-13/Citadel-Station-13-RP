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

	//? duration
	#warn impl

	//? temperature
	/// current temperature mod - if temp low/high aren't set we use this
	var/temp_mod = 0
	/// temperature low - uniform random
	var/temp_low
	/// temperature high - uniform random
	var/temp_high

	//? lighting
	#warn impl

	//? fluff
	#warn impl

	//? sounds
	#warn impl

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
	#warn

	//? wind
	/// current wind - if wind low and high aren't set we just use this
	var/wind_str = 0
	/// wind strength in slowdown amount
	var/wind_low
	/// wind strength in slowdown amount
	var/wind_high

	//? misc mechaincs
	#warn impl

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
