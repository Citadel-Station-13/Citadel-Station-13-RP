//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/turf/simulated/wall/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return
	// todo: this method of detecting destruction is shitcode but turf refs don't change so qdeleted() won't work
	var/old_type = type
	// todo: /atom/movable/proc/throw_impact_attack(atom/target)
	if(isitem(AM))
		var/obj/item/I = AM
		inflict_atom_damage(I.throw_force * TT.get_damage_multiplier(src), I.damage_tier, I.damage_flag, I.damage_mode, ATTACK_TYPE_THROWN, AM)
	else
		inflict_atom_damage(AM.throw_force * TT.get_damage_multiplier(src), MELEE_TIER_LIGHT, ARMOR_MELEE, null, ATTACK_TYPE_THROWN, AM)
	// turf refs don't change so while QDELETED() doesn't work this is a close approximate
	// until we have a better system or we decide to pay some overhead to track with a number or something
	if(old_type != type)
		if(!density)
			. |= COMPONENT_THROW_HIT_PIERCE // :trol:
		return

/turf/simulated/wall/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult)
	// todo: maybe the unarmed_style side should handle this?
	run_damage_instance(
		style.damage * mult,
		style.damage_type,
		style.damage_tier,
		style.damage_flag,
		style.damage_mode,
		ATTACK_TYPE_UNARMED,
		style,
		NONE,
		target_zone,
		null,
		null,
	)
	return NONE

/turf/simulated/wall/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	// todo: maybe the item side should handle this?
	run_damage_instance(
		weapon.damage_force * mult,
		weapon.damtype,
		weapon.damage_tier,
		weapon.damage_flag,
		weapon.damage_mode,
		ATTACK_TYPE_MELEE,
		weapon,
		NONE,
		target_zone,
		null,
		null,
	)
	return NONE

/turf/simulated/wall/bullet_act(obj/projectile/proj, impact_flags, def_zone, blocked)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	// todo: this method of detecting destruction is shitcode but turf refs don't change so qdeleted() won't work
	var/old_type = type
	// todo: maybe the projectile side should handle this?
	run_damage_instance(
		proj.get_structure_damage() * (1 - (blocked / 100)),
		proj.damage_type,
		proj.damage_tier,
		proj.damage_flag,
		proj.damage_mode,
		ATTACK_TYPE_PROJECTILE,
		projectile,
		NONE,
		def_zone,
		null,
		null,
	)
	// turf refs don't change so while QDELETED() doesn't work this is a close approximate
	// until we have a better system or we decide to pay some overhead to track with a number or something
	if(old_type != type)
		. |= PROJECTILE_IMPACT_TARGET_DELETED
		return

	//! legacy code handling
	if((proj.projectile_type & (PROJECTILE_TYPE_ENERGY | PROJECTILE_TYPE_BEAM)) && !proj.nodamage && proj.damage)
		burn(2500)
	if(proj.damage_type == BURN && proj.damage && !proj.nodamage)
		if(thermite)
			thermitemelt()
	if(proj.ricochet_sounds && prob(15))
		playsound(src, pick(proj.ricochet_sounds), 75, TRUE)
	//! end
