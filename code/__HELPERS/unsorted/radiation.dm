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
		thing = pprocessing[++i]
		if(radiation_full_ignore[thing.type])
			continue
		. += thing
		if((thing.rad_flags & RAD_PROTECT_CONTENTS) || (SEND_SIGNAL(thing, COMSIG_ATOM_RAD_PROBE) & COMPONENT_BLOCK_RADIATION))
			continue
		processing += thing.contents
		lim = processing.len
