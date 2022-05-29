/*
CONTAINS:
Deployable items
Barricades
*/

//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = TRUE
	density = TRUE
	var/health = 100
	var/maxhealth = 100
	var/datum/material/material

/obj/structure/barricade/Initialize(mapload, material_name)
	. = ..()
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(user.get_attack_speed(W))
	if(istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if(health < maxhealth)
			if(D.get_amount() < 1)
				to_chat(user, SPAN_WARNING("You need one sheet of [material.display_name] to repair \the [src]."))
				return
			visible_message(SPAN_NOTICE("[user] begins to repair \the [src]."))
			if(do_after(user,20) && health < maxhealth)
				if(D.use(1))
					health = maxhealth
					visible_message(SPAN_NOTICE("[user] repairs \the [src]."))
				return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * 1
			if("brute")
				health -= W.force * 0.75
		if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD) || get_material_by_name(MAT_HARDWOOD)))
			playsound(loc, 'sound/effects/woodcutting.ogg', 100, TRUE)
		else
			playsound(src, 'sound/weapons/smash.ogg', 50, TRUE)
		CheckHealth()
		..()

/obj/structure/barricade/proc/CheckHealth()
	if(health <= 0)
		dismantle()
	return

/obj/structure/barricade/take_damage(damage)
	health -= damage
	CheckHealth()
	return

/obj/structure/barricade/attack_generic(mob/user, damage, attack_verb)
	visible_message(SPAN_DANGER("[user] [attack_verb] \the [src]!"))

	if(material == get_material_by_name("resin"))
		playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
	else if(material == (get_material_by_name(MAT_WOOD) || get_material_by_name(MAT_SIFWOOD) || get_material_by_name(MAT_HARDWOOD)))
		playsound(loc, 'sound/effects/woodcutting.ogg', 100, TRUE)
	else
		playsound(src, 'sound/weapons/smash.ogg', 50, TRUE)
	user.do_attack_animation(src)
	health -= damage
	CheckHealth()
	return

/obj/structure/barricade/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	visible_message("<span class='danger'>\The [src] falls apart!</span>")
	qdel(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			dismantle()
		if(2.0)
			health -= 25
			CheckHealth()

/obj/structure/barricade/CanAllowThrough(atom/movable/mover, turf/target)//So bullets will fly over and stuff.
	. = ..()
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	return FALSE

//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = TRUE
	icon_state = "barrier0"
	var/health = 100
	var/maxhealth = 100
	var/locked = FALSE
//	req_access = list(access_maint_tunnels)

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
			req_access = list(access_security)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		else if(emagged > 0)
			emagged = 0
			req_access = list(access_security)
			visible_message(SPAN_WARNING("[user] repairs \the [src]!"))
			return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * 0.75
			if("brute")
				health -= W.force * 0.5
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

/obj/machinery/deployable/barrier/take_damage(damage)
	health -= damage
	CheckHealth()
	return

/obj/machinery/deployable/barrier/ex_act(severity)
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

/obj/machinery/deployable/barrier/CanAllowThrough(atom/movable/mover, turf/target)//So bullets will fly over and stuff.
	. = ..()
	if(mover.checkpass(PASSTABLE))
		return TRUE
	return FALSE

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
