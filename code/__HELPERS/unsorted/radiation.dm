/**
 * get_all_contents but for radiation
 *
 * global proc for speed
 */
/proc/get_rad_contents(atom/where_at)
	var/list/processing = list(where_at)
	. = list()
	var/i = 0
	var/lim = 1
	var/atom/thing
	while(i < lim)
		thing = processing[++i]
		if(radiation_full_ignore[thing.type])
			continue
		. += thing
		if(thing.rad_flags & RAD_BLOCK_CONTENTS)
			continue
		processing += thing.contents
		lim = processing.len

/**
 * emit pulse of radiation at a certain place with a certain strength
 * global proc for ease of modification
 *
 * @params
 * - source - what's irradiating
 * - intensity - how much
 * - falloff_modifier - 0.5 = goes twice as far, 2 = goes half as far, etc
 * - log - emit game log?
 * - can_contaminate - allow contamination? if null, will default. Contamination is currently disabled.
 * - override_turf - override where
 */
/proc/radiation_pulse(atom/source, intensity, falloff_modifier = RAD_FALLOFF_NORMAL, log, can_contaminate = RAD_CONTAMINATION_DEFAULT)
	return SSradiation.radiation_pulse(source, intensity, falloff_modifier, log, can_contaminate)

/**
 * radiates a whole zlevel
 *
 * implementation doesn't matter to you, the radiation amount does.
 * radiation amount should be sane for the radiation system in question.
 *
 * specifying a turf source is allowed, or just a flat zlevel is allowed;
 * z-only no-turf z radiation is flat.
 */
/proc/z_radiation(turf/source, z, intensity, falloff_modifier = RAD_FALLOFF_ZLEVEL_DEFAULT, log = TRUE, can_contaminate = RAD_ZLEVEL_CONTAMINATION_DEFAULT, z_radiate_flags)
	return SSradiation.z_radiation(source, z, intensity, falloff_modifier, log, can_contaminate, z_radiate_flags)
