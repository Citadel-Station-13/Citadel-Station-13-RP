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
	magazine_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(60,30,20), dispersion=list(0.0, 0.3, 0.6))
	)

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/loaded
	magazine_type = /obj/item/ammo_magazine/m9mmAdvanced

