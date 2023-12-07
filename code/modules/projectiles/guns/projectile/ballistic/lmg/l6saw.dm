/obj/item/gun/projectile/ballistic/automatic/lmg
	name = "light machine gun"
	desc = "A rather traditionally made L6 SAW with a pleasantly lacquered wooden pistol grip. 'Aussec Armoury-2531' is engraved on the reciever. Uses 5.56mm rounds. It's also compatible with magazines from STS-35 assault rifles."
	icon_state = "l6closed50"
	item_state = "l6closed"
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	slot_flags = 0
	max_shells = 50
	caliber = "5.56mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_insert_sound = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/lmg_magout.ogg'
	magazine_type = /obj/item/ammo_magazine/m556saw
	allowed_magazines = list(/obj/item/ammo_magazine/m556saw, /obj/item/ammo_magazine/m556)
	projectile_type = /obj/projectile/bullet/rifle/a556
	can_special_reload = FALSE
	heavy = TRUE
	one_handed_penalty = 75

	var/cover_open = 0

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null, automatic = 0),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0), automatic = 0),
		list(mode_name="short bursts",	burst=5, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2), automatic = 0),
		list(mode_name="automatic",       burst=1, fire_delay=-1,    move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/*
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(60,30,0), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",	burst=5, move_delay=6, burst_accuracy = list(60,50,45,40,35), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2))
		)
*/

/obj/item/gun/projectile/ballistic/automatic/lmg/special_check(mob/user)
	if(cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/ballistic/automatic/lmg/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>")
	update_icon()
	update_held_icon()

/obj/item/gun/projectile/ballistic/automatic/lmg/attack_self(mob/user)
	if(cover_open)
		toggle_cover(user) //close the cover
	else
		return ..() //once closed, behave like normal

/obj/item/gun/projectile/ballistic/automatic/lmg/attack_hand(mob/user, list/params)
	if(!cover_open && user.get_inactive_held_item() == src)
		toggle_cover(user) //open the cover
	else
		return ..() //once open, behave like normal

/obj/item/gun/projectile/ballistic/automatic/lmg/update_icon()
	. = ..()
	update_held_icon()

/obj/item/gun/projectile/ballistic/automatic/lmg/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m762))
		icon_state = "l6[cover_open ? "open" : "closed"]mag"
		item_state = icon_state
	else
		icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 10) : "-empty"]"
		item_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? "" : "-empty"]"

/obj/item/gun/projectile/ballistic/automatic/lmg/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to load [src].</span>")
		return
	..()

/obj/item/gun/projectile/ballistic/automatic/lmg/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to unload [src].</span>")
		return
	..()
