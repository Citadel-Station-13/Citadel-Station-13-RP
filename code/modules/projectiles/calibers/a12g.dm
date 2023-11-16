//* Magazines - Drums

/datum/caliber/c12g
	caliber = "12g"
	diameter = 18.53
	length = 69.85

#warn a12g_drum
/obj/item/ammo_magazine/m12gdrum
	name = "magazine (12 gauge)"
	icon = 'icons/modules/projectile/magazines/magazine_drum.dmi'
	icon_state = "autoshotgun"
	base_icon_state = "autoshotgun"
	materials_base = list(MAT_STEEL = 13000)
	ammo_caliber = /datum/caliber/c12g
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_max = 24
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 2

/obj/item/ammo_magazine/m12gdrum/beanbag
	name = "magazine (12 gauge beanbag)"
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/m12gdrum/pellet
	name = "magazine (12 gauge pellet)"
	ammo_preload = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/m12gdrum/flare
	name = "magazine (12 gauge flash)"
	ammo_preload = /obj/item/ammo_casing/a12g/flare

/obj/item/ammo_magazine/m12gdrum/empty
	ammo_current = 0

#warn a12g_drum/holy
/obj/item/ammo_magazine/holyshot_mag
	name = "blessed drum magazine (12 gauge)"
	icon_state = "holyshotgun"
	base_icon_state = "holyshotgun"
	desc = "Thrice-blessed, this drum magazine is loaded with silver shot designed to combat supernatural threats."
	materials_base = list(MAT_STEEL = 100, MAT_SILVER = 1100)
	ammo_preload = /obj/item/ammo_casing/a12g/silver
	ammo_max = 12
	rendering_system = GUN_RENDERING_DISABLED

/obj/item/ammo_magazine/holyshot_mag/stake
	name = "blessed drum magazine (stakes)"
	desc = "Thrice-blessed, this drum magazine is loaded with wooden stakes soaked in sacred oils."
	ammo_preload = /obj/item/ammo_casing/a12g/stake

//* Magazines - Clips

#warn a12g_clip
/obj/item/ammo_magazine/clip/c12g
	name = "ammo clip (12g slug)"
	icon = 'icons/modules/projectiles/magazines/magazine_stripper.dmi'
	icon_state = "a12-slug-2"
	base_icon_state = "a12-slug"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with slugs."
	ammo_caliber = CALIBER_12G
	ammo_preload = /obj/item/ammo_casing/a12g
	materials_base = list(MAT_STEEL = 350) // slugs shells x2 + 350 metal for the clip itself.
	ammo_max = 2
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 2
	ammo_type_picky = TRUE
	ammo_type = /obj/item/ammo_casing/a12g
	is_speedloader = TRUE

/obj/item/ammo_magazine/clip/c12g/pellet
	name = "ammo clip (12g buckshot)"
	icon_state = "a12-buck-2"
	base_icon_state = "a12-buck"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with buckshot."
	ammo_preload = /obj/item/ammo_casing/a12g/pellet
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/clip/c12g/beanbag
	name = "ammo clip (12g beanbag)"
	icon_state = "a12-bean-2"
	base_icon_state = "a12-bean"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with beanbags."
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/clip/c12g/silver
	name = "ammo clip (12g buckshot)"
	icon_state = "a12-silver-2"
	base_icon_state = "a12-silver"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with silver buckshot."
	ammo_preload = /obj/item/ammo_casing/a12g/silver
	ammo_type = /obj/item/ammo_casing/a12g/silver

//* Magazines - Pouches

#warn a12g_pouch
/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon = 'icons/modules/projectiles/magazines/magazine_pouch.dmi'
	icon_state = "shotgun-clip-4"
	base_icon_state = "shotgun-clip"
	regex_this_caliber = /datum/caliber/c12g
	materials_base = list(MAT_STEEL = 1440)
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_current = 0
	ammo_max = 4
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 4

	var/marking_color

/obj/item/ammo_magazine/shotholder/update_icon()
	. = ..()
	if(marking_color)
		var/image/I = image(icon, "[base_icon_state]-marking")
		I.color = marking_color
		add_overlay(I)

/obj/item/ammo_magazine/shotholder/full
	ammo_current = 4

/obj/item/ammo_magazine/shotholder/full/slug
	name = "shotgun slug holder (slug)"
	marking_color = PIPE_COLOR_BLACK
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_type = /obj/item/ammo_casing/a12g

/obj/item/ammo_magazine/shotholder/full/flare
	name = "shotgun slug holder (flare)"
	marking_color = COLOR_RED_GRAY
	ammo_preload = /obj/item/ammo_casing/a12g/flare
	ammo_type = /obj/item/ammo_casing/a12g/flare

/obj/item/ammo_magazine/shotholder/full/buckshot
	name = "shotgun slug holder (buckshot)"
	marking_color = COLOR_RED
	ammo_preload = /obj/item/ammo_casing/a12g/pellet
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/shotholder/full/beanbag
	name = "shotgun slug holder (beanbag)"
	marking_color = COLOR_GREEN
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/shotholder/full/stun
	name = "shotgun slug holder (stun)"
	marking_color = PIPE_COLOR_YELLOW
	ammo_preload = /obj/item/ammo_casing/a12g/stunshell
	ammo_type = /obj/item/ammo_casing/a12g/stunshell

//* Casings
/obj/item/ammo_casing/a12g
	name = "slug shell"
	desc = "A 12 gauge slug."
	icon = 'icons/modules/projectiles/casings/shotgun.dmi'
	icon_state = "grey"
	regex_this_caliber = /datum/caliber/c12g
	projectile_type = /obj/projectile/bullet/shotgun
	materials_base = list(MAT_STEEL = 360)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/a12g/pellet
	name = "buckshot shell"
	desc = "A 12 gauge shell."
	icon_state = "red"
	projectile_type = /obj/projectile/bullet/pellet/shotgun

/obj/item/ammo_casing/a12g/blank
	name = "blank shell"
	desc = "A blank shell."
	icon_state = "white"
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/practice
	name = "practice shell"
	desc = "A practice shell."
	icon_state = "white"
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "green"
	projectile_type = /obj/projectile/bullet/shotgun/beanbag
	materials_base = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a12g/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improv"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_improvised
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)

/obj/item/ammo_casing/a12g/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stun"
	projectile_type = /obj/projectile/energy/electrode/stunshot
	materials_base = list(MAT_STEEL = 360, MAT_GLASS = 720)

/obj/item/ammo_casing/a12g/flare
	name = "flare shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "flare"
	projectile_type = /obj/projectile/energy/flash/flare
	materials_base = list(MAT_STEEL = 90, MAT_GLASS = 90)

/obj/item/ammo_casing/a12g/techshell
	name = "unloaded technological shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	icon_state = "tech"
	ammo_caliber = CALIBER_12G
	projectile_type = null
	materials_base = list(MAT_STEEL = 500, MAT_PHORON = 200)

/obj/item/ammo_casing/a12g/techshell/meteorslug
	name = "meteorslug shell"
	desc = "A shotgun shell rigged with CMC technology, which launches a massive slug when fired."
	icon_state = "meteor"
	projectile_type = /obj/projectile/meteor/slug
	materials_base = list(MAT_STEEL = 500, MAT_GOLD = 200)

/obj/item/ammo_casing/a12g/techshell/emp
	name = "ion shell"
	desc = "An advanced shotgun round that creates a small EMP when it strikes a target."
	icon_state = "emp"
	projectile_type = /obj/projectile/scatter/ion
//	projectile_type = /obj/projectile/bullet/shotgun/ion
	materials_base = list(MAT_STEEL = 360, MAT_URANIUM = 240)

/obj/item/ammo_casing/a12g/techshell/pulseslug
	name = "pulse slug"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "pulse"
	projectile_type = /obj/projectile/beam/pulse/shotgun
	materials_base = list(MAT_STEEL = 500, MAT_SILVER = 200)

/obj/item/ammo_casing/a12g/techshell/dragonsbreath
	name = "dragonsbreath shell"
	desc = "A shotgun shell which fires a spread of incendiary pellets."
	icon_state = "dragon"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun

/obj/item/ammo_casing/a12g/techshell/frag12
	name = "FRAG-12 slug"
	desc = "A high explosive breaching round for a 12 gauge shotgun."
	icon_state = "explosive"
	projectile_type = /obj/projectile/bullet/shotgun/frag12
	materials_base = list(MAT_STEEL = 500, MAT_PHORON = 200)

/obj/item/ammo_casing/a12g/techshell/laserslug
	name = "scatter laser shell"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a scatter laser weapon in a ballistic package."
	icon_state = "laser"
	projectile_type = /obj/projectile/scatter/laser
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)

/obj/item/ammo_casing/a12g/silver
	name = "Silver shotgun shell"
	desc = "A 12 gauge slug. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "stake"
	ammo_caliber = CALIBER_12G
	projectile_type = /obj/projectile/bullet/pellet/shotgun/silver
	materials_base = list(MAT_STEEL = 360, MAT_SILVER = 240)

/obj/item/ammo_casing/a12g/stake
	name = "Wooden stake shell"
	desc = "A specialized shell designed to launch a wooden stake. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "stake"
	ammo_caliber = CALIBER_12G
	projectile_type = /obj/projectile/bullet/shotgun/stake
	materials_base = list(MAT_STEEL = 500)
