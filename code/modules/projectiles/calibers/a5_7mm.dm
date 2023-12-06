/datum/caliber/a5_7mm
	caliber = "5.7x28mm"

//* Casings

#warn a5_7mm/
/obj/item/ammo_casing/a57x28mm
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	desc = "A 5.7x28mm bullet casing."
	regex_this_caliber = /datum/caliber/a5_7mm
	projectile_type = /obj/projectile/bullet/pistol/lap
	materials_base = list(MAT_STEEL = 30, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/ap
	desc = "A 5.7x28mm armor-piercing bullet casing."
	icon_state = "small-reinf"
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials_base = list(MAT_STEEL = 80, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/hp
	icon_state = "small-tech"
	desc = "A 5.7x28mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp
	materials_base = list(MAT_STEEL = 60, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/hunter
	desc = "A 5.7x28mm hunting bullet casing."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials_base = list(MAT_STEEL = 30, MAT_COPPER = 50)

//* Magazines

/obj/item/ammo_magazine/a5_7mm
	ammo_caliber = /datum/caliber/a5_7mm

#warn a5_7mm/
/obj/item/ammo_magazine/m57x28mm/ntles
	name = "magazine (5.7x28mm)"
	desc = "A durable top-loading magazine, designed for withstanding rough treatment."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "ntles-1"
	base_icon_state = "ntles"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_max = 20

/obj/item/ammo_magazine/m57x28mm/ntles/ap
	name = "magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap

/obj/item/ammo_magazine/m57x28mm/ntles/hp
	name = "magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/ntles/hunter
	name = "magazine (5.7x28mm hunter)"
	rendering_static_overlay = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/ntles/empty
	ammo_current = 0

/obj/item/ammo_magazine/m57x28mm/ntles/highcap
	name = "high capacity magazine (5.7x28mm)"
	icon_state = "ntles-high-1"
	base_icon_state = "ntles-high"
	ammo_max = 50

/obj/item/ammo_magazine/m57x28mm/ntles/highcap/ap
	name = "high capacity magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap
/obj/item/ammo_magazine/m57x28mm/ntles/highcap/hp
	name = "high capacity magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/ntles/highcap/hunter
	name = "high capacity magazine (5.7x28mm hunter)"
	rendering_static_overlay = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/ntles/highcap/empty
	ammo_current = 0

//Harpy SMG

/obj/item/ammo_magazine/m57x28mm/smg
	name = "NT-SMG-8 magazine (5.7x28mm)"
	desc = "A compact double stack aluminum magazine."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "harpy"
	rendering_count = 1
	rendering_system = GUN_RENDERING_STATES
	ammo_max = 40

/obj/item/ammo_magazine/m57x28mm/smg/ap
	name = "NT-SMG-8 magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap

//Fiveseven mags
/obj/item/ammo_magazine/m57x28mm/fiveseven
	name = "fiveseven magazine (5.7x28mm)"
	desc = "A sturdy double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "fiveseven-0"
	base_icon_state = "fiveseven"
	materials_base = list(MAT_STEEL = 300)
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_caliber = /datum/caliber/a5_7mm
	ammo_preload = /obj/item/ammo_casing/a57x28mm
	ammo_max = 20

/obj/item/ammo_magazine/m57x28mm/fiveseven/ap
	name = "magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap

/obj/item/ammo_magazine/m57x28mm/fiveseven/hp
	name = "magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/fiveseven/hunter
	name = "magazine (5.7x28mm hunter)"
	rendering_static_overlay = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/fiveseven/empty
	ammo_current = 0

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap
	name = "high capacity fiveseven magazine (5.7x28mm)"
	desc = "A sturdy, extra long double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon_state = "fiveseven-high-1"
	base_icon_state = "fiveseven-high"
	ammo_max = 30

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/ap
	name = "high capacity magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ap"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap
/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/hp
	name = "high capacity magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "hp"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/hunter
	name = "high capacity magazine (5.7x28mm hunter)"
	rendering_static_overlay = "hunter"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap/empty
	ammo_current = 0

//p90
#warn a5_7mm/
/obj/item/ammo_magazine/m57x28mmp90
	name = "high capacity top mounted magazine (5.7x28mm armor-piercing)"
	icon_state = "p90-1"
	base_icon_state = "p90"
	rendering_system = GUN_RENDERING_STATES
	ammo_preload = /obj/item/ammo_casing/a57x28mm/ap
	ammo_max = 50

/obj/item/ammo_magazine/m57x28mmp90/hunter
	name = "high capacity top mounted magazine (5.7x28mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mmp90/empty
	ammo_current = 0
