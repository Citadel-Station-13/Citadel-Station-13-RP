
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
