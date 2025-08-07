/datum/ammo_caliber/a5_7mm
	id = "a5_7mm"
	caliber = "5.7x28mm"

//* Casings

/obj/item/ammo_casing/a5_7mm
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	desc = "A 5.7x28mm bullet casing."
	casing_caliber = /datum/ammo_caliber/a5_7mm
	projectile_type = /obj/projectile/bullet/pistol/lap
	materials_base = list(MAT_STEEL = 30, MAT_COPPER = 30)

/obj/item/ammo_casing/a5_7mm/ap
	desc = "A 5.7x28mm armor-piercing bullet casing."
	icon_state = "small-reinf"
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials_base = list(MAT_STEEL = 80, MAT_COPPER = 30)

/obj/item/ammo_casing/a5_7mm/hp
	icon_state = "small-tech"
	desc = "A 5.7x28mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp
	materials_base = list(MAT_STEEL = 60, MAT_COPPER = 30)

/obj/item/ammo_casing/a5_7mm/hunter
	desc = "A 5.7x28mm hunting bullet casing."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials_base = list(MAT_STEEL = 30, MAT_COPPER = 50)

//* Magazines

/obj/item/ammo_magazine/a5_7mm
	ammo_caliber = /datum/ammo_caliber/a5_7mm
	ammo_preload = /obj/item/ammo_casing/a5_7mm

/obj/item/ammo_magazine/a5_7mm/nt_les
	name = "magazine (5.7x28mm)"
	desc = "A durable top-loading magazine, designed for withstanding rough treatment."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "ntles-1"
	base_icon_state = "ntles"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_max = 20

/obj/item/ammo_magazine/a5_7mm/nt_les/ap
	name = "magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ntles-ap"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/ap

/obj/item/ammo_magazine/a5_7mm/nt_les/hp
	name = "magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "ntles-hp"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hp

/obj/item/ammo_magazine/a5_7mm/nt_les/hunter
	name = "magazine (5.7x28mm hunter)"
	rendering_static_overlay = "ntles-hunter"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hunter

/obj/item/ammo_magazine/a5_7mm/nt_les/empty
	ammo_current = 0

/obj/item/ammo_magazine/a5_7mm/nt_les/highcap
	name = "high capacity magazine (5.7x28mm)"
	icon_state = "ntles-high-1"
	base_icon_state = "ntles-high"
	ammo_max = 50

/obj/item/ammo_magazine/a5_7mm/nt_les/highcap/ap
	name = "high capacity magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "ntles-high-ap"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/ap
/obj/item/ammo_magazine/a5_7mm/nt_les/highcap/hp
	name = "high capacity magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "ntles-high-hp"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hp

/obj/item/ammo_magazine/a5_7mm/nt_les/highcap/hunter
	name = "high capacity magazine (5.7x28mm hunter)"
	rendering_static_overlay = "ntles-high-hunter"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hunter

/obj/item/ammo_magazine/a5_7mm/nt_les/highcap/empty
	ammo_current = 0

//Harpy SMG

/obj/item/ammo_magazine/a5_7mm/harpy_smg
	name = "NT-SMG-8 magazine (5.7x28mm)"
	desc = "A compact double stack aluminum magazine."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "harpy"
	rendering_count = 1
	rendering_system = GUN_RENDERING_STATES
	ammo_max = 40

/obj/item/ammo_magazine/a5_7mm/harpy_smg/ap
	name = "NT-SMG-8 magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "harpy-ap"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/ap

//Fiveseven mags
/obj/item/ammo_magazine/a5_7mm/five_seven
	name = "fiveseven magazine (5.7x28mm)"
	desc = "A sturdy double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "fiveseven-0"
	base_icon_state = "fiveseven"
	materials_base = list(MAT_STEEL = 300)
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_caliber = /datum/ammo_caliber/a5_7mm
	ammo_preload = /obj/item/ammo_casing/a5_7mm
	ammo_max = 20

/obj/item/ammo_magazine/a5_7mm/five_seven/ap
	name = "magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "fiveseven-ap"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/ap

/obj/item/ammo_magazine/a5_7mm/five_seven/hp
	name = "magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "fiveseven-hp"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hp

/obj/item/ammo_magazine/a5_7mm/five_seven/hunter
	name = "magazine (5.7x28mm hunter)"
	rendering_static_overlay = "fiveseven-hunter"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hunter

/obj/item/ammo_magazine/a5_7mm/five_seven/empty
	ammo_current = 0

/obj/item/ammo_magazine/a5_7mm/five_seven/highcap
	name = "high capacity fiveseven magazine (5.7x28mm)"
	desc = "A sturdy, extra long double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon_state = "fiveseven-high-1"
	base_icon_state = "fiveseven-high"
	ammo_max = 30

/obj/item/ammo_magazine/a5_7mm/five_seven/highcap/ap
	name = "high capacity magazine (5.7x28mm armor piercing)"
	rendering_static_overlay = "fiveseven-high-ap"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/ap
/obj/item/ammo_magazine/a5_7mm/five_seven/highcap/hp
	name = "high capacity magazine (5.7x28mm hollow-point)"
	rendering_static_overlay = "fiveseven-high-hp"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hp

/obj/item/ammo_magazine/a5_7mm/five_seven/highcap/hunter
	name = "high capacity magazine (5.7x28mm hunter)"
	rendering_static_overlay = "fiveseven-high-hunter"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hunter

/obj/item/ammo_magazine/a5_7mm/five_seven/highcap/empty
	ammo_current = 0

/obj/item/ammo_magazine/a5_7mm/p90
	name = "high capacity top mounted magazine (5.7x28mm armor-piercing)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "p90-1"
	base_icon_state = "p90"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_preload = /obj/item/ammo_casing/a5_7mm/ap
	ammo_max = 50

/obj/item/ammo_magazine/a5_7mm/p90/hunter
	name = "high capacity top mounted magazine (5.7x28mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a5_7mm/hunter

/obj/item/ammo_magazine/a5_7mm/p90/empty
	ammo_current = 0
