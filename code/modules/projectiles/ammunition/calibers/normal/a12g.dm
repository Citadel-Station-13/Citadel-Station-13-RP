/datum/ammo_caliber/a12g
	id = "a12g"
	caliber = "12g"
	diameter = 18.53
	length = 69.85

//* Casings
/obj/item/ammo_casing/a12g
	name = "slug shell"
	desc = "A 12 gauge slug."
	icon = 'icons/modules/projectiles/casings/a12g.dmi'
	icon_state = "grey"
	casing_caliber = /datum/ammo_caliber/a12g
	projectile_type = /obj/projectile/bullet/shotgun
	materials_base = list(MAT_STEEL = 360)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')
	worth_intrinsic = 5

/obj/item/ammo_casing/a12g/pellet
	name = "buckshot shell"
	desc = "A 12 gauge shell."
	icon_state = "red"
	projectile_type = /obj/projectile/bullet/pellet/shotgun
	worth_intrinsic = 5

/obj/item/ammo_casing/a12g/blank
	name = "blank shell"
	desc = "A blank shell."
	icon_state = "white"
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)
	worth_intrinsic = 1.5

/obj/item/ammo_casing/a12g/practice
	name = "practice shell"
	desc = "A practice shell."
	icon_state = "white"
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)
	worth_intrinsic = 1.5

/obj/item/ammo_casing/a12g/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "green"
	projectile_type = /obj/projectile/bullet/shotgun/beanbag
	materials_base = list(MAT_STEEL = 180)
	worth_intrinsic = 3.5

/obj/item/ammo_casing/a12g/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improv"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_improvised
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)
	worth_intrinsic = 3.5

/obj/item/ammo_casing/a12g/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stun"
	projectile_type = /obj/projectile/energy/electrode/stunshot
	materials_base = list(MAT_STEEL = 360, MAT_GLASS = 720)
	worth_intrinsic = 7.5

/obj/item/ammo_casing/a12g/flare
	name = "flare shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "flare"
	projectile_type = /obj/projectile/energy/flash/flare
	materials_base = list(MAT_STEEL = 90, MAT_GLASS = 90)
	worth_intrinsic = 3.5

/obj/item/ammo_casing/a12g/techshell
	name = "unloaded technological shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	icon_state = "tech"
	projectile_type = null
	materials_base = list(MAT_STEEL = 500, MAT_PHORON = 200)
	worth_intrinsic = 30

/obj/item/ammo_casing/a12g/techshell/meteorslug
	name = "meteorslug shell"
	desc = "A shotgun shell rigged with CMC technology, which launches a massive slug when fired."
	icon_state = "meteor"
	projectile_type = /obj/projectile/meteor/slug
	materials_base = list(MAT_STEEL = 500, MAT_GOLD = 200)
	worth_intrinsic = 150

/obj/item/ammo_casing/a12g/techshell/emp
	name = "ion shell"
	desc = "An advanced shotgun round that creates a small EMP when it strikes a target."
	icon_state = "emp"
	projectile_type = /obj/projectile/scatter/ion
	materials_base = list(MAT_STEEL = 360, MAT_URANIUM = 240)
	worth_intrinsic = 50

/obj/item/ammo_casing/a12g/techshell/pulseslug
	name = "pulse slug"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "pulse"
	projectile_type = /obj/projectile/beam/pulse/shotgun
	materials_base = list(MAT_STEEL = 500, MAT_SILVER = 200)
	worth_intrinsic = 75

/obj/item/ammo_casing/a12g/techshell/dragonsbreath
	name = "dragonsbreath shell"
	desc = "A shotgun shell which fires a spread of incendiary pellets."
	icon_state = "dragon"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun
	worth_intrinsic = 75

/obj/item/ammo_casing/a12g/techshell/frag12
	name = "FRAG-12 slug"
	desc = "A high explosive breaching round for a 12 gauge shotgun."
	icon_state = "explosive"
	projectile_type = /obj/projectile/bullet/shotgun/frag12
	materials_base = list(MAT_STEEL = 500, MAT_PHORON = 200)
	worth_intrinsic = 75

/obj/item/ammo_casing/a12g/techshell/laserslug
	name = "scatter laser shell"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a scatter laser weapon in a ballistic package."
	icon_state = "laser"
	projectile_type = /obj/projectile/scatter/laser
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)
	worth_intrinsic = 50

/obj/item/ammo_casing/a12g/silver
	name = "silver slug shell"
	desc = "A 12 gauge shell holding a solid silver slug. What are you hunting, werewolves?"
	icon_state = "silver"
	projectile_type = /obj/projectile/bullet/shotgun/silver
	materials_base = list(MAT_STEEL = 200, MAT_SILVER = 200)
	worth_intrinsic = 75

/obj/item/ammo_casing/a12g/silvershot
	name = "silvershot shell"
	desc = "A 12 gauge shell filled with silver buckshot pellets. What are you hunting, werewolves?"
	icon_state = "silvershot"
	projectile_type = /obj/projectile/bullet/pellet/shotgun/silvershot
	materials_base = list(MAT_STEEL = 200, MAT_SILVER = 160)
	worth_intrinsic = 75

/obj/item/ammo_casing/a12g/stake
	name = "holy flechette shell"
	desc = "No ordinary shotgun shell, this appears to be an oversized iron nail of obscure provenance held in place by a wax sabot. Blessed and sanctified to banish otherworldly entities."
	icon_state = "stake"
	projectile_type = /obj/projectile/bullet/shotgun/stake
	materials_base = list(MAT_STEEL = 500)
	worth_intrinsic = 80

//* Magazines - Drums

/obj/item/ammo_magazine/a12g/drum
	name = "magazine (12 gauge)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_drum.dmi'
	icon_state = "autoshotgun"
	base_icon_state = "autoshotgun"
	materials_base = list(MAT_STEEL = 13000)
	ammo_caliber = /datum/ammo_caliber/a12g
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_max = 24
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 2

/obj/item/ammo_magazine/a12g/drum/beanbag
	name = "magazine (12 gauge beanbag)"
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/a12g/drum/pellet
	name = "magazine (12 gauge pellet)"
	ammo_preload = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/a12g/drum/flare
	name = "magazine (12 gauge flash)"
	ammo_preload = /obj/item/ammo_casing/a12g/flare

/obj/item/ammo_magazine/a12g/drum/empty
	ammo_current = 0

/obj/item/ammo_magazine/a12g/drum/holy
	name = "blessed drum magazine (12 gauge)"
	icon_state = "holyshotgun"
	base_icon_state = "holyshotgun"
	desc = "Thrice-blessed, this drum magazine is loaded with silver shot designed to combat supernatural threats."
	materials_base = list(MAT_STEEL = 100, MAT_SILVER = 1100)
	ammo_preload = /obj/item/ammo_casing/a12g/silvershot
	ammo_max = 12
	rendering_system = GUN_RENDERING_DISABLED

/obj/item/ammo_magazine/a12g/drum/holy/stake
	name = "blessed drum magazine (stakes)"
	desc = "Thrice-blessed, this drum magazine is loaded with iron nails soaked in sacred oils."
	ammo_preload = /obj/item/ammo_casing/a12g/stake

//* Magazines - Clips

/obj/item/ammo_magazine/a12g/clip
	name = "ammo clip (12g slug)"
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "a12-slug-2"
	base_icon_state = "a12-slug"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with slugs."
	ammo_caliber = /datum/ammo_caliber/a12g
	ammo_preload = /obj/item/ammo_casing/a12g
	materials_base = list(MAT_STEEL = 350) // slugs shells x2 + 350 metal for the clip itself.
	ammo_max = 2
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 2
	ammo_restrict_no_subtypes = TRUE
	ammo_restrict = /obj/item/ammo_casing/a12g
	magazine_type = MAGAZINE_TYPE_CLIP

/obj/item/ammo_magazine/a12g/clip/pellet
	name = "ammo clip (12g buckshot)"
	icon_state = "a12-buck-2"
	base_icon_state = "a12-buck"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with buckshot."
	ammo_preload = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/a12g/clip/beanbag
	name = "ammo clip (12g beanbag)"
	icon_state = "a12-bean-2"
	base_icon_state = "a12-bean"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with beanbags."
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/a12g/clip/silver
	name = "ammo clip (12g silver)"
	icon_state = "a12-silver-2"
	base_icon_state = "a12-silver"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with silver slugs."
	ammo_preload = /obj/item/ammo_casing/a12g/silver

/obj/item/ammo_magazine/a12g/clip/silvershot
	name = "ammo clip (12g silvershot)"
	icon_state = "a12-silver-2"
	base_icon_state = "a12-silver"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with silver buckshot."
	ammo_preload = /obj/item/ammo_casing/a12g/silvershot

/obj/item/ammo_magazine/a12g/clip/stake
	name = "ammo clip (12g stakes)"
	icon_state = "a12-stake-2"
	base_icon_state = "a12-stake"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with blessed iron nails."
	ammo_preload = /obj/item/ammo_casing/a12g/stake

//* Magazines - Pouches

/obj/item/ammo_magazine/a12g/pouch
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon = 'icons/modules/projectiles/magazines/old_pouch.dmi'
	icon_state = "shotgun-clip-4"
	base_icon_state = "shotgun-clip"
	ammo_caliber = /datum/ammo_caliber/a12g
	materials_base = list(MAT_STEEL = 1440)
	magazine_type = NONE
	ammo_preload = /obj/item/ammo_casing/a12g
	ammo_current = 0
	ammo_max = 4
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 4

	var/marking_color

/obj/item/ammo_magazine/a12g/pouch/update_icon()
	. = ..()
	if(marking_color)
		var/image/I = image(icon, "[base_icon_state]-marking")
		I.color = marking_color
		add_overlay(I)

/obj/item/ammo_magazine/a12g/pouch/full
	ammo_current = 4

/obj/item/ammo_magazine/a12g/pouch/full/slug
	name = "shotgun slug holder (slug)"
	marking_color = PIPE_COLOR_BLACK
	ammo_preload = /obj/item/ammo_casing/a12g

/obj/item/ammo_magazine/a12g/pouch/full/flare
	name = "shotgun slug holder (flare)"
	marking_color = COLOR_RED_GRAY
	ammo_preload = /obj/item/ammo_casing/a12g/flare

/obj/item/ammo_magazine/a12g/pouch/full/buckshot
	name = "shotgun slug holder (buckshot)"
	marking_color = COLOR_RED
	ammo_preload = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/a12g/pouch/full/beanbag
	name = "shotgun slug holder (beanbag)"
	marking_color = COLOR_GREEN
	ammo_preload = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/a12g/pouch/full/stun
	name = "shotgun slug holder (stun)"
	marking_color = PIPE_COLOR_YELLOW
	ammo_preload = /obj/item/ammo_casing/a12g/stunshell

/obj/item/ammo_magazine/a12g/pouch/full/silvershot
	name = "shotgun slug holder (silvershot)"
	marking_color = COLOR_WHITE
	ammo_preload = /obj/item/ammo_casing/a12g/silvershot
