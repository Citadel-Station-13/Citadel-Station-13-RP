/datum/design/ammo/shotgun
	abstract_type = /datum/design/ammo/shotgun
	work = 2 SECONDS

/datum/design/ammo/shotgun/blank
	identifier = "AmmoShotshellBlank"
	build_path = /obj/item/ammo_casing/a12g/blank

/datum/design/ammo/shotgun/beanbag
	identifier = "AmmoShotshellBeanbag"
	build_path = /obj/item/ammo_casing/a12g/beanbag

/datum/design/ammo/shotgun/slug
	identifier = "AmmoShotshellSlug"
	build_path = /obj/item/ammo_casing/a12g

/datum/design/ammo/shotgun/flare
	identifier = "AmmoShotshellFlare"
	build_path = /obj/item/ammo_casing/a12g/flare

/datum/design/ammo/shotgun/buckshot
	identifier = "AmmoShotshellBuckshot"
	build_path = /obj/item/ammo_casing/a12g/pellet

/datum/design/ammo/shotgun/stun
	identifier = "AmmoShotshellStun"
	build_path = /obj/item/ammo_casing/a12g/stunshell

/datum/design/ammo/shotgun/clip
	abstract_type = /datum/design/ammo/shotgun/clip

/datum/design/ammo/shotgun/clip/dual
	abstract_type = /datum/design/ammo/shotgun/clip/dual
	work = 5 SECONDS

/datum/design/ammo/shotgun/clip/dual/beanbag
	identifier = "ClipShotgunBeanbag2"
	build_path = /obj/item/ammo_magazine/clip/c12g/beanbag

/datum/design/ammo/shotgun/clip/dual/slug
	identifier = "ClipShotgunSlug2"
	build_path = /obj/item/ammo_magazine/clip/c12g

/datum/design/ammo/shotgun/clip/dual/buckshot
	identifier = "ClipShotgunBuckshot2"
	build_path = /obj/item/ammo_magazine/clip/c12g/pellet
