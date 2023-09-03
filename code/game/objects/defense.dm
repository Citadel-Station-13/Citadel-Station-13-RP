/obj/ex_act(power, dir, datum/automata/wave/explosion/E)
	. = ..()
	// todo: wave explosions
	#warn impl

/obj/legacy_ex_act(severity, target)
	. = ..()
	inflict_atom_damage(global._legacy_ex_atom_damage[severity], flag = ARMOR_BOMB)

/obj/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	. = ..()
	#warn impl

/obj/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult)
	. = ..()
	#warn impl

/obj/bullet_act(obj/projectile/P, def_zone)
	. = ..()
	#warn impl

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
	#warn impl

#warn attack sounds for materials

#warn deal with hulk somehow
