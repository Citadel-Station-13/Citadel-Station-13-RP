/datum/caliber/a5_7mm
	caliber = "5.7x28mm"

//* Casings

#warn a5_7mm/
/obj/item/ammo_casing/a57x28mm
	desc = "A 5.7x28mm bullet casing."
	regex_this_caliber = /datum/caliber/a5_7mm
	projectile_type = /obj/projectile/bullet/pistol/lap
	materials_base = list(MAT_STEEL = 30, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/ap
	desc = "A 5.7x28mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials_base = list(MAT_STEEL = 80, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/hp
	desc = "A 5.7x28mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp
	materials_base = list(MAT_STEEL = 60, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/hunter
	desc = "A 5.7x28mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials_base = list(MAT_STEEL = 30, MAT_COPPER = 50)

//* Magazines

#warn a5_7mm/
/obj/item/ammo_magazine/m57x28mm

/obj/item/ammo_magazine/m57x28mm/ntles
	name = "magazine"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	ammo_max = 20

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
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
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
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
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
