/obj/item/gun/projectile/ballistic/gyropistol // Does this even appear anywhere outside of admin abuse?
	name = "gyrojet pistol"
	desc = "Speak softly, and carry a big gun. Fires rare .75 caliber self-propelled exploding bolts--because fuck you and everything around you."
	icon_state = "gyropistol"
	max_shells = 8
	caliber = ".75"
	fire_sound = 'sound/weapons/railgun.ogg'
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = "/obj/item/ammo_casing/a75"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m75
	allowed_magazines = list(/obj/item/ammo_magazine/m75)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/ballistic/gyropistol/bolter
	name = "\improper Scorpion bolt pistol"
	desc = "A boxy sidearm seemingly designed for a larger hand. Uses .75 gyrojet rounds."
	description_fluff = "The HI-GP mk 3 'Scorpion' was an attempt to downsize the larger Ballistae model even further. Many of the weapon's issues persisted, compounded by the smaller size of the mechanical components within. Most prototypes sheared or broke, and were prone to malfunction due to the instense strain of extensive firing."
	icon_state = "bolt_pistol"
	item_state = "bolt_pistol"
	max_shells = 10
	fire_sound = 'sound/weapons/gunshot/gunshot_bolter.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_ILLEGAL = 3)
	magazine_type = /obj/item/ammo_magazine/m75/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/m75/pistol)
	auto_eject = 0

/obj/item/gun/projectile/ballistic/gyropistol/bolter/black
	desc = "A boxy sidearm seemingly designed for a larger hand. This one is painted black."
	icon_state = "bolt_pistolblack"
	item_state = "bolt_pistolblack"

/obj/item/gun/projectile/ballistic/gyropistol/bolter/black/update_icon_state()
	. = ..()
	icon_state = "bolt_pistolblack-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"

/obj/item/gun/projectile/ballistic/automatic/bolter
	name = "\improper Ballistae bolt rifle"
	desc = "A boxy rifle clearly designed for larger hands. Uses .75 gyrojet rounds."
	description_fluff = "The HI-GP mk 8 'Ballistae' is a bulky weapon designed to fire an obscenely robust .75 caliber gyrojet round with an explosive payload. The original design was sourced from Old Earth speculative documentation, and developed to test its efficacy. Although the weapon itself is undeniably powerful, its logistical demands, the recoil of the three-stage ammunition system, and its hefty size make it untenable on the modern battlefield."
	icon_state = "bolter"
	item_state = "bolter"
	caliber = ".75"
	origin_tech = list(TECH_COMBAT = 5, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_bolter.ogg'
	max_shells = 30
	magazine_type = /obj/item/ammo_magazine/m75/sickle
	allowed_magazines = list(/obj/item/ammo_magazine/m75/sickle)
	heavy = TRUE
	one_handed_penalty = 80

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="automatic", burst=1, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/automatic/bolter/update_icon_state()
	. = ..()
	icon_state = "bolter-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"

/obj/item/gun/projectile/ballistic/automatic/bolter/storm
	name = "\improper Onager heavy bolt rifle"
	desc = "A hulking automatic weapon more fit for a crew serve position than personal use. Uses .75 gyrojet rounds."
	description_fluff = "The HI-GP mk 2 'Onager' may perhaps be considered the one successful prototype to come out of Hephaestus' reclamatory efforts. Thanks to its large size many of the issues with ease of maintenance were successfully mitigated. However, the expense of replacing parts and the cost of the weapon's exotic ammunition still resulted in the inititative being considered a failure."
	icon_state = "stormbolter"
	item_state = "stormbolter"
	max_shells = 50
	magazine_type = /obj/item/ammo_magazine/m75/box
	allowed_magazines = list(/obj/item/ammo_magazine/m75/box)
	one_handed_penalty = 100

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="automatic", burst=2, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/automatic/bolter/storm/update_icon_state()
	. = ..()
	icon_state = "stormbolter-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 10) : "empty"]"
