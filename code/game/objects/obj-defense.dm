//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/is_melee_targetable(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return obj_flags & OBJ_MELEE_TARGETABLE

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

/obj/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return
	// todo: /atom/movable/proc/throw_impact_attack(atom/target)
	if(temporary_legacy_dont_auto_handle_obj_damage_for_mechs)
		return
	var/inflicted_damage
	if(isitem(AM))
		var/obj/item/I = AM
		inflicted_damage = inflict_atom_damage(I.throw_force * TT.get_damage_multiplier(src), TT.get_damage_tier(src), I.damage_flag, I.damage_mode, ATTACK_TYPE_THROWN, AM)
	else
		inflicted_damage = inflict_atom_damage(AM.throw_force * TT.get_damage_multiplier(src), TT.get_damage_tier(src), ARMOR_MELEE, null, ATTACK_TYPE_THROWN, AM)
	if(inflicted_damage)
		playsound(src, hitsound_throwhit(AM), 75)
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

/obj/hitsound_throwhit(atom/movable/impacting)
	if(!isnull(material_primary))
		var/datum/prototype/material/primary = get_primary_material()
		var/resolved_damage_type
		if(isitem(impacting))
			var/obj/item/casted_item = impacting
			resolved_damage_type = casted_item.damage_type
		else
			resolved_damage_type = DAMAGE_TYPE_BRUTE

		. = resolved_damage_type == DAMAGE_TYPE_BURN? primary?.sound_melee_burn : primary?.sound_melee_brute
		if(!isnull(.))
			return
	return ..()

/obj/hitsound_unarmed(mob/M, datum/melee_attack/unarmed/style)
	if(!isnull(material_primary))
		var/datum/prototype/material/primary = get_primary_material()
		. = style.damage_type == DAMAGE_TYPE_BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()
