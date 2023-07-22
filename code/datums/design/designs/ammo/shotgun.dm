/datum/design/ammo/shotgun
	abstract_type = /datum/design/ammo/shotgun
	work = 2 SECONDS

/datum/design/ammo/shotgun/blank
	id = "AmmoShotshellBlank"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/blank

/datum/design/ammo/shotgun/beanbag
	id = "AmmoShotshellBeanbag"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/beanbag

/datum/design/ammo/shotgun/slug
	id = "AmmoShotshellSlug"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g

/datum/design/ammo/shotgun/flare
	id = "AmmoShotshellFlare"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/flare

/datum/design/ammo/shotgun/buckshot
	id = "AmmoShotshellBuckshot"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/pellet

/datum/design/ammo/shotgun/stun
	id = "AmmoShotshellStun"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_casing/a12g/stunshell

/datum/design/ammo/shotgun/clip
	abstract_type = /datum/design/ammo/shotgun/clip

/datum/design/ammo/shotgun/clip/dual
	abstract_type = /datum/design/ammo/shotgun/clip/dual
	work = 5 SECONDS

/datum/design/ammo/shotgun/clip/dual/beanbag
	id = "ClipShotgunBeanbag2"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/clip/c12g/beanbag

/datum/design/ammo/shotgun/clip/dual/slug
	id = "ClipShotgunSlug2"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/clip/c12g

/datum/design/ammo/shotgun/clip/dual/buckshot
	id = "ClipShotgunBuckshot2"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/clip/c12g/pellet

/datum/design/ammo/shotgun/pouch
	id = "ShotgunShellPouch"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/ammo_magazine/shotholder
