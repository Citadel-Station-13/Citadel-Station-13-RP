/datum/caliber/foam
	caliber = "donksoft"

/obj/item/ammo_casing/foam
	name = "foam dart"
	desc = "A soft projectile made out of orange foam with a blue plastic tip."
	projectile_type = /obj/projectile/bullet/reusable/foam
	caliber = "foamdart"
	icon_state = "foamdart"
	throw_force = 0 //good luck hitting someone with the pointy end of the arrow
	throw_speed = 3
	casing_flags = CASING_DELETE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/ammo_casing/foam/riot
	name = "riot dart"
	desc = "A flexible projectile made out of hardened orange foam with a red plastic tip."
	projectile_type = /obj/projectile/bullet/reusable/foam/riot
	icon_state = "foamdart_riot"

//Foam
/obj/item/ammo_magazine/mfoam
	name = "abstract toy magazine"
	desc = "You shouldn't be seeing this, contact a Maintainer!"
	icon_state = "toy_pistol"
	mag_type = MAGAZINE
	materials_base = list(MAT_PLASTIC = 480)
	caliber = "foamdart"
	ammo_preload = /obj/item/ammo_casing/foam
	ammo_max = 8
	multiple_sprites = 1

//Foam Pistol
/obj/item/ammo_magazine/mfoam/pistol
	name = "toy pistol magazine"
	desc = "A plastic pistol magazine for foam darts!"

/obj/item/ammo_magazine/mfoam/pistol/empty
	ammo_current = 0

/obj/item/ammo_magazine/mfoam/pistol/riot
	name = "toy pistol magazine (riot)"
	ammo_preload = /obj/item/ammo_casing/foam/riot

//Foam c20r
/obj/item/ammo_magazine/mfoam/c20
	name = "toy c20r magazine"
	desc = "A plastic recreation of the classic c20r submachine gun."
	icon_state = "toy_c20"
	materials_base = list(MAT_PLASTIC = 1500)
	ammo_max = 20

/obj/item/ammo_magazine/mfoam/c20/empty
	ammo_current = 0

/obj/item/ammo_magazine/mfoam/c20/riot
	name = "toy c20r magazine (riot)"
	ammo_preload = /obj/item/ammo_casing/foam/riot

//Foam LMG
/obj/item/ammo_magazine/mfoam/lmg
	name = "toy magazine box"
	desc = "A heavy plastic box designed to hold belts of foam darts! Wow!"
	icon_state = "toy_lmg"
	materials_base = list(MAT_PLASTIC = 10000)
	w_class = WEIGHT_CLASS_NORMAL
	ammo_max = 50

/obj/item/ammo_magazine/mfoam/lmg/empty
	ammo_current = 0

/obj/item/ammo_magazine/mfoam/lmg/riot
	name = "toy magazine box (riot)"
	ammo_preload = /obj/item/ammo_casing/foam/riot

//Foam SMGs
/obj/item/ammo_magazine/mfoam/smg
	name = "toy submachine gun magazine"
	desc = "A plastic recreation of a double-stack submachine gun magazine."
	icon_state = "toy_smg"
	materials_base = list(MAT_PLASTIC = 1200)
	ammo_max = 20

/obj/item/ammo_magazine/mfoam/smg/empty
	ammo_current = 0

/obj/item/ammo_magazine/mfoam/smg/riot
	name = "toy submachine gun magazine (riot)"
	ammo_preload = /obj/item/ammo_casing/foam/riot

