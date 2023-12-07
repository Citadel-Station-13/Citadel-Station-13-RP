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

/obj/item/gun/projectile/ballistic/automatic/combat
	name = "\improper Harpy combat submachine gun"
	desc = "The compact NT-SMG-8 'Harpy' submachine gun was designed for NanoTrasen special operations where close-quarters combat is likely. Chambered in 5.7x28mm with three fire modes, this gun is lethal to soft and armored targets alike."
	icon_state = "combatsmg"
	item_state = "combatsmg"
	w_class = ITEMSIZE_NORMAL
	caliber = "5.7x28mm"
	fire_sound = 'sound/weapons/gunshot/gunshot_uzi.wav'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m57x28mm/smg/ap
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mm/smg)

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(60,30,30), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="automatic", burst=1, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/automatic/combat/update_icon_state()
	. = ..()
	icon_state = (ammo_magazine)? "combatsmg" : "combatsmg-empty"

/obj/item/gun/projectile/ballistic/ntles
	name = "NT-57 'LES'"
	desc = "The NT-57 'LES' (Light Expeditionary Sidearm) is a tried and tested pistol often issued to Pathfinders. Featuring a polymer frame, collapsible stock, and integrated optics, the LES is lightweight and reliably functions in nearly any hazardous environment, including vacuum."
	icon_state = "ntles"
	item_state = "pistol"
	caliber = "5.7x28mm"
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m57x28mm/ntles
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mm/ntles)
	projectile_type = /obj/projectile/bullet/pistol/lap
	one_handed_penalty = 30
	var/collapsible = 1
	var/extended = 0

/obj/item/gun/projectile/ballistic/ntles/update_icon_state()
	. = ..()
	if(!extended && ammo_magazine)
		icon_state = "ntles"
	else if(extended && ammo_magazine)
		icon_state = "ntles_extended"
	else if(extended && !ammo_magazine)
		icon_state = "ntles_extended-empty"
	else
		icon_state = "ntles-empty"

/obj/item/gun/projectile/ballistic/ntles/attack_self(mob/user, obj/item/gun/G)
	if(collapsible && !extended)
		to_chat(user, "<span class='notice'>You pull out the stock on the [src], steadying the weapon.</span>")
		w_class = ITEMSIZE_LARGE
		one_handed_penalty = 10
		extended = 1
		update_icon()
	else if(!collapsible)
		to_chat(user, "<span class='danger'>The [src] doesn't have a stock!</span>")
		return
	else
		to_chat(user, "<span class='notice'>You push the stock back into the [src], making it more compact.</span>")
		w_class = ITEMSIZE_NORMAL
		one_handed_penalty = 30
		extended = 0
		update_icon()

/obj/item/gun/projectile/ballistic/ntles/pathfinder
	pin = /obj/item/firing_pin/explorer
