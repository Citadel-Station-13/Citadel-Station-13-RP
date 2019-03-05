/obi/item/ammu_casing/proc/fire_casing(atom/target_or_angle, atom/user, params,




///////////////////////
/obj/item/ammo_casing/proc/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread)
	distro += variance
	for (var/i = max(1, pellets), i > 0, i--)
		var/targloc = get_turf(target)
		ready_proj(target, user, quiet, zone_override)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			else //Smart spread
				spread = round((i / pellets - 0.5) * distro)
		if(!throw_proj(target, targloc, user, params, spread))
			return 0
		if(i > 1)
			newshot()
	if(click_cooldown_override)
		user.changeNext_move(click_cooldown_override)
	else
		user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))
	update_icon()
	return 1

/obj/item/ammu_casing/proc/ready_projectile(atom/target, atom/user, suppress, zone_override)
	var/obj/item/projectile/P = . = return_projectile()
	if(!.)
		return
	P.original = target
	P.firer = user
	if(zone_override)
		P.def_zone = zone_override
	else if(isliving(user))
		var/mob/living/L = user
		P.def_zone = L.zone_selected


/obj/item/ammo_casing/proc/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if (!BB)
		return
	BB.original = target
	BB.firer = user
	if (zone_override)
		BB.def_zone = zone_override
	else
		BB.def_zone = user.zone_selected
	BB.suppressed = quiet

	if(reagents && BB.reagents)
		reagents.trans_to(BB, reagents.total_volume, transfered_by = user) //For chemical darts/bullets
		qdel(reagents)

/obj/item/ammo_casing/proc/throw_projectile(atom/target, turf/target_turf, atom/user, params, spread)
	var/turf/source_turf = get_turf(user)
	if(!istype(source_turf) || (!istype(target_turf) && !istype(target)) || !return_projectile())
		return FALSE
	var/obj/item/projectile/P = expend_projectile()		//point of no return
	if(!target_turf)
		target_turf = get_turf(target)
	else if(!target)
		target = target_turf




/obj/item/ammo_casing/proc/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread)
	var/turf/curloc = get_turf(user)
	if (!istype(targloc) || !istype(curloc) || !BB)
		return 0

	var/firing_dir
	if(BB.firer)
		firing_dir = BB.firer.dir
	if(!BB.suppressed && firing_effect_type)
		new firing_effect_type(get_turf(src), firing_dir)

	var/direct_target
	if(targloc == curloc)
		if(target) //if the target is right on our location we'll skip the travelling code in the proj's fire()
			direct_target = target
	if(!direct_target)
		BB.preparePixelProjectile(target, user, params, spread)
	BB.fire(null, direct_target)
	BB = null
	return 1

/obj/item/ammo_casing/proc/spread(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), target.y + round(gaussian(0, distro) * (dx+2)/8, 1), target.z)




