/obj/item/gun/projectile/energy/service
	name = "service weapon"
	icon_state = "service_grip"
	item_state = "service_grip"
	desc = "An anomalous weapon, long kept secure. It has recently been acquired by NanoTrasen's Paracausal Monitoring Division. How did it get here?"
	damage_force = 5
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/projectile/bullet/pistol/medium/silver
	origin_tech = null
	fire_delay = 10		//Old pistol
	charge_cost = 480	//to compensate a bit for self-recharging
	cell_initial = /obj/item/cell/device/weapon/recharge/captain
	battery_lock = 1
	one_handed_penalty = 0
	safety_state = GUN_SAFETY_OFF

/obj/item/gun/projectile/energy/service/attack_self(mob/user)
	. = ..()
	if(.)
		return
	cycle_weapon(user)

/obj/item/gun/projectile/energy/service/proc/cycle_weapon(mob/living/L)
	var/obj/item/service_weapon
	var/list/service_weapon_list = subtypesof(/obj/item/gun/projectile/energy/service)
	var/list/display_names = list()
	var/list/service_icons = list()
	for(var/V in service_weapon_list)
		var/obj/item/gun/projectile/energy/service/weapontype = V
		if (V)
			display_names[initial(weapontype.name)] = weapontype
			service_icons += list(initial(weapontype.name) = image(icon = initial(weapontype.icon), icon_state = initial(weapontype.icon_state)))

	service_icons = sortList(service_icons)

	var/choice = show_radial_menu(L, src, service_icons)
	if(!choice || !check_menu(L))
		return

	var/A = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	service_weapon = new A

	if(service_weapon)
		qdel(src)
		L.put_in_active_hand(service_weapon)

/obj/item/gun/projectile/energy/service/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/gun/projectile/energy/service/grip

/obj/item/gun/projectile/energy/service/shatter
	name = "service weapon (shatter)"
	icon_state = "service_shatter"
	projectile_type = /obj/projectile/bullet/pellet/shotgun/silver
	fire_delay = 15		//Increased by 50% for strength.
	charge_cost = 600	//Charge increased due to shotgun round.

/obj/item/gun/projectile/energy/service/spin
	name = "service weapon (spin)"
	icon_state = "service_spin"
	projectile_type = /obj/projectile/bullet/pistol/spin
	fire_delay = 0	//High fire rate.
	charge_cost = 80	//Lower cost per shot to encourage rapid fire.

/obj/item/gun/projectile/energy/service/pierce
	name = "service weapon (pierce)"
	icon_state = "service_pierce"
	projectile_type = /obj/projectile/bullet/rifle/a762/ap/silver
	fire_delay = 15		//Increased by 50% for strength.
	charge_cost = 600	//Charge increased due to sniper round.

/obj/item/gun/projectile/energy/service/charge
	name = "service weapon (charge)"
	icon_state = "service_charge"
	projectile_type = /obj/projectile/bullet/burstbullet/service    //Formerly: obj/projectile/bullet/gyro. A little too robust.
	fire_delay = 20
	charge_cost = 800	//Three shots.
