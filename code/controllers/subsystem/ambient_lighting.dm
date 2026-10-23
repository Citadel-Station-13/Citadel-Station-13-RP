SUBSYSTEM_DEF(ambient_lighting)
	name = "Ambient Lighting"
	wait = 1
	dependencies = list(
		/datum/controller/subsystem/lighting,
	)
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // Copied from icon update subsystem.
	// subsystem_flags = SS_NO_INIT

	var/list/queued = list()

/datum/controller/subsystem/ambient_lighting/stat_entry()
	return ..() + " Queue:[length(queued)]"

/datum/controller/subsystem/ambient_lighting/Initialize(start_timeofday)
	fire(FALSE, TRUE)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/ambient_lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queued
	var/starlight_enabled = CONFIG_GET(flag/starlight)

	var/needs_ambience
	while (curr.len)
		var/turf/target = curr[curr.len]
		curr.len -= 1

		// is turf outside?
		if (target.is_outside())
			// is it on a z-level with a sector, or outside with starlight?
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
						// current is set immediately when the update starts
						// on the planet so this is safe
						target.set_ambient_light(
							planet.sun_lighting_current_color,
							planet.sun_lighting_current_brightness,
						)
				else if (starlight_enabled)
					target.set_ambient_light(COLOR_WHITE, 1)
		else
			// no it's not, get rid of it
			target.clear_ambient_light()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return
