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

/turf/simulated/wall/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, datum/event_args/actor/clickchain/clickchain)
	var/shieldcall_returns = atom_shieldcall_handle_unarmed_melee(style, clickchain, FALSE, NONE)
	if(shieldcall_returns & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return CLICKCHAIN_FULL_BLOCKED
	// todo: maybe the unarmed_style side should handle this?
	run_damage_instance(
		style.damage * (clickchain ? clickchain.melee_damage_multiplier : 1),
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

/turf/simulated/wall/melee_act(mob/user, obj/item/weapon, target_zone, datum/event_args/actor/clickchain/clickchain)
	var/shieldcall_returns = atom_shieldcall_handle_item_melee(weapon, clickchain, FALSE, NONE)
	if(shieldcall_returns & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return CLICKCHAIN_FULL_BLOCKED
	// todo: maybe the item side should handle this?
	run_damage_instance(
		weapon.damage_force * (clickchain ? clickchain.melee_damage_multiplier : 1),
		weapon.damage_type,
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

/turf/simulated/wall/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	// todo: this method of detecting destruction is shitcode but turf refs don't change so qdeleted() won't work
	var/old_type = type
	if(!(impact_flags & (PROJECTILE_IMPACT_BLOCKED | PROJECTILE_IMPACT_SKIP_STANDARD_DAMAGE)))
		// todo: maybe the projectile side should handle this?
		run_damage_instance(
			proj.get_structure_damage() * bullet_act_args[BULLET_ACT_ARG_EFFICIENCY],
			proj.damage_type,
			proj.damage_tier,
			proj.damage_flag,
			proj.damage_mode,
			ATTACK_TYPE_PROJECTILE,
			proj,
			NONE,
			bullet_act_args[BULLET_ACT_ARG_ZONE],
			null,
			null,
		)
	// turf refs don't change so while QDELETED() doesn't work this is a close approximate
	// until we have a better system or we decide to pay some overhead to track with a number or something
	if(old_type != type)
		impact_flags |= PROJECTILE_IMPACT_TARGET_DELETED
		return ..()

	//! legacy code handling
	if((proj.projectile_type & (PROJECTILE_TYPE_ENERGY | PROJECTILE_TYPE_BEAM)) && !proj.nodamage && proj.damage_force)
		burn(2500)
	if(proj.damage_type == DAMAGE_TYPE_BURN && proj.damage_force && !proj.nodamage)
		if(thermite)
			thermitemelt()
	if(proj.ricochet_sounds && prob(15))
		playsound(src, pick(proj.ricochet_sounds), 75, TRUE)
	//! end

	return ..()
