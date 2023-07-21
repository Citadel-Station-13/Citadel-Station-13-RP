/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(ACCESS_SECURITY_EQUIPMENT)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = TRUE
	icon_state = "barrier0"
	pass_flags_self = ATOM_PASS_TABLE
	integrity = 200
	integrity_max = 200
	var/locked = FALSE
//	req_access = list(ACCESS_ENGINEERING_MAINT)

/obj/machinery/deployable/barrier/Initialize(mapload, newdir)
	. = ..()
	update_icon()

/obj/machinery/deployable/barrier/update_icon_state()
	. = ..()
	icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/card/id/))
		if(allowed(user))
			if	(emagged < 2)
				locked = !locked
				anchored = !anchored
				icon_state = "barrier[locked]"
				if((locked == 1) && (emagged < 2))
					to_chat(user, "Barrier lock toggled on.")
					return
				else if((locked == 0) && (emagged < 2))
					to_chat(user, "Barrier lock toggled off.")
					return
			else
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
				return
		return
	else if(W.is_wrench())
		if(health < maxhealth)
			health = maxhealth
			emagged = 0
			req_access = list(ACCESS_SECURITY_EQUIPMENT)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		else if(emagged > 0)
			emagged = 0
			req_access = list(ACCESS_SECURITY_EQUIPMENT)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.damage_force * 0.75
			if("brute")
				health -= W.damage_force * 0.5
		playsound(src, 'sound/weapons/smash.ogg', 50, TRUE)
		CheckHealth()
		..()

/obj/machinery/deployable/barrier/proc/CheckHealth()
	if(health <= 0)
		explode()
	return

/obj/machinery/deployable/barrier/attack_generic(mob/user, damage, attack_verb)
	visible_message(SPAN_DANGER("[user] [attack_verb] \the [src]!"))
	playsound(src, 'sound/weapons/smash.ogg', 50, TRUE)
	user.do_attack_animation(src)
	health -= damage
	CheckHealth()
	return

/obj/machinery/deployable/barrier/take_damage_legacy(damage)
	health -= damage
	CheckHealth()
	return

/obj/machinery/deployable/barrier/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			health -= 25
			CheckHealth()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/proc/explode()

	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(Tsec)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	if(src)
		qdel(src)

/obj/machinery/deployable/barrier/emag_act(remaining_charges, mob/user)
	if(emagged == 0)
		emagged = 1
		req_access.Cut()
		req_one_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the [src].")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return 1
	else if(emagged == 1)
		emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return 1
