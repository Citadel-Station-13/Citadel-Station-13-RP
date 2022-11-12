/**
 * get_all_contents but for radiation
 */
/atom/proc/get_rad_contents()
	var/list/processing = list(src)
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

/atom/proc/radiation_pulse(intensity, falloff_modifier, log, no_contaminate)
	return SSradiation.radiation_pulse(get_turf(src), src, intensity, falloff_modifier, log, no_contaminate)
