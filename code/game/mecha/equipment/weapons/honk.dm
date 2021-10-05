/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "sound emission device"
	desc = "A perfectly normal bike-horn, for your exosuit."
	icon_state = "mecha_honker"
	energy_drain = 300
	equip_cooldown = 150
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 4, TECH_ILLEGAL = 1)

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/weapon/honker/action(target)
	if(!chassis)
		return 0
	if(energy_drain && chassis.get_charge() < energy_drain)
		return 0
	if(!equip_ready)
		return 0

	playsound(src, 'sound/items/airhorn.ogg', 100, 1, 30)
	chassis.occupant_message("<span class='warning'>You emit a high-pitched noise from the mech.</span>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(istype(M, /mob/living/carbon/human))
			var/ear_safety = 0
			ear_safety = M.get_ear_protection()
			if(ear_safety > 0)
				return
		to_chat(M, "<span class='warning'>Your ears feel like they're bleeding!</span>")
		playsound(M, 'sound/items/airhorn.ogg', 100, 1, 30)
		M.SetSleeping(0)
		M.ear_deaf += 30
		M.ear_damage += rand(5, 20)
		M.Weaken(3)
		M.Stun(5)
	chassis.use_power(energy_drain)
	log_message("Used a sound emission device.")
	do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/banana
	name = "\improper Banana Peel launcher"
	desc = "A pneumatic launcher designed for maximum hilarity; fires banana peels."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/bananapeel
	fire_sound = 'sound/effects/splat.ogg'
	projectiles = 10
	missile_speed = 1.5
	projectile_energy_cost = 600
	equip_cooldown = 60

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/mousetrap
	name = "\improper Mouse Trap launcher"
	desc = "A pneumatic launcher designed for maximum hilarity; fires mouse traps."
	icon_state = "mecha_mousetrapmrtr"
	projectile = /obj/item/assembly/mousetrap/armed
	fire_sound = 'sound/effects/snap.ogg'
	projectiles = 20
	missile_speed = 1.5
	projectile_energy_cost = 300
	equip_cooldown = 60
