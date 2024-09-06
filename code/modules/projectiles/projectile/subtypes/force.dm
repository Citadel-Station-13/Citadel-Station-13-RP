/obj/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ice_1"
	damage_force = 20
	damage_flag = ARMOR_ENERGY

	combustion = FALSE

/obj/projectile/forcebolt/strong
	name = "force bolt"

/obj/projectile/forcebolt/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(ismovable(target))
		var/atom/movable/movable_target = target
		var/throwdir = get_dir(firer,target)
		movable_target.throw_at_old(get_edge_target_turf(target, throwdir),10,10)

/*
/obj/projectile/forcebolt/strong/on_hit(var/atom/target, var/blocked = 0)

	// NONE OF THIS WORKS. DO NOT USE.
	var/throwdir = null

	for(var/mob/M in hearers(2, src))
		if(M.loc != src.loc)
			throwdir = get_dir(src,target)
			M.throw_at_old(get_edge_target_turf(M, throwdir),15,1)
	return ..()
*/
