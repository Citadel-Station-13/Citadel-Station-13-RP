// TODO: put into SSspatial_effects
//TODO: Flash range does nothing currently

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

/proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		LEGACY_EX_ACT(tile, 2, null)
