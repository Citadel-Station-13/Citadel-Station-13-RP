

///////// 5mm Caseless /////////

/obj/item/ammo_magazine/m5mmcaseless
	name = "prototype rifle magazine (5mm caseless)"
	ammo_preload = /obj/item/ammo_casing/a5mmcaseless
	icon_state = "caseless-mag"
	caliber = "5mm caseless"
	mag_type = MAGAZINE
	ammo_max = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m5mmcaseless/stun
	icon_state = "caseless-mag-alt"
	ammo_preload = /obj/item/ammo_casing/a5mmcaseless/stun

//* 9mm

//NTLES

/obj/item/ammo_magazine/m57x28mm//* ntles	ammo_max = 30

/obj/item/ammo_magazine/m57x28mm/ntles/ap
	name = "magazine (5.7x28mm armor piercing)"
	ammo_mark = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap

/obj/item/ammo_magazine/m57x28mm/ntles/hp
	name = "magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/ntles/hunter
	name = "magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/ntles/empty
	ammo_current = 0

/obj/item/ammo_magazine/m57x28mm/ntles/highcap
	name = "high capacity magazine (5.7x28mm)"
	icon_state = "ntles_highcap"
	ammo_max = 50
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_magazine/m57x28mm/ntles/highcap/ap
	name = "high capacity magazine (5.7x28mm armor piercing)"
	ammo_mark = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap
/obj/item/ammo_magazine/m57x28mm/ntles/highcap/hp
	name = "high capacity magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/ntles/highcap/hunter
	name = "high capacity magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/ntles/highcap/empty
	ammo_current = 0

//Harpy SMG

/obj/item/ammo_magazine/m57x28mm/smg
	name = "NT-SMG-8 magazine (5.7x28mm)"
	desc = "A compact double stack aluminum magazine."
	icon_state = "combatsmg"
	ammo_max = 40

/obj/item/ammo_magazine/m57x28mm/smg/ap
	name = "NT-SMG-8 magazine (5.7x28mm armor piercing)"
	ammo_mark = "cmbtsmg_ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap

//Fiveseven mags
/obj/item/ammo_magazine/m57x28mm/fiveseven
	name = "fiveseven magazine (5.7x28mm)"
	desc = "A sturdy double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon_state = "fiveseven"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	materials_base = list(MAT_STEEL = 300, MAT_COPPER = 300)
	caliber = "5.7x28mm"
	ammo_preload = /obj/item/ammo_casing/a57x28mm
	ammo_max = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m57x28mm/fiveseven/ap
	name = "magazine (5.7x28mm armor piercing)"
	ammo_mark = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap

/obj/item/ammo_magazine/m57x28mm/fiveseven/hp
	name = "magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/fiveseven/hunter
	name = "magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/fiveseven/empty
	ammo_current = 0

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap
	name = "high capacity fiveseven magazine (5.7x28mm)"
	desc = "A sturdy, extra long double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon_state = "fiveseven_highcap"
	ammo_max = 30
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/ap
	name = "high capacity magazine (5.7x28mm armor piercing)"
	ammo_mark = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap
/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/hp
	name = "high capacity magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/hunter
	name = "high capacity magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/empty
	ammo_current = 0

//p90
/obj/item/ammo_magazine/m57x28mmp90
	name = "high capacity top mounted magazine (5.7x28mm armor-piercing)"
	icon_state = "p90"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap
	materials_base = list(MAT_STEEL = 1500, MAT_COPPER = 1500)
	caliber = "5.7x28mm"
	ammo_max = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m57x28mmp90/hunter
	name = "high capacity top mounted magazine (5.7x28mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mmp90/empty
	ammo_current = 0



//* 7.62mm
/obj/item/ammo_magazine/m762
	name = "magazine (7.62mm)"
	icon_state = "m762-small"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 2000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762m // Intentionally not a subtype of m762 because it's supposed to be incompatible with the Z8 Bulldog rifle.
	name = "magazine (7.62mm)"
	icon_state = "m762"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 4000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m762m/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762m/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762garand
	name = "garand clip (7.62mm)" // The clip goes into the magazine, hence the name. I'm very sure this is correct.
	icon_state = "gclip"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 1600)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m762garand/ap
	name = "garand clip (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762garand/hunter
	name = "garand clip (7.62mm Hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/hunter

/obj/item/ammo_magazine/m762garand/sniperhunter
	name = "garand clip (7.62mm HV Hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/sniperhunter

/obj/item/ammo_magazine/m762/empty
	ammo_current = 0

/obj/item/ammo_magazine/clip/c762
	name = "ammo clip (7.62mm)"
	icon_state = "clip_rifle"
	caliber = "7.62mm"
	ammo_preload = /obj/item/ammo_casing/a762
	materials_base = list(MAT_STEEL = 1000) // metal costs are very roughly based around one 7.62 casing = 200 metal
	ammo_max = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c762/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/c762/practice
	name = "rifle clip (7.62mm practice)"
	ammo_preload = /obj/item/ammo_casing/a762/practice

/obj/item/ammo_magazine/clip/c762/hunter
	name = "rifle clip (7.62mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/hunter

/obj/item/ammo_magazine/clip/c762/sniper
	name = "rifle clip (7.62mm HV)"
	ammo_preload = /obj/item/ammo_casing/a762/sniper

/obj/item/ammo_magazine/clip/c762/sniperhunter
	name = "rifle clip (7.62mm HV hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/sniperhunter

/obj/item/ammo_magazine/clip/c762/silver
	name = "rifle clip (7.62mm silver)"
	icon_state = "agclip_rifle"
	ammo_preload = /obj/item/ammo_casing/a762/silver
	materials_base = list(MAT_STEEL = 1500, MAT_SILVER = 750)

/obj/item/ammo_magazine/m762svd
	name = "\improper SVD magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 2000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762svd/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762_mg42
	name = "antique ammo drum (7.62mm)"
	icon_state = "mg42_drum"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 10000)
	ammo_preload = /obj/item/ammo_casing/a762
	w_class = ITEMSIZE_NORMAL
	ammo_max = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m762_mg42/ap
	name = "antique ammo drum box (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762_mg42/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762_m60
	name = "M60 belt (7.62mm)"
	icon_state = "M60MAG"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 20000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 75
	multiple_sprites = 1

/obj/item/ammo_magazine/m762_m60/empty
	ammo_current = 0


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

/obj/item/ammo_magazine/caps
	name = "speedloader (caps)"
	icon_state = "T38"
	caliber = "caps"
	color = "#FF0000"
	ammo_preload = /obj/item/ammo_casing/cap
	materials_base = list(MAT_STEEL = 600)
	ammo_max = 7
	multiple_sprites = 1

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
	w_class = ITEMSIZE_NORMAL
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

