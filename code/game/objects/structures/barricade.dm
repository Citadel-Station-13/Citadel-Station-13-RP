/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	pass_flags_self = ATOM_PASS_TABLE
	anchored = TRUE
	density = TRUE
	integrity = 200
	integrity_max = 200

	material_parts = /datum/material/wood

/obj/structure/barricade/Initialize(mapload, datum/material/material_like)
	if(!isnull(material_like))
		set_primary_material(material_like)
	return ..()

/obj/structure/barricade/update_primary_material(datum/material/material)
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	var/initial_max_integrity = initial(integrity_max)
	var/ratio = initial_max_integrity / integrity_max
	set_full_integrity(integrity * ratio, initial_max_integrity * material.relative_integrity)

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
				health -= W.damage_force * 1
			if("brute")
				health -= W.damage_force * 0.75
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

/obj/structure/barricade/take_damage_legacy(damage)
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
