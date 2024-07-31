/datum/caliber/phoron_shard
	caliber = "phoron-shrapnel"

/obj/item/ammo_magazine/mphoronshot
	name = "compressed phoron matter container"
	desc = "A compressed matter container meant for the Gorlex SHRAPNEL-SPITTER SMG. Contains a phoron alloy that self-oxidzes and ignites on contact with air. \n \nThey're in good shape for the shape they're in, \nbut God, I wonder how they think they can win, \nwith phoron rolling down their skin."
	max_ammo = 40
	regex_this_caliber = /datum/caliber/phoron_shard
	ammo_type = /obj/item/ammo_casing/phoron_shrap
	icon_state = "spitterammo"
	multiple_sprites = 1
