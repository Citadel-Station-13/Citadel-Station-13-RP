/obj/item/gun/projectile/ballistic/automatic/automat
	name = "Avtomat Rifle"
	desc = " A Bolt Action Rifle taken apart and retooled into a primitive machine gun. Bulky and obtuse, it still capable of unleashing devastating firepower with its 15 round internal drum magazine. Loads with 7.62 stripper clips."
	icon_state = "automat"
	item_state = "automat"
	fire_anim = "automat_fire"
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	caliber = "7.62mm"
	heavy = TRUE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3) //A real work around to a automatic rifle.
	slot_flags = SLOT_BACK
	load_method = SPEEDLOADER
	internal_ammo_preload = /obj/item/ammo_casing/a762
	ammo_type = /obj/item/ammo_casing/a762
	max_shells =  15
	burst = 3
	fire_delay = 7.2
	move_delay = 6
	burst_accuracy = list(60,30,15)
	dispersion = list(0.0, 0.6,1.0)

/obj/item/gun/projectile/ballistic/automatic/automat/holy
	ammo_type = /obj/item/ammo_casing/a762/silver
