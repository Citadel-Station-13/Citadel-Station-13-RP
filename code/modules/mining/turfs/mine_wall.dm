/**
 * mineral rock turfs
 * usually what contains the excavation aspect of mining
 */
/turf/simulated/mineral/wall
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	smoothing_flags = SMOOTH_CUSTOM
	baseturfs = /turf/simulated/mineral/floor
	density = TRUE
	opacity = TRUE

	//! ores
	/// the ore we contain, if any. can be a list. if list, associate to amounts.
	VAR_PRIVATE/list/ore
	/// the amount of ore we have left. do not set this if you are using multi-ores; use the list in that case!
	VAR_PRIVATE/ore_amount
	/// cached scanner image
	VAR_PRIVATE/image/scanner_image_cached
	/// current scanner overlay
	var/atom/movable/ore_overlay/current_scanner_overlay

	//! artifacts

	//! excavation
	/// exacavation hardness
	var/hardness = EXCAVATION_HARDNESS_DEFAULT
	/// excavation level
	var/excavation_level = 0
	/// max excavation level
	var/excavation_depth = EXCAVATION_DEPTH_DEFAULT

	#warn manual ore setting system
	#warn sonar is too unoptimized; need a faster way for this

	#warn hardness modifiers by ore

/turf/simulated/mineral/wall/proc/set_ore(id, amount = 25)
	ore = id
	ore_amount = amount
	update_ore()

/turf/simulated/mineral/wall/proc/set_ore_multi(list/ores)
	ore = ores.Copy()
	ore_amount = null
	update_ore()

/turf/simulated/mineral/wall/proc/update_ore()
	scanner_image_cached = null
	#warn impl

/**
 * returns amount of ore left of a certain id, or all ids
 */
/turf/simulated/mineral/wall/proc/ore_left(id)
	if(!id)
		if(islist(ore))
			. = 0
			for(var/id in ore)
				. += ore[id]
			return
		return ore_amount || 0
	// specific id
	if(islist(ore))
		return ore[id] || 0
	return (ore == id)? (ore_amount || 0) : 0

/turf/simulated/mineral/wall/proc/drop_ore(atom/newLoc = src, amount = ore_left())

#warn impl

/turf/simulated/mineral/wall/proc/scanner_image()
	if(!scanner_image_cached)
		generate_scanner_image()
	return scanner_image()

/turf/simulated/mineral/wall/proc/generate_scanner_image()
	scanner_image_cached = null

	#warn impl

/turf/simulated/mineral/wall/mine_functionality()
	return MINE_CAN_EXCAVATE | MINE_CAN_WEAKEN

/turf/simulated/mineral/wall/mine_excavate(depth, hardness, flags)

/turf/simulated/mineral/wall/mine_weaken(hardness, strength)

#warn impl

/turf/simulated/mineral/wall/proc/show_ore_overlay(time)
	#warn add or refresh
