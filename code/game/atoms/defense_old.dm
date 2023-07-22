/**
 * React to being hit by an explosion
 *
 * Should be called through the [EX_ACT] wrapper macro.
 * The wrapper takes care of the [COMSIG_ATOM_EX_ACT] signal.
 * as well as calling [/atom/proc/contents_explosion].
 */
/atom/proc/legacy_ex_act(severity, target)
	set waitfor = FALSE

/atom/proc/emp_act(var/severity)
	// todo: SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_EMP_ACT, severity)

/atom/proc/bullet_act(obj/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

// Called when a blob expands onto the tile the atom occupies.
/atom/proc/blob_act()
	return

/**
 * called when being burned in a fire
 *
 * this is explicitly for ZAS only
 *
 * todo: make params (air, temperature, dt), so this is more generic
 */
/atom/proc/fire_act(datum/gas_mixture/air, temperature, volume)
	return
