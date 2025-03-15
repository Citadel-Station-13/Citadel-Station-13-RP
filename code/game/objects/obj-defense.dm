//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/ex_act(power, dir, datum/automata/wave/explosion/E)
	. = ..()
	// todo: wave explosions
	// no named arguments for speed reasons
	run_damage_instance(power * (1 / 2.5) * (0.01 * rand(80, 120)), DAMAGE_TYPE_BRUTE, null, ARMOR_BOMB)

/obj/legacy_ex_act(severity, target)
	. = ..()
	// todo: wave explosions
	// no named arguments for speed reasons
	run_damage_instance(global._legacy_ex_atom_damage[severity] * (0.01 * rand(80, 120)), DAMAGE_TYPE_BRUTE, null, ARMOR_BOMB)

/obj/melee_act(mob/user, obj/item/weapon, target_zone, datum/event_args/actor/clickchain/clickchain)
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

/obj/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, datum/event_args/actor/clickchain/clickchain)
	var/shieldcall_returns = atom_shieldcall_handle_unarmed_melee(style, clickchain, FALSE, NONE)
	if(shieldcall_returns & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return CLICKCHAIN_FULL_BLOCKED
	// todo: maybe the unarmed_style side should handle this?
	run_damage_instance(
		style.get_unarmed_damage(attacker, src) * (clickchain ? clickchain.melee_damage_multiplier : 1),
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

/obj/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
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
	if(QDELETED(src))
		impact_flags |= PROJECTILE_IMPACT_TARGET_DELETED
	return ..()

/obj/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return
	// todo: /atom/movable/proc/throw_impact_attack(atom/target)
	if(temporary_legacy_dont_auto_handle_obj_damage_for_mechs)
		return
	if(isitem(AM))
		var/obj/item/I = AM
		inflict_atom_damage(I.throw_force * TT.get_damage_multiplier(src), TT.get_damage_tier(src), I.damage_flag, I.damage_mode, ATTACK_TYPE_THROWN, AM)
	else
		inflict_atom_damage(AM.throw_force * TT.get_damage_multiplier(src), TT.get_damage_tier(src), ARMOR_MELEE, null, ATTACK_TYPE_THROWN, AM)
	// if we got destroyed
	if(QDELETED(src) && (obj_flags & OBJ_ALLOW_THROW_THROUGH))
		. |= COMPONENT_THROW_HIT_PIERCE

/obj/blob_act(obj/structure/blob/blob)
	. = ..()
	inflict_atom_damage(100, damage_flag = ARMOR_MELEE, attack_type = ATTACK_TYPE_MELEE)

/obj/hitsound_melee(obj/item/I)
	if(!isnull(material_primary))
		var/datum/prototype/material/primary = get_primary_material()
		. = I.damage_type == DAMAGE_TYPE_BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()

/obj/hitsound_throwhit(obj/item/I)
	if(!isnull(material_primary))
		var/datum/prototype/material/primary = get_primary_material()
		. = I.damage_type == DAMAGE_TYPE_BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()

/obj/hitsound_unarmed(mob/M, datum/unarmed_attack/style)
	if(!isnull(material_primary))
		var/datum/prototype/material/primary = get_primary_material()
		. = style.damage_type == DAMAGE_TYPE_BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()
