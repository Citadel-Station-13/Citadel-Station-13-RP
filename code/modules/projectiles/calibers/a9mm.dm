/datum/caliber/a9mm
	caliber = "9mm"

/obj/item/ammo_casing/a9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/pistol
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a9mm/ap
	desc = "A 9mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials_base = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/hp
	desc = "A 9mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp

/obj/item/ammo_casing/a9mm/hunter
	desc = "A 9mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials_base = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/flash
	desc = "A 9mm flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/energy/flash

/obj/item/ammo_casing/a9mm/rubber
	desc = "A 9mm rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a9mm/practice
	desc = "A 9mm practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/practice

/obj/item/ammo_casing/a9mm/silver
	desc = "A 9mm silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag-casing"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 130, MAT_SILVER = 100)

/obj/item/ammo_magazine/m9mm
	name = "magazine (9mm)"
	icon_state = "9x19p_fullsize"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	materials_base = list(MAT_STEEL = 600)
	caliber = "9mm"
	ammo_preload = /obj/item/ammo_casing/a9mm
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/large
	desc = "\"FOR LAW ENFORCEMENT/MILITARY USE ONLY\" is clearly etched on the magazine. This is probably illegal for you to have." // Remember, Security is not Law Enforcement, so it's illegal for Security to use as well.
	icon_state = "9x19p_highcap"
	ammo_max = 17
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_magazine/m9mm/large/licensed // Sold by traders.
	desc = "A large capacity magazine produced via a joint NT-Hephaestus license, making it legal to own."

/obj/item/ammo_magazine/m9mm/large/licensed/hp // Hollow Point Version
	name = "magazine (9mm hollow-point)"
	ammo_preload = /obj/item/ammo_casing/a9mm/hp

/obj/item/ammo_magazine/m9mm/empty
	ammo_current = 0

/obj/item/ammo_magazine/m9mm/flash
	name = "magazine (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mm/practice
	name = "magazine (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

// Compact
/obj/item/ammo_magazine/m9mm/compact
	name = "compact magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	materials_base = list(MAT_STEEL = 480)
	caliber = "9mm"
	ammo_preload = /obj/item/ammo_casing/a9mm
	ammo_max = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/compact/empty
	ammo_current = 0

/obj/item/ammo_magazine/m9mm/compact/flash
	name = "compact magazine (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mm/compact/rubber
	name = "compact magazine (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mm/compact/practice
	name = "compact magazine (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/m9mm/compact/double
	name = "compact magazine (9mm double stack)"
	materials_base = list(MAT_STEEL = 900)
	ammo_max = 16

// SMG
/obj/item/ammo_magazine/m9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a9mm
	materials_base = list(MAT_STEEL = 1200)
	caliber = "9mm"
	ammo_max = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmt/empty
	ammo_current = 0

/obj/item/ammo_magazine/m9mmt/hunter
	name = "top mounted magazine (9mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a9mm/hunter

/obj/item/ammo_magazine/m9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mmt/flash
	name = "top mounted magazine (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/clip/c9mm
	name = "ammo clip (9mm)"
	#warn stripper clip file (small)
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 9mm rounds into magazines."
	caliber = "9mm"
	ammo_preload = /obj/item/ammo_casing/a9mm
	materials_base = list(MAT_STEEL = 600) // metal costs are very roughly based around one 9mm casing = 60 metal
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c9mm/hunter
	name = "ammo clip (9mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a9mm/hunter

/obj/item/ammo_magazine/clip/c9mm/rubber
	name = "ammo clip (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/clip/c9mm/practice
	name = "ammo clip (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/clip/c9mm/flash
	name = "ammo clip (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/clip/c9mm/silver
	name = "ammo clip (9mm silver)"
	ammo_preload = /obj/item/ammo_casing/a9mm/silver
	icon_state = "clip_pistol_ag"
	materials_base = list(MAT_STEEL = 1300, MAT_SILVER = 1000)

/obj/item/ammo_magazine/m9mmAdvanced
	desc = "A very high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm bullets."
	icon_state = "S9mm"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a9mm
	materials_base = list(MAT_STEEL = 1200)
	caliber = "9mm"
	ammo_max = 21
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmAdvanced/ap
	desc = "A high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm armor piercing bullets."
	icon_state = "S9mm"
	ammo_preload = /obj/item/ammo_casing/a9mm/ap
	materials_base = list(MAT_STEEL = 2000)

/obj/item/ammo_magazine/m9mmR/saber/empty
	ammo_current = 0
