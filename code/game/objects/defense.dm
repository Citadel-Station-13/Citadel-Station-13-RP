//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/ex_act(power, dir, datum/automata/wave/explosion/E)
	. = ..()
	// todo: wave explosions
	inflict_atom_damage(power * (1 / 2.5), flag = ARMOR_BOMB)

/obj/legacy_ex_act(severity, target)
	. = ..()
	inflict_atom_damage(global._legacy_ex_atom_damage[severity], flag = ARMOR_BOMB)

/obj/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	inflict_atom_damage(weapon.damage_force, weapon.damage_tier, weapon.damage_flag, weapon.damage_mode, ATTACK_TYPE_MELEE, weapon)
	return NONE

/obj/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult)
	// todo: this should just be style.attack(attacker, src)
	inflict_atom_damage(style.get_unarmed_damage(attacker, src), style.damage_tier, style.damage_flag, style.damage_mode, ATTACK_TYPE_UNARMED, attacker)
	return NONE

/obj/bullet_act(obj/projectile/P, def_zone)
	. = ..()
	// todo: should this really be here?
	inflict_atom_damage(P.get_structure_damage(), P.damage_tier, P.damage_flag, P.damage_mode, ATTACK_TYPE_PROJECTILE, P)

/obj/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	// todo: /atom/movable/proc/throw_impact_attack(atom/target)
	if(isitem(AM))
		var/obj/item/I = AM
		inflict_atom_damage(I.throw_force * TT.get_damage_multiplier(), I.damage_tier, I.damage_flag, I.damage_mode, ATTACK_TYPE_THROWN, AM)
	else
		inflict_atom_damage(AM.throw_force * TT.get_damage_multiplier(), MELEE_TIER_LIGHT, ARMOR_MELEE, null, ATTACK_TYPE_THROWN, AM)

/obj/blob_act(obj/structure/blob/blob)
	. = ..()
	inflict_atom_damage(100, flag = ARMOR_MELEE, attack_type = ATTACK_TYPE_MELEE)

/obj/hitsound_melee(obj/item/I)
	if(!isnull(material_primary))
		var/datum/material/primary = get_primary_material()
		. = I.damtype == BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()

/obj/hitsound_throwhit(obj/item/I)
	if(!isnull(material_primary))
		var/datum/material/primary = get_primary_material()
		. = I.damtype == BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()

/obj/hitsound_unarmed(mob/M, datum/unarmed_attack/style)
	if(!isnull(material_primary))
		var/datum/material/primary = get_primary_material()
		. = style.damage_type == BURN? primary.sound_melee_burn : primary.sound_melee_brute
		if(!isnull(.))
			return
	return ..()
