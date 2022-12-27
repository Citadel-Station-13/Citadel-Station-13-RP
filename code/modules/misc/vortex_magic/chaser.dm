/proc/vortex_chaser(atom/target, turf/starting, chaser_type = /datum/vortex_chaser, speed, tiles, tile_type)

/**
 * the funny dance chaser
 */
/datum/vortex_chaser
	//! Intrinsics
	/// victim
	var/atom/target
	/// start tile
	var/turf/starting
	/// ticking?
	var/active = FALSE
	/// speed
	var/speed = 2
	/// tiles left
	var/tiles_left = 40

	//! Chasing
	/// current turf
	var/turf/current

	//! Tile Blasts
	#warn instance vars

/datum/vortex_chaser/Destroy()
	if(active)
		end()
	target = null
	current = null
	starting = null
	return ..()

/datum/vortex_chaser/New(atom/target, turf/starting, speed, tiles)
	src.target = target
	src.starting = starting
	if(speed)
		src.speed = speed
	if(tiles)
		src.tiles_left = tiles
	start()

/**
 * computes next tile to move to
 */
/datum/vortex_chaser/proc/compute()

/datum/vortex_chaser/proc/tick()
	var/turf/next = compute()
	if(!next)
		end()
		return
	blast(current)
	current = next

/datum/vortex_chaser/proc/start()
	active = TRUE

/datum/vortex_chaser/proc/end()
	active = FALSE
	if(!QDESTROYING(src))
		qdel(src)

#warn ticking - timer loop

/datum/vortex_chaser/proc/blast(turf/T)

/**
 * default "best fit" algorithm for running people down
 */
/datum/vortex_chaser/auto
	/// current target overtake amount
	var/overtake = 0
	/// max overtake amount
	var/overtake_max = 3
	/// min overtake amount
	var/overtake_min = 1
	/// chance of indirect target
	var/overtake_probability = 0.5

/datum/vortex_chaser/auto/compute()

/**
 * brutal chaser type
 */

