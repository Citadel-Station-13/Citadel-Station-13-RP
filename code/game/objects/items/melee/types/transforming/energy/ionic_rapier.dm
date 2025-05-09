/obj/item/melee/transforming/energy/sword/ionic_rapier
	name = "ionic rapier"
	desc = "Designed specifically for disrupting electronics at close range, it is extremely deadly against synthetics, but almost harmless to pure organic targets."
	description_info = "This is a dangerous melee weapon that will deliver a moderately powerful electromagnetic pulse to whatever it strikes.  \
	Striking a lesser robotic entity will compel it to attack you, as well.  It also does extra burn damage to robotic entities, but it does \
	very little damage to purely organic targets."
	icon_state = "ionrapier"
	item_state = "ionrapier"
	active_damage_force = 10
	active_throw_force = 3
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	atom_flags = NOBLOODY
	lrange = 2
	lpower = 2
	lcolor = "#0000FF"
	can_combine = FALSE

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 30;
	}

/obj/item/melee/transforming/energy/sword/ionic_rapier/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target, /obj) && (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) && active)
		// EMP stuff.
		var/obj/O = target
		O.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(get_turf(O), 'sound/effects/EMPulse.ogg', 100, 1)
		user.setClickCooldownLegacy(user.get_attack_speed_legacy(src)) // A lot of objects don't set click delay.
	return ..()

/obj/item/melee/transforming/energy/sword/ionic_rapier/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	. = ..()
	if(. & (CLICKCHAIN_ATTACK_MISSED | CLICKCHAIN_FLAGS_UNCONDITIONAL_ABORT))
		return
	if(clickchain.attack_contact_multiplier <= 0)
		return
	var/mob/living/L = clickchain.target
	if(!istype(L))
		return
	if(L.isSynthetic() && active)
		// Do some extra damage.  Not a whole lot more since emp_act() is pretty nasty on FBPs already.
		L.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(get_turf(L), 'sound/effects/EMPulse.ogg', 100, 1)
		L.adjustFireLoss(damage_force * 3) // 15 Burn, for 20 total.
		playsound(get_turf(L), 'sound/weapons/blade1.ogg', 100, 1)

		// Make lesser robots really mad at us.
		if(L.mob_class & MOB_CLASS_SYNTHETIC)
			if(L.has_polaris_AI())
				L.taunt(clickchain.performer)
			L.adjustFireLoss(damage_force * 6) // 30 Burn, for 50 total.

/obj/item/melee/transforming/energy/sword/ionic_rapier/lance
	name = "zero-point lance"
	desc = "Designed specifically for disrupting electronics at relatively close range, however it is still capable of dealing some damage to living beings."
	active_damage_force = 20
	reach = 2
