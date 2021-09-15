// Pathfinder's machete

/*
/obj/item/weapon/melee/energy/machete
	name = "energy machete"
	desc = "Light, concealable and especially favoured for artic survival, it features a sleek, robust design. While stylish, it is not the most practical and it somehow manages to look and feel like a toy. Features a telescoping energy emitter designed to be collapsed for storage."
	icon_state = "machete0"
	item_icons = list(slot_r_hand_str = 'maps/rift/icons/mob/rft_weapons.dmi', slot_l_hand_str = 'maps/rift/icons/mob/rft_weapons.dmi')
	icon = 'maps/rift/icons/obj/rft_weapons.dmi'
	active_force = 28
	active_throwforce = 20
	active_w_class = ITEMSIZE_LARGE
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 7
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 2 , TECH_MATERIAL = 3)
	var/active_state = "machete"

/obj/item/weapon/melee/energy/machete/initialize()
	..()
	lcolor = "#FF0000"

/obj/item/weapon/melee/energy/machete/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon_state = "[active_state]"

/obj/item/weapon/melee/energy/machete/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	..()
	attack_verb = list()
	icon_state = initial(icon_state)

/obj/item/weapon/melee/energy/machete/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/weapon/melee/energy/machete/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(25))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	return 0
*/