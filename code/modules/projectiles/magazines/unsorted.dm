

///////// .75 Gyrojet /////////

/obj/item/ammo_magazine/m75
	name = "magazine (.75 Gyrojet)"
	icon_state = "m75"
	mag_type = MAGAZINE
	caliber = ".75"
	ammo_preload = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	ammo_max = 8

/obj/item/ammo_magazine/m75/empty
	ammo_current = 0

/obj/item/ammo_magazine/mcompressedbio
	name = "magazine (Compressed Biomatter)"
	desc = "An advanced matter compression unit, used to feed biomass into a Rapid On-board Fabricator. Accepts biomass globules."
	icon_state = "bio"
	mag_type = MAGAZINE
	caliber = "organic"
	ammo_preload = /obj/item/ammo_casing/organic
	materials_base = list("flesh" = 1000)
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/mcompressedbio/compact
	ammo_max = 10

/obj/item/ammo_magazine/mcompressedbio/large
	icon_state = "bio_large"
	ammo_max = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/mcompressedbio/large/banana
	icon_state = "bio_large_banana"

/obj/item/ammo_magazine/biovial
	name = "bio-vial (Liquid Wax)"
	desc = "Biological Munitions Vials, commonly referred to as bio-vials, contain liquid biomatter of some form, for use in exotic weapons systems. This one accepts wax globules."
	icon_state = "bio_vial"
	mag_type = MAGAZINE
	caliber = "apidean"
	ammo_preload = /obj/item/ammo_casing/organic/wax
	materials_base = list("wax" = 1000)
	ammo_max = 10
	multiple_sprites = 1
