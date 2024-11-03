/datum/prototype/design/ammo/shotgun
	abstract_type = /datum/prototype/design/ammo/shotgun
	work = 2 SECONDS

/datum/prototype/design/ammo/shotgun/blank
	id = "AmmoShotshellBlank"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/blank

/datum/prototype/design/ammo/shotgun/beanbag
	id = "AmmoShotshellBeanbag"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/beanbag

/datum/prototype/design/ammo/shotgun/slug
	id = "AmmoShotshellSlug"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g

/datum/prototype/design/ammo/shotgun/flare
	id = "AmmoShotshellFlare"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/flare

/datum/prototype/design/ammo/shotgun/buckshot
	id = "AmmoShotshellBuckshot"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/pellet

/datum/prototype/design/ammo/shotgun/stun
	id = "AmmoShotshellStun"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/stunshell

/datum/prototype/design/ammo/shotgun/clip
	abstract_type = /datum/prototype/design/ammo/shotgun/clip

/datum/prototype/design/ammo/shotgun/clip/dual
	abstract_type = /datum/prototype/design/ammo/shotgun/clip/dual
	work = 5 SECONDS

/datum/prototype/design/ammo/shotgun/clip/dual/beanbag
	id = "ClipShotgunBeanbag2"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/a12g/clip/beanbag

/datum/prototype/design/ammo/shotgun/clip/dual/slug
	id = "ClipShotgunSlug2"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/a12g/clip

/datum/prototype/design/ammo/shotgun/clip/dual/buckshot
	id = "ClipShotgunBuckshot2"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/a12g/clip/pellet

/datum/prototype/design/ammo/shotgun/pouch
	id = "ShotgunShellPouch"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/a12g/pouch
