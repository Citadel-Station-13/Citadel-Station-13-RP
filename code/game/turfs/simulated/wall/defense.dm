/turf/simulated/wall/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return

	// todo: /atom/movable/proc/throw_impact_attack(atom/target)
	if(isitem(AM))
		var/obj/item/I = AM
		inflict_atom_damage(I.throw_force * TT.get_damage_multiplier(), I.damage_tier, I.damage_flag, I.damage_mode, ATTACK_TYPE_THROWN, AM)
	else
		inflict_atom_damage(AM.throw_force * TT.get_damage_multiplier(), MELEE_TIER_LIGHT, ARMOR_MELEE, null, ATTACK_TYPE_THROWN, AM)

/turf/simulated/wall/bullet_act(var/obj/projectile/Proj)
	if(istype(Proj,/obj/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/projectile/ion))
		burn(500)

	var/proj_damage = Proj.get_structure_damage()

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	if(Proj.damage_type == BURN && damage > 0)
		if(thermite)
			thermitemelt()

	if(istype(Proj,/obj/projectile/beam))
		if(material && material.reflectivity >= 0.5) // Time to reflect lasers.
			var/new_damage = damage * material.reflectivity
			var/outgoing_damage = damage - new_damage
			damage = new_damage
			Proj.damage = outgoing_damage

			visible_message("<span class='danger'>\The [src] reflects \the [Proj]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = Proj.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
			var/new_y = Proj.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
			//var/turf/curloc = get_turf(src)
			var/turf/curloc = get_step(src, get_dir(src, Proj.starting))

			Proj.penetrating += 1 // Needed for the beam to get out of the wall.

			// redirect the projectile
			Proj.redirect(new_x, new_y, curloc, null)

	if(Proj.ricochet_sounds && prob(15))
		playsound(src, pick(Proj.ricochet_sounds), 100, 1)

	take_damage(damage)
	return

/turf/simulated/wall/break_apart(method)
	dismantle_wall()

/turf/simulated/wall/damage_integrity(amount, gradual, do_not_break)
	. = ..()
	// todo: optimize
	update_appearance()

/turf/simulated/wall/heal_integrity(amount, gradual, do_not_fix)
	. = ..()
	// todo: optimize
	update_appearance()
