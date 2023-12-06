/obj/item/gun/projectile/ballistic/automatic/advanced_smg
	name = "advanced SMG"
	desc = "The NT-S3W is an advanced submachine gun design, using a reflective laser optic for increased accuracy over competing models. Chambered for 9mm rounds."
	icon_state = "advanced_smg"
	w_class = ITEMSIZE_NORMAL
	load_method = MAGAZINE
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	magazine_type = null // R&D builds this. Starts unloaded.
	allowed_magazines = list(/obj/item/ammo_magazine/m9mmAdvanced, /obj/item/ammo_magazine/m9mm)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(60,30,20), dispersion=list(0.0, 0.3, 0.6))
	)

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/loaded
	magazine_type = /obj/item/ammo_magazine/m9mmAdvanced

/obj/item/gun/projectile/ballistic/automatic/c20r
	name = "submachine gun"
	desc = "The C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. It has 'Scarborough Arms - Per falcis, per pravitas' inscribed on the stock. Uses 10mm rounds."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = ITEMSIZE_NORMAL
	damage_force = 10
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m10mm
	allowed_magazines = list(/obj/item/ammo_magazine/m10mm)
	projectile_type = /obj/projectile/bullet/pistol/medium
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	one_handed_penalty = 15

/obj/item/gun/projectile/ballistic/automatic/c20r/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"

/obj/item/gun/projectile/ballistic/automatic/wt550
	name = "machine pistol"
	desc = "The WT550 Saber is a cheap self-defense weapon mass-produced by Ward-Takahashi for paramilitary and private use. Uses 9mm rounds."
	icon_state = "wt550"
	item_state = "wt550"
	w_class = ITEMSIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/a9mmr"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mmt/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m9mmt)
	projectile_type = /obj/projectile/bullet/pistol/medium

/obj/item/gun/projectile/ballistic/automatic/wt550/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"

/obj/item/gun/projectile/ballistic/automatic/wt550/lethal
	magazine_type = /obj/item/ammo_magazine/m9mmt
