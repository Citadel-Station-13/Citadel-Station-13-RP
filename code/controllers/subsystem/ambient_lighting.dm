SUBSYSTEM_DEF(ambient_lighting)
	name = "Ambient Lighting"
	wait = 1
	priority = FIRE_PRIORITY_LIGHTING
	init_order = INIT_ORDER_AMBIENT_LIGHT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // Copied from icon update subsystem.
	// subsystem_flags = SS_NO_INIT

	var/list/queued = list()

/datum/controller/subsystem/ambient_lighting/stat_entry()
	return ..() + " Queue:[length(queued)]"

/datum/controller/subsystem/ambient_lighting/Initialize(start_timeofday)
	fire(FALSE, TRUE)
	return ..()

/datum/controller/subsystem/ambient_lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queued
	var/starlight_enabled = CONFIG_GET(flag/starlight)

	var/needs_ambience
	while (curr.len)
		var/turf/target = curr[curr.len]
		curr.len -= 1

		if (target.is_outside())
			needs_ambience = TURF_IS_DYNAMICALLY_LIT_UNSAFE(target)
			if (!needs_ambience)
				for (var/turf/T in RANGE_TURFS(1, target))
					if(TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
						needs_ambience = TRUE
						break

			if (needs_ambience)
				var/datum/planet/planet = SSplanets.z_to_planet["[target.z]"]
				if (istype(planet))
					if (planet.sun_brightness_modifier)
						planet.update_sunlight()
				else if (starlight_enabled)
					target.set_ambient_light(COLOR_WHITE, 1)
		else if (TURF_IS_AMBIENT_LIT_UNSAFE(target))
			var/datum/planet/planet = SSplanets.z_to_planet["[target.z]"]
			if (istype(planet))
				if (planet.sun_brightness_modifier)
					target.replace_ambient_light(planet.sun_apparent_color, null, planet.sun_apparent_brightness, null)
			else if (starlight_enabled)
				target.replace_ambient_light(COLOR_WHITE, null, 1, null)

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return
