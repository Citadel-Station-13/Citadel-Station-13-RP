/obi/item/ammu_casing/proc/fire_casing(atom/target_or_angle, atom/user, params, distro = variance, suppress = FALSE, zone_override, angle_offset = 0)
	if(!istype(target_or_angle) && !isnum(target_or_angle))
		return FALSe
	var/firing_dir = istype(target_or_angle)? get_dir(user, target_or_angle) : angle2dir(target_or_angle)
	new firing_effect_type(get_turf(src), firing_dir)
	var/turf/targloc
	if(istype(target_or_angle))
		targloc = get_turf(target_or_angle)
	for(var/i in 1 to pellets)
		ready_projectile(target_or_angle, user, suppress, zone_override)
		var/spread
		if(distro)
			if(ammo_flags & RANDOMSPREAD)
				spread = ((rand() - 0.5) * distro)
			else
				spread = (((i / pellets) - 0.5) * distro)
		if(!throw_projectile(target_or_angle, targloc, user, params, angle_offset + spread))
			return FALSE
		if(i < pellets)
			initialize_projectile()
	playsound(src, fire_sound, sound_volume)
	if(isliving(user) && click_cooldown_override)
		user.change_clickcd(click_cooldown_override)
	user.newtonian_move(firing_dir)
	update_icon()
	return TRUE

/obj/item/ammu_casing/proc/ready_projectile(atom/target_or_angle, atom/user, suppress, zone_override)
	var/obj/item/projectile/P
	P = . = return_projectile()
	if(!.)
		return FALSE
	if(istype(target_or_angle))
		P.original = target_or_angle
	P.firer = user
	if(zone_override)
		P.def_zone = zone_override
	else if(isliving(user))
		var/mob/living/L = user
		P.def_zone = L.zone_selected
	P.suppressed = suppress
	if(reagents && P.reagents)
		reagents.trans_to(P, reagents.total_volume, transfered_by = user)			//for chemical darts/bullets.
		qdel(reagents)
	return P

/obj/item/ammu_casing/proc/throw_projectile(atom/target_or_angle, turf/target_turf, atom/user, params, angle_offset)
	var/turf/source_turf = get_turf(user)
	if(!istype(source_turf) || (!istype(target_turf) && !istype(target_or_angle) && !isnum(target_or_angle)) || !return_projectile())
		return FALSE
	var/obj/item/projectile/P = expend_projectile()		//point of no return
	var/number_mode == isnum(target_or_angle)
	if(!number_mode)
		if(!target_turf)
			target_turf = get_turf(target)
		else if(!target_or_angle)
			target = target_turf
	P.preparePixelProjectile(number_mode? target_or_angle : null, user, params, angle_offset, target_or_angle)
	var/direct_target
	if(!number_mode && target_or_angle && (get_dist(target_turf, source_turf) <= 1))						//If they're right next to us, just hit 'em.
		direct_target = target_or_angle
	P.fire(null, direct_target)
	return P

/obj/item/ammu_casing/proc/get_spread_arc_turf(turf/target, turf/current, distro)
	var/dx = abs(target.x - current.x)
	var/dy = abs(target.y - current.y)
	return locate(CLAMP(target.x + round(gaussian(0, distro) * (dy+2)/8, 1), 1, world.maxx), CLAMP(target.y + round(gaussian(0, distro) * (dx+2)/8, 1), 1, world.maxy), target.z)

/obj/item/ammu_casing/proc/get_spread_arc_precise(datum/point/target, datum/point/current, distro)
	if(isatom(target))
		target = GET_PRECISE_POINT(target)
	if(isatom(current))
		current = GET_PRECISE_POINT(current)
	CRASH("get_spread_arc_precise is not implemented yet.")
