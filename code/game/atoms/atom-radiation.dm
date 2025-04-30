/**
 * called when we're hit by a radiation wave
 *
 * * this is only called directly on turfs
 * * this is also called directly if an outgoing pulse is shielded by something, so it hits everything inside it instead
 * * for any other atom on turf, you need /datum/component/radiation_listener
 * * /datum/element/z_radiation_listener is needed if you want to listen to z-wide and other high-gain rad pulses
 */
/atom/proc/rad_act(strength, datum/radiation_wave/wave)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_RAD_ACT, strength)

/**
 * called when we're hit by z radiation
 */
/atom/proc/z_rad_act(strength)
	SHOULD_CALL_PARENT(TRUE)
	rad_act(strength)

/atom/proc/add_rad_block_contents(source)
	ADD_TRAIT(src, TRAIT_ATOM_RAD_BLOCK_CONTENTS, source)
	rad_flags |= RAD_BLOCK_CONTENTS

/atom/proc/remove_rad_block_contents(source)
	REMOVE_TRAIT(src, TRAIT_ATOM_RAD_BLOCK_CONTENTS, source)
	if(!HAS_TRAIT(src, TRAIT_ATOM_RAD_BLOCK_CONTENTS))
		rad_flags &= ~RAD_BLOCK_CONTENTS

/atom/proc/clean_radiation(str, mul, cheap)
	var/datum/component/radioactive/RA = GetComponent(/datum/component/radioactive)
	RA?.clean(str, mul)
