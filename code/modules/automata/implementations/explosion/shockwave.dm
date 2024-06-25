//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * @params
 * * epicenter - center
 * * power - a number for power, or a /datum/explosion_preset path
 * * falloff_exp - exponential falloff factor
 * * falloff_lin - linear falloff factor
 * * damage_multipliers - DAMAGE_CLASSIFIER_* associated to multipliers to use
 * * make_sound - automatically make a 'boom'
 * * shake_screen - automatically screenshake people around based on power
 */
/proc/explosion_shockwave(turf/epicenter, power, falloff_exp, falloff_lin, list/damage_multipliers, make_sound = TRUE, shake_screen = TRUE)
	#warn impl

/*
/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, shaped)
	if(isnull(epicenter))
		return
	var/multi_z_scalar = config_legacy.multi_z_explosion_scalar
	spawn(0)
		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return

		// Handles recursive propagation of explosions.
		if(z_transfer && multi_z_scalar)
			var/adj_dev   = max(0, (multi_z_scalar * devastation_range) - (shaped ? 2 : 0) )
			var/adj_heavy = max(0, (multi_z_scalar * heavy_impact_range) - (shaped ? 2 : 0) )
			var/adj_light = max(0, (multi_z_scalar * light_impact_range) - (shaped ? 2 : 0) )
			var/adj_flash = max(0, (multi_z_scalar * flash_range) - (shaped ? 2 : 0) )


			if(adj_dev > 0 || adj_heavy > 0)
				if(z_transfer & UP)
					explosion(epicenter.above(), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, UP, shaped)
				if(z_transfer & DOWN)
					explosion(epicenter.below(), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, DOWN, shaped)

		var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)

		// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
		// Stereo users will also hear the direction of the explosion!
		// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
		// 3/7/14 will calculate to 80 + 35
		var/far_dist = 0
		far_dist += heavy_impact_range * 15
		far_dist += devastation_range * 10
		var/frequency = get_rand_frequency()
		var/creaking_explosion = FALSE
		var/on_station = SSmapping.level_trait(epicenter.z, LEGACY_LEVEL_STATION)
		if(prob(devastation_range*30+heavy_impact_range*5) && on_station) // Huge explosions are near guaranteed to make the station creak and whine, smaller ones might.
			creaking_explosion = TRUE // prob over 100 always returns true
		var/far_volume = clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
		for(var/mob/M in GLOB.player_list)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			if(M.z == epicenter.z)
				// If inside the blast radius + world.view - 2
				if(dist <= round(max_range + world.view - 2, 1))
					M.playsound_local(epicenter, get_sfx(SFX_ALIAS_EXPLOSION), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
				else if(dist <= far_dist)
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					if(creaking_explosion)
						M.playsound_local(epicenter, list('sound/soundbytes/effects/explosion/explosioncreak1.ogg','sound/soundbytes/effects/explosion/explosioncreak2.ogg'), far_volume, 1, frequency, falloff = 2)
					else
						M.playsound_local(epicenter, 'sound/soundbytes/effects/explosion/explosionfar.ogg', far_volume, 1, frequency, falloff = 2)

				var/close = range(world.view+round(devastation_range,1), epicenter)
				if(!(M in close))
					// check if the mob can hear
					if(M.ear_deaf <= 0 || !M.ear_deaf)
						if(!istype(M.loc,/turf/space))
							if(creaking_explosion)
								if(prob(65))
									SEND_SOUND(M, sound('sound/soundbytes/effects/explosion/explosioncreak1.ogg'))
								else
									SEND_SOUND(M, sound('sound/soundbytes/effects/explosion/explosioncreak2.ogg'))
							else
								SEND_SOUND(M, sound('sound/soundbytes/effects/explosion/explosionfar.ogg'))

				if(creaking_explosion)
					addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, playsound_local), epicenter, null, rand(25, 40), 1, frequency, null, null, FALSE, 'sound/effects/creak1.ogg', null, null, null, null, 0), 5 SECONDS)
		if(adminlog)
			message_admins("Explosion with [shaped ? "shaped" : "non-shaped"] size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with [shaped ? "shaped" : "non-shaped"] size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

		var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range
		var/powernet_rebuild_was_deferred_already = defer_powernet_rebuild
		// Large enough explosion. For performance reasons, powernets will be rebuilt manually
		if(!defer_powernet_rebuild && (approximate_intensity > 25))
			defer_powernet_rebuild = 1

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x0 = epicenter.x
		var/y0 = epicenter.y
		var/z0 = epicenter.z
		if(config_legacy.use_recursive_explosions)
			var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
			explosion_rec(epicenter, power, shaped)
		else
			for(var/turf/T in trange(max_range, epicenter))
				var/dist = sqrt((T.x - x0)**2 + (T.y - y0)**2)

				if(dist < devastation_range)		dist = 1
				else if(dist < heavy_impact_range)	dist = 2
				else if(dist < light_impact_range)	dist = 3
				else								continue

				if(!T)
					T = locate(x0,y0,z0)
				for(var/atom/movable/AM as anything in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					if(AM.atom_flags & ATOM_ABSTRACT)
						continue
					LEGACY_EX_ACT(AM, dist, null)

				LEGACY_EX_ACT(T, dist, null)

		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(GLOB.Debug2)
			world.log << "## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds."

		//Machines which report explosions.
		for(var/i,i<=doppler_arrays.len,i++)
			var/obj/machinery/doppler_array/Array = doppler_arrays[i]
			if(Array)
				Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,took)
		sleep(8)

		if(!powernet_rebuild_was_deferred_already && defer_powernet_rebuild)
			SSmachines.makepowernets()
			defer_powernet_rebuild = 0
	return 1
*/

/**
 * continuous explosions
 */
/datum/automata/explosion/shockwave
	/// origin turfs, associated to powers
	var/list/origins

	//* config *//

	/// multiply to power per step traveled
	var/falloff_exp
	/// subtract to power per step traveled
	var/falloff_lin
	/// how resistant we are to being blocked
	/// if truthy (not zero, or null), we multiply the actual block amount by this
	///
	/// * this is not public on purpose, because
	/// * this is **INSANELY** powerful. Don't use it without a good reason.
	var/bypass_factor
	/// maximum iterations
	var/max_iterations
	/// power at which we drop a turf
	var/considered_dead
	/// initial edges
	var/list/edges_initial

	//* processing variables *//

	/// processed turfs, assoc list to power. makes sure we don't fold in on ourselves.
	var/list/processed
	/// current edges associated to powers
	var/list/edges

/**
 * @params
 * * epicenter - a turf, or a list of turfs associated to powers
 * * power - power on epicenter, or null if epicenter is an associative list
 * * falloff_exp - multiplier to power per iteration. 0 to 1, inclusive
 * * falloff_lin - subtractor to power per iteration. 0 to infinity, inclusive
 * * max_iterations - maximum expansions. not exactly the same as a range variable but somewhat close. 0 to 1000, inclusive.
 * * considered_dead - power below this value is dropped immediately.
 */
/datum/automata/explosion/shockwave/setup(turf/epicenter, power, falloff_exp, falloff_lin, max_iterations = 1000, considered_dead = EXPLOSION_POWER_DROPPED)
	// clamped
	src.max_iterations = max_iterations
	src.considered_dead = considered_dead
	src.falloff_exp = falloff_exp
	src.falloff_lin = falloff_lin
	// setup edges
	src.edges_initial = islist(epicenter)? epicenter : list((epicenter) = power)
	return ..()

/datum/automata/explosion/shockwave/init()
	// check config
	max_iterations = clamp(max_iterations, 0, 1000)
	considered_dead = clamp(considered_dead, 0, INFINITY)
	bypass_factor = clamp(bypass_factor, 0, 1)
	falloff_exp = clamp(falloff_exp, 0, 1)
	falloff_lin = clamp(falloff_lin, 0, INFINITY)
	// init processing vars
	iteration = 0
	processed = list()
	edges = edges_initial.Copy()
	return ..()

/datum/automata/explosion/shockwave/tick()
	/**
	 * silicons' dumb and slow and monolithic explosion bullshit follows:
	 *
	 * see everyone wants explosions but no one thinks about how to do the spread
	 * there's 3 simple ways
	 *
	 * * diamond shaped; only spread in cardinals. this is easiest, but looks and feels bad (imo) as the game isn't diamond shaped.
	 * * circle shaped; this is how tg/citmain/citrp does it. this looks the best, but doing this is annoyingly difficult
	 * * square shaped: do substeps to enforce semi-square-ness. high overhead. imperfect due to the tiles already being dampened by cardinals
	 *   (unless you go CM route and make diagonal walls matter; which sucks because it's shit UX to see that diagonal wall segments block sight)
	 *
	 * we do square shaped.
	 *
	 * we process edges cardinally, then gather diagonals
	 * on diagonal step, if one thing has more than one non-opposing direction on it,
	 * we know it's a diagonal and will process it before the next step.
	 *
	 * that said, diagonals are extraordinarily high-overhead due to needing far more computations than cardinals.
	 */

	// cleanup old acting
	cleanup_turfs_acting()

	// prep next
	var/list/edges_next = list()
	var/list/edges_next_dirs = list()
	// cache current for speed
	var/list/edges = src.edges
	// cache config for speed
	var/power_considered_dead = src.considered_dead
	var/max_iterations = src.max_iterations
	var/falloff_exp = src.falloff_exp
	var/falloff_lin = src.falloff_lin

	// we're going to be a more simple this time around
	// instead of checking bitfields every time,
	// we're just going to check all 4 directions per edge turf
	// this is pretty terrible but honestly i don't really care anymore
	// i'm tired of writing undebuggable code so now i'll just write unreadable code lol

	// first, process edges cardinally
	for(var/i in 1 to length(edges))
		var/turf/T = edges[i]
		if(!T)
			// T can be null due to diagonal step patching a turf out of next list.
			continue
		var/power = edges[T]

		var/returned = explode_turf(T, power)
		if(bypass_factor)
			returned = power - (power - returned) * bypass_factor

		processed[T] = returned
		if(returned <= considered_dead)
			continue

		// sorry did i say i wouldn't abuse defines
		// lmfao i lied
		//
		// DIR = dir
		// POWER = propagating power
		var/turf/marking
		var/marking_existing_power
#define CARDINAL_MARK(DIR, POWER) \
	marking = get_step(T, DIR); \
	if(marking) { \
		marking_existing_power = processed[marking]; \
		if(marking_existing_power < POWER) { \
			edges_next[marking] = max(edges_next[marking], POWER); \
			edges_next_dirs[marking] |= DIR; \
		} \
	}
		CARDINAL_MARK(NORTH, returned)
		CARDINAL_MARK(SOUTH, returned)
		CARDINAL_MARK(EAST, returned)
		CARDINAL_MARK(WEST, returned)
#undef CARDINAL_MARK
		// i'm not sorry at all

	// then, process diagonal fills
	for(var/i in 1 to length(edges_next_dirs))
		var/turf/T = edges_next_dirs[i]
		var/dirs = edges_next_dirs[T]

		// check if it's a diagonal expansion
		if(!((dirs & (EAST|WEST)) && (dirs & (NORTH|SOUTH))))
			continue

		// we'll handle this one, not next cycle
		edges_next -= T
		// but also put us on current cycle for acting automata on turfs
		edges[T] = power

		var/power = edges_next[T]
		var/returned = explode_turf(T, power)
		if(bypass_factor)
			returned = power - (power - returned) * bypass_factor

		processed[T] = returned
		if(returned <= considered_dead)
			continue

		// diagonal
		var/turf/marking
		var/marking_existing_power
#define DIAGONAL_MARK(DIR, POWER) \
	marking = get_step(T, DIR); \
	if(marking) { \
		marking_existing_power = processed[marking]; \
		if(marking_existing_power < POWER) { \
			edges_next[marking] = max(edges_next[marking], POWER); \
			edges_next_dirs[marking] |= DIR; \
		} \
	}
		DIAGONAL_MARK(NORTH, returned)
		DIAGONAL_MARK(SOUTH, returned)
		DIAGONAL_MARK(EAST, returned)
		DIAGONAL_MARK(WEST, returned)
#undef DIAGONAL_MARK

	// swap edges/next
	src.edges = edges_next
	// finish iteration
	. = ..()
	// check completion
	if(!length(src.edges))
		stop(TRUE)

GLOBAL_DATUM(active_shockwave_explosion_test, /datum/automata/explosion/shockwave)

/proc/shockwave_explosion_test(turf/T, power, falloff_exp, falloff_lin, max_iterations, considered_dead, falloff_per_dense = 5)
	var/datum/automata/explosion/shockwave/wave = new
	wave.setup(T, power, falloff_exp, falloff_lin, max_iterations, considered_dead)
	wave.falloff_per_dense = falloff_per_dense
	wave.start()

/datum/automata/explosion/shockwave/debug
	var/list/affected = list()
	var/falloff_per_dense = 5

/datum/automata/explosion/shockwave/init()
	if(GLOB.active_shockwave_explosion_test)
		qdel(GLOB.active_shockwave_explosion_test)
	return ..()

/datum/automata/explosion/shockwave/cleanup()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(erase_maptext_on_turfs), affected), 5 SECONDS)
	affected = null

/datum/automata/explosion/shockwave/debug/explode_turf(turf/tile, power)
	affected[tile] = TRUE
	tile.maptext = MAPTEXT_CENTER("[power]")
	tile.maptext_y = 16

	var/returned = power
	if(tile.density)
		returned -= falloff_per_dense
	for(var/obj/O in tile)
		if(O.density)
			returned -= falloff_per_dense
	return max(0, returned)

/datum/automata/explosion/shockwave/debug/explode_crossed_movable(atom/movable/AM, power)
	return
