/obj/item/gun/projectile/ballistic/automatic/mini_uzi
	name = "\improper Uzi"
	desc = "The iconic Uzi is a lightweight, compact, fast firing machine pistol. Cybersun Industries were the last major manufacturer of these designs, which have changed little since the 20th century. Uses .45 rounds."
	icon_state = "mini-uzi"
	w_class = ITEMSIZE_NORMAL
	load_method = MAGAZINE
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	magazine_type = /obj/item/ammo_magazine/m45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/m45uzi)
	magazine_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, burst_delay=1, fire_delay=4, move_delay=4, burst_accuracy = list(60,40,30,20,15), dispersion = list(0.6, 1.0, 1.0))
		)

/obj/item/gun/projectile/ballistic/automatic/mini_uzi/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "mini-uzi"
	else
		icon_state = "mini-uzi-empty"

/obj/item/gun/projectile/ballistic/automatic/mini_uzi/custom
	name = "\improper custom Uzi"
	desc = "The iconic Uzi is a lightweight, compact, fast firing machine pistol. These traits make it a popular holdout option for Pathfinders assigned to hazardous expeditions. Uses .45 rounds."
	icon_state = "mini-uzi-custom"
	pin = /obj/item/firing_pin/explorer

/obj/item/gun/projectile/ballistic/automatic/mini_uzi/custom/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "mini-uzi-custom"
	else
		icon_state = "mini-uzi-custom-empty"
