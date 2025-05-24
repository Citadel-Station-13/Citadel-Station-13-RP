/datum/technomancer/spell/reflect
	name = "Reflect"
	desc = "Emits a protective shield fron your hand in front of you, which will reflect one attack back at the attacker."
	cost = 100
	obj_path = /obj/item/spell/reflect
	ability_icon_state = "tech_reflect"
	category = DEFENSIVE_SPELLS

/obj/item/spell/reflect
	name = "reflection shield"
	icon_state = "reflect"
	desc = "A very protective combat shield that'll reflect the next attack at the unfortunate person who tried to shoot you."
	aspect = ASPECT_FORCE
	toggled = 1
	var/reflecting = 0
	var/damage_to_energy_multiplier = 60.0 //Determines how much energy to charge for blocking, e.g. 20 damage attack = 1200 energy cost
	var/datum/effect_system/spark_spread/spark_system = null

/obj/item/spell/reflect/Initialize(mapload)
	. = ..()
	set_light(3, 2, l_color = "#006AFF")
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	to_chat(owner, "<span class='notice'>Your shield will expire in 3 seconds!</span>")
	QDEL_IN(src, 5 SECONDS)

/obj/item/spell/reflect/Destroy()
	if(ismob(loc))
		to_chat(loc, "<span class='danger'>Your shield expires!</span>")
	spark_system = null
	return ..()

/obj/item/spell/reflect/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	// if you're reading this: this is not the right way to do shieldcalls
	// this is just a lazy implementation
	// signals have highest priority, this as a piece of armor shouldn't have that.
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL, PROC_REF(shieldcall))

/obj/item/spell/reflect/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL)

/obj/item/spell/reflect/proc/shieldcall(datum/source, list/shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
		return
	var/mob/user = source
	if(user.incapacitated())
		return

	var/mob/attacker
	var/damage_to_energy_cost = (damage_to_energy_multiplier * shieldcall_args[SHIELDCALL_ARG_DAMAGE])
	var/damage_source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]

	if(!pay_energy(damage_to_energy_cost))
		to_chat(owner, "<span class='danger'>Your shield fades due to lack of energy!</span>")
		qdel(src)
		return

	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		attacker = P.firer

		if(P.starting && !P.reflected)
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [P]!</span>")

			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.legacy_redirect(P.starting.x, P.starting.y, curloc, user)
			P.reflected = 1
			if(check_for_scepter())
				P.damage_force = P.damage_force * 1.5

			spark_system.start()
			playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
			// now send a log so that admins don't think they're shooting themselves on purpose.
			if(attacker)
				log_and_message_admins("[user] reflected [attacker]'s attack back at them.")

			if(!reflecting)
				reflecting = 1
				spawn(2 SECONDS) //To ensure that most or all of a burst fire cycle is reflected.
					to_chat(owner, "<span class='danger'>Your shield fades due being used up!</span>")
					qdel(src)

			shieldcall_args[SHIELDCALL_ARG_FLAGS] |= SHIELDCALL_FLAG_ATTACK_PASSTHROUGH | SHIELDCALL_FLAG_ATTACK_REDIRECT | SHIELDCALL_FLAG_ATTACK_BLOCKED | SHIELDCALL_FLAG_TERMINATE

	else if(istype(damage_source, /datum/event_args/actor/clickchain))
		var/datum/event_args/actor/clickchain/clickchain = damage_source
		var/obj/item/W = clickchain.using_melee_weapon
		attacker = clickchain.performer
		if(attacker)
			W.melee_interaction_chain(attacker, attacker)
			to_chat(attacker, "<span class='danger'>Your [damage_source] goes through \the [src] in one location, comes out \
			on the same side, and hits you!</span>")

			spark_system.start()
			playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

			log_and_message_admins("[user] reflected [attacker]'s attack back at them.")

			if(!reflecting)
				reflecting = 1
				spawn(2 SECONDS) //To ensure that most or all of a burst fire cycle is reflected.
					to_chat(owner, "<span class='danger'>Your shield fades due being used up!</span>")
					qdel(src)
		shieldcall_args[SHIELDCALL_ARG_FLAGS] |= SHIELDCALL_FLAG_ATTACK_REDIRECT | SHIELDCALL_FLAG_ATTACK_BLOCKED | SHIELDCALL_FLAG_TERMINATE
