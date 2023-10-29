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

/turf/simulated/wall/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult)
	// todo: this should just be style.attack(attacker, src)
	inflict_atom_damage(style.get_unarmed_damage(attacker, src), style.damage_tier, style.damage_flag, style.damage_mode, ATTACK_TYPE_UNARMED, attacker)
	return NONE

/turf/simulated/wall/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	inflict_atom_damage(weapon.damage_force, weapon.damage_tier, weapon.damage_flag, weapon.damage_mode, ATTACK_TYPE_MELEE, weapon)
	return NONE

/turf/simulated/wall/bullet_act(var/obj/projectile/Proj)
	if(istype(Proj,/obj/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/projectile/ion))
		burn(500)

	if(Proj.damage_type == BURN && Proj.damage > 0)
		if(thermite)
			thermitemelt()

	if(Proj.ricochet_sounds && prob(15))
		playsound(src, pick(Proj.ricochet_sounds), 100, 1)

	inflict_atom_damage(Proj.get_structure_damage(), Proj.damage_tier, Proj.damage_flag, Proj.damage_mode, ATTACK_TYPE_PROJECTILE, Proj)

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
