/datum/caliber/phoron_shard
	caliber = "phoron-shrapnel"

//* Ammunition *//

/obj/item/ammo_casing/phoron_shrap
	name = "phoron shrapnel"
	desc = "Should you really be holding this?"
	caliber = "phoron shrapnel"
	icon_state = "phoronshrap"
	projectile_type = /obj/projectile/bullet/incendiary/phoronshrap
	casing_flags = CASING_DELETE

//* Magazine *//

/obj/item/ammo_magazine/mphoronshot
	name = "compressed phoron matter container"
	desc = "A compressed matter container meant for the Gorlex SHRAPNEL-SPITTER SMG. Contains a phoron alloy that self-oxidzes and ignites on contact with air. \n \nThey're in good shape for the shape they're in, \nbut God, I wonder how they think they can win, \nwith phoron rolling down their skin."
	ammo_max = 40
	regex_this_caliber = /datum/caliber/phoron_shard
	ammo_type = /obj/item/ammo_casing/phoron_shrap
	icon_state = "spitterammo"
	multiple_sprites = 1
