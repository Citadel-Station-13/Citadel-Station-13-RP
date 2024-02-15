/obj/item/gun/projectile/ballistic/p90
	name = "personal defense weapon"
	desc = "The H90K is a compact, large capacity submachine gun produced by Hephaestus Industries. Despite its fierce reputation, it still manages to feel like a toy. Uses 5.7x28mm rounds."
	icon_state = "p90smg"
	item_state = "p90"
	w_class = ITEMSIZE_NORMAL
	caliber = "5.7x28mm"
	fire_sound = 'sound/weapons/gunshot/gunshot_uzi.wav'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT // ToDo: Belt sprite.
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m57x28mmp90
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mmp90) // ToDo: New sprite for the different mag.
	magazine_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(60,30,30), dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/gun/projectile/ballistic/p90/update_icon_state()
	. = ..()
	icon_state = "p90smg-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 6) : "empty"]"

/obj/item/gun/projectile/ballistic/p90/custom
	name = "custom personal defense weapon"
	desc = "An H90K from Hephaestus Industries. This one has a different colored receiver and a sling."
	icon_state = "p90smgC"
	magazine_type = /obj/item/ammo_magazine/m57x28mmp90/hunter
	slot_flags = SLOT_BELT|SLOT_BACK
	pin = /obj/item/firing_pin/explorer

/obj/item/gun/projectile/ballistic/p90/custom/update_icon_state()
	. = ..()
	icon_state = "p90smgC-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 6) : "e"]"
