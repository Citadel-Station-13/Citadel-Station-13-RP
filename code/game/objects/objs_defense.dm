/obj/ex_act(power, dir, datum/automata/wave/explosion/E)
	. = ..()
	// todo: wave explosions

/obj/legacy_ex_act(severity, target)
	. = ..()
	inflict_atom_damage(global._legacy_ex_atom_damage[severity], flag = ARMOR_BOMB)

/obj/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	. = ..()

/obj/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult)
	. = ..()
	#warn impl

/obj/bullet_act(obj/projectile/P, def_zone)
	. = ..()

/obj/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()


#warn impl

