//* Magazines - Drums

#warn icon file

#warn a12g_drum
/obj/item/ammo_magazine/m12gdrum
	name = "magazine (12 gauge)"
	icon_state = "ashot-mag"
	mag_type = MAGAZINE
	ammo_caliber = CALIBER_12G
	materials_base = list(MAT_STEEL = 13000)
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_max = 24
	multiple_sprites = 1

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

#warn a12g_drum
/obj/item/ammo_magazine/holyshot_mag
	name = "blessed drum magazine (12 gauge)"
	icon_state = "holyshotgun_mag"
	desc = "Thrice-blessed, this drum magazine is loaded with silver shot designed to combat supernatural threats."
	mag_type = MAGAZINE
	ammo_caliber = CALIBER_12G
	materials_base = list(MAT_STEEL = 100, MAT_SILVER = 1100)
	ammo_preload = /obj/item/ammo_casing/a12g/silver
	ammo_max = 12

/obj/item/ammo_magazine/holyshot_mag/stake
	name = "blessed drum magazine (stakes)"
	desc = "Thrice-blessed, this drum magazine is loaded with wooden stakes soaked in sacred oils."
	ammo_preload = /obj/item/ammo_casing/a12g/stake

//* Magazines - Clips

#warn a12g_clip
/obj/item/ammo_magazine/clip/c12g
	name = "ammo clip (12g slug)"
	icon_state = "12gclipslug" // Still a placeholder sprite. Feel free to make a better one.
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with slugs."
	ammo_caliber = CALIBER_12G
	ammo_preload = /obj/item/ammo_casing/a12g
	materials_base = list(MAT_STEEL = 1070) // slugs shells x2 + 350 metal for the clip itself.
	ammo_max = 2
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c12g/pellet
	name = "ammo clip (12g buckshot)"
	icon_state = "12gclipshell"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with buckshot."
	ammo_preload = /obj/item/ammo_casing/a12g/pellet
	materials_base = list(MAT_STEEL = 1070) // buckshot and slugs cost the same

/obj/item/ammo_magazine/clip/c12g/beanbag
	name = "ammo clip (12g beanbag)"
	icon_state = "12gclipbean"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with beanbags."
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag
	materials_base = list(MAT_STEEL = 710) //beanbags x2 + 350 metal

/obj/item/ammo_magazine/clip/c12g/silver
	name = "ammo clip (12g buckshot)"
	icon_state = "12gclipag"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with silver buckshot."
	ammo_preload = /obj/item/ammo_casing/a12g/silver
	materials_base = list(MAT_STEEL = 1070, MAT_SILVER = 480)

//* Magazines - Pouches

#warn a12g_pouch
/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	ammo_caliber = CALIBER_12G
	ammo_preload = null
	materials_base = list(MAT_STEEL = 1440)
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_current = 0
	ammo_max = 4
	multiple_sprites = 1
	var/marking_color

/obj/item/ammo_magazine/shotholder/update_icon()
	. = ..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I

/obj/item/ammo_magazine/shotholder/full
	ammo_current = 4

/obj/item/ammo_magazine/shotholder/full/slug
	name = "shotgun slug holder (slug)"
	marking_color = PIPE_COLOR_BLACK
	ammo_preload = /obj/item/ammo_casing/a12g

/obj/item/ammo_magazine/shotholder/full/flare
	name = "shotgun slug holder (flare)"
	marking_color = COLOR_RED_GRAY
	ammo_preload = /obj/item/ammo_casing/a12g/flare

/obj/item/ammo_magazine/shotholder/full/buckshot
	name = "shotgun slug holder (buckshot)"
	marking_color = COLOR_RED
	ammo_preload = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/shotholder/full/beanbag
	name = "shotgun slug holder (beanbag)"
	marking_color = COLOR_GREEN
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/shotholder/full/stun
	name = "shotgun slug holder (stun)"
	marking_color = PIPE_COLOR_YELLOW
	ammo_preload = /obj/item/ammo_casing/a12g/stunshell

//* Casings
/obj/item/ammo_casing/a12g
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	ammo_caliber = CALIBER_12G
	projectile_type = /obj/projectile/bullet/shotgun
	materials_base = list(MAT_STEEL = 360)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/a12g/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun

/obj/item/ammo_casing/a12g/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/projectile/bullet/shotgun/beanbag
	materials_base = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a12g/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improvshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_improvised
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/a12g/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/energy/electrode/stunshot
	materials_base = list(MAT_STEEL = 360, MAT_GLASS = 720)

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/a12g/flare
	name = "flare shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/projectile/energy/flash/flare
	materials_base = list(MAT_STEEL = 90, MAT_GLASS = 90)

//Silver 12g
/obj/item/ammo_casing/a12g/silver
	name = " Silver shotgun shell"
	desc = "A 12 gauge slug. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "agshell"
	ammo_caliber = CALIBER_12G
	projectile_type = /obj/projectile/bullet/pellet/shotgun/silver
	materials_base = list(MAT_STEEL = 360, MAT_SILVER = 240)

//Wooden Stake 12g
/obj/item/ammo_casing/a12g/stake
	name = "Wooden stake shell"
	desc = "A specialized shell designed to launch a wooden stake. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "agshell"
	ammo_caliber = CALIBER_12G
	projectile_type = /obj/projectile/bullet/shotgun/stake
	materials_base = list(MAT_STEEL = 500)

//Techshell & Derivatives
/obj/item/ammo_casing/a12g/techshell
	name = "unloaded technological shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	icon_state = "cshell"
	ammo_caliber = CALIBER_12G
	projectile_type = null
	materials_base = list(MAT_STEEL = 500, MAT_PHORON = 200)

/obj/item/ammo_casing/a12g/techshell/meteorslug
	name = "meteorslug shell"
	desc = "A shotgun shell rigged with CMC technology, which launches a massive slug when fired."
	icon_state = "mshell"
	projectile_type = /obj/projectile/meteor/slug
	materials_base = list(MAT_STEEL = 500, MAT_GOLD = 200)

/obj/item/ammo_casing/a12g/techshell/emp
	name = "ion shell"
	desc = "An advanced shotgun round that creates a small EMP when it strikes a target."
	icon_state = "empshell"
	projectile_type = /obj/projectile/scatter/ion
//	projectile_type = /obj/projectile/bullet/shotgun/ion
	materials_base = list(MAT_STEEL = 360, MAT_URANIUM = 240)

/obj/item/ammo_casing/a12g/techshell/pulseslug
	name = "pulse slug"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "plshell"
	projectile_type = /obj/projectile/beam/pulse/shotgun
	materials_base = list(MAT_STEEL = 500, MAT_SILVER = 200)

/obj/item/ammo_casing/a12g/techshell/dragonsbreath
	name = "dragonsbreath shell"
	desc = "A shotgun shell which fires a spread of incendiary pellets."
	icon_state = "ishell"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun

/obj/item/ammo_casing/a12g/techshell/frag12
	name = "FRAG-12 slug"
	desc = "A high explosive breaching round for a 12 gauge shotgun."
	icon_state = "heshell"
	projectile_type = /obj/projectile/bullet/shotgun/frag12
	materials_base = list(MAT_STEEL = 500, MAT_PHORON = 200)

/obj/item/ammo_casing/a12g/techshell/laserslug
	name = "scatter laser shell"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a scatter laser weapon in a ballistic package."
	icon_state = "lshell"
	projectile_type = /obj/projectile/scatter/laser
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)
