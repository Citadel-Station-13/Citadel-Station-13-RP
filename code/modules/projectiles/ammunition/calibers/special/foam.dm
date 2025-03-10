/datum/ammo_caliber/foam
	id = "foam"
	caliber = "foam"

//* Ammunition *//

/obj/item/ammo_casing/foam
	name = "foam dart"
	desc = "A soft projectile made out of orange foam with a blue plastic tip."
	projectile_type = /obj/projectile/bullet/reusable/foam
	casing_caliber = /datum/ammo_caliber/foam
	icon = 'icons/modules/projectiles/casings/foam.dmi'
	icon_state = "dart"
	throw_force = 0
	throw_speed = 3
	casing_flags = CASING_DELETE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/ammo_casing/foam/riot
	name = "riot dart"
	desc = "A flexible projectile made out of hardened orange foam with a red plastic tip."
	projectile_type = /obj/projectile/bullet/reusable/foam/riot
	icon_state = "dart-riot"

//* Magazines *//

// todo: should the type filtering be on the gun or on the magazine? probably the magazine tbh.

/obj/item/ammo_magazine/foam
	name = "abstract toy magazine"
	desc = "You shouldn't be seeing this, contact a Maintainer!"

	icon = 'icons/modules/projectiles/magazines/foam.dmi'

	materials_base = list(MAT_PLASTIC = 480)
	ammo_caliber = /datum/ammo_caliber/foam
	ammo_preload = /obj/item/ammo_casing/foam
	ammo_max = 8

/obj/item/ammo_magazine/foam/box
	name = "box of foam darts"
	desc = "It has a picture of some foam darts on it."

	icon_state = "box"
	base_icon_state = "box"
	inhand_state = "box"

	ammo_max = 30

	drop_sound = 'sound/items/drop/ammobox.ogg'
	pickup_sound = 'sound/items/pickup/ammobox.ogg'

/obj/item/ammo_magazine/foam/box/riot
	name = "box of riot darts"
	desc = "It has a picture of some angry looking foam darts on it."

	icon_state = "box-riot"
	base_icon_state = "box-riot"

	ammo_preload = /obj/item/ammo_casing/foam/riot

/obj/item/ammo_magazine/foam/pistol
	name = "toy pistol magazine"
	desc = "A plastic pistol magazine for foam darts!"

	icon_state = "pistol-1"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/foam/pistol/empty
	icon_state = "pistol-0"

	ammo_current = 0

/obj/item/ammo_magazine/foam/pistol/riot
	name = "toy pistol magazine (riot)"

	icon_state = "pistol-riot-1"
	base_icon_state = "pistol-riot"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	ammo_preload = /obj/item/ammo_casing/foam/riot

/obj/item/ammo_magazine/foam/lmg
	name = "toy magazine box"
	desc = "A heavy plastic box designed to hold belts of foam darts! Wow!"

	icon_state = "lmg-1"
	base_icon_state = "lmg"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	materials_base = list(MAT_PLASTIC = 10000)
	w_class = WEIGHT_CLASS_NORMAL
	ammo_max = 50

/obj/item/ammo_magazine/foam/lmg/empty
	ammo_current = 0

/obj/item/ammo_magazine/foam/lmg/riot
	name = "toy magazine box (riot)"

	icon_state = "lmg-riot-1"
	base_icon_state = "lmg-riot"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	ammo_preload = /obj/item/ammo_casing/foam/riot

/obj/item/ammo_magazine/foam/smg
	name = "toy submachine gun magazine"
	desc = "A plastic recreation of a double-stack submachine gun magazine."

	icon_state = "smg-1"
	base_icon_state = "smg"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	materials_base = list(MAT_PLASTIC = 1200)
	ammo_max = 20

/obj/item/ammo_magazine/foam/smg/empty
	icon_state = "smg-0"

	ammo_current = 0

/obj/item/ammo_magazine/foam/smg/riot
	name = "toy submachine gun magazine (riot)"

	icon_state = "smg-riot-1"
	base_icon_state = "smg-riot"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	ammo_preload = /obj/item/ammo_casing/foam/riot
