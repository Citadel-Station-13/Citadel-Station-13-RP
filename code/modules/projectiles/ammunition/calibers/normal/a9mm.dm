/datum/ammo_caliber/a9mm
	id = "a9mm"
	caliber = "9mm"

/obj/item/ammo_casing/a9mm
	desc = "A 9mm bullet casing."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	casing_caliber = /datum/ammo_caliber/a9mm
	projectile_type = /obj/projectile/bullet/pistol
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a9mm/ap
	desc = "A 9mm armor-piercing bullet casing."
	icon_state = "small-reinf"
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials_base = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/hp
	desc = "A 9mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp

/obj/item/ammo_casing/a9mm/hunter
	desc = "A 9mm hunting bullet casing."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials_base = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/flash
	desc = "A 9mm flash shell casing."
	icon_state = "small-tech"
	projectile_type = /obj/projectile/energy/flash

/obj/item/ammo_casing/a9mm/rubber
	desc = "A 9mm rubber bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a9mm/practice
	desc = "A 9mm practice bullet casing."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/practice

/obj/item/ammo_casing/a9mm/silver
	desc = "A 9mm silver bullet casing."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 40, MAT_SILVER = 30)

/obj/item/ammo_magazine/a9mm
	ammo_caliber = /datum/ammo_caliber/a9mm

/obj/item/ammo_magazine/a9mm
	name = "magazine (9mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "9x19-big-1"
	base_icon_state = "9x19-big"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	materials_base = list(MAT_STEEL = 600)
	ammo_preload = /obj/item/ammo_casing/a9mm
	ammo_max = 15

/obj/item/ammo_magazine/a9mm/large
	icon_state = "9x19-ext-1"
	base_icon_state = "9x19-ext"
	ammo_max = 21

/obj/item/ammo_magazine/a9mm/large/ap
	name = "magazine (9mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a9mm/ap

/obj/item/ammo_magazine/a9mm/large/hp
	name = "magazine (9mm hollow-point)"
	ammo_preload = /obj/item/ammo_casing/a9mm/hp

/obj/item/ammo_magazine/a9mm/empty
	icon_state = "9x19-big-0"
	ammo_current = 0

/obj/item/ammo_magazine/a9mm/flash
	name = "magazine (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/a9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/a9mm/practice
	name = "magazine (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/a9mm/silver
	name = "magazine (9mm silver)"
	ammo_preload = /obj/item/ammo_casing/a9mm/silver

// Compact
/obj/item/ammo_magazine/a9mm/compact
	name = "compact magazine (9mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "9x19-small-1"
	base_icon_state = "9x19-small"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	materials_base = list(MAT_STEEL = 480)
	ammo_preload = /obj/item/ammo_casing/a9mm
	ammo_max = 8

/obj/item/ammo_magazine/a9mm/compact/empty
	icon_state = "9x19-small-0"
	ammo_current = 0

/obj/item/ammo_magazine/a9mm/compact/flash
	name = "compact magazine (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/a9mm/compact/rubber
	name = "compact magazine (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/a9mm/compact/practice
	name = "compact magazine (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/a9mm/compact/silver
	name = "compact magazine (9mm silver)"
	icon_state = "9x19ag-small-1"
	base_icon_state = "9x19ag-small"
	ammo_preload = /obj/item/ammo_casing/a9mm/silver

/obj/item/ammo_magazine/a9mm/compact/double
	name = "compact magazine (9mm double stack)"
	materials_base = list(MAT_STEEL = 900)
	ammo_max = 16

// SMG
/obj/item/ammo_magazine/a9mm/top_mount
	name = "top mounted magazine (9mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "9mmt-5"
	base_icon_state = "9mmt"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5
	ammo_preload = /obj/item/ammo_casing/a9mm
	materials_base = list(MAT_STEEL = 1200)
	ammo_max = 20

/obj/item/ammo_magazine/a9mm/top_mount/empty
	icon_state = "9mmt-0"
	ammo_current = 0

/obj/item/ammo_magazine/a9mm/top_mount/hunter
	name = "top mounted magazine (9mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a9mm/hunter

/obj/item/ammo_magazine/a9mm/top_mount/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/a9mm/top_mount/flash
	name = "top mounted magazine (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/a9mm/top_mount/practice
	name = "top mounted magazine (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/a9mm/clip
	name = "ammo clip (9mm)"
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "pistol-10"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 10
	magazine_type = MAGAZINE_TYPE_CLIP
	desc = "A stripper clip for reloading 9mm rounds into magazines."
	ammo_preload = /obj/item/ammo_casing/a9mm
	materials_base = list(MAT_STEEL = 200)
	ammo_max = 10

/obj/item/ammo_magazine/a9mm/clip/hunter
	name = "ammo clip (9mm hunter)"
	ammo_preload = /obj/item/ammo_casing/a9mm/hunter

/obj/item/ammo_magazine/a9mm/clip/rubber
	name = "ammo clip (9mm rubber)"
	ammo_preload = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/a9mm/clip/practice
	name = "ammo clip (9mm practice)"
	ammo_preload = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/a9mm/clip/flash
	name = "ammo clip (9mm flash)"
	ammo_preload = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/a9mm/clip/silver
	name = "ammo clip (9mm silver)"
	ammo_preload = /obj/item/ammo_casing/a9mm/silver
	icon_state = "pistol-silver-10"
	base_icon_state = "pistol-silver"

/obj/item/ammo_magazine/a9mm/advanced_smg
	desc = "A very high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm bullets."
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "advsmg-1"
	base_icon_state = "advsmg"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_preload = /obj/item/ammo_casing/a9mm
	materials_base = list(MAT_STEEL = 700)
	ammo_max = 21

/obj/item/ammo_magazine/a9mm/advanced_smg/empty
	icon_state = "advsmg-0"
	ammo_current = 0

/obj/item/ammo_magazine/a9mm/advanced_smg/ap
	desc = "A high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm armor piercing bullets."
	ammo_preload = /obj/item/ammo_casing/a9mm/ap
