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
	#warn impl

/obj/blob_act(obj/structure/blob/blob)
	. = ..()
	#warn impl

#warn attack sounds for materials

#warn deal with hulk somehow
