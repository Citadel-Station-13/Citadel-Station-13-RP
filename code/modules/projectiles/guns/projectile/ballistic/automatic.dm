/obj/item/gun/projectile/ballistic/automatic //This should never be spawned in, it is just here because of code necessities.
	name = "daka SMG"
	desc = "A small SMG. You really shouldn't be able to get this gun. Uses 9mm rounds."
	icon_state = "c05r"	//Used because it's not used anywhere else
	load_method = SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a9mm
	projectile_type = /obj/projectile/bullet/pistol
	magazine_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'
//Burst is the number of bullets fired; Fire delay is the time you have to wait to shoot the gun again, Move delay is the same but for moving after shooting. .
//Burst accuracy is the accuracy of each bullet fired in the burst. Dispersion is how much the bullets will 'spread' away from where you aimed.

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(60,30,0), dispersion=list(0.0, 0.6, 1.0)))

/obj/item/gun/projectile/ballistic/automatic/sts35
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular on the frontier worlds. Uses 5.56mm rounds."
	icon_state = "arifle"
	item_state = "arifle"
	wielded_item_state = "arifle-wielded"
	item_state = null
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	caliber = "5.56mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'
	magazine_type = /obj/item/ammo_magazine/m556
	allowed_magazines = list(/obj/item/ammo_magazine/m556)
	projectile_type = /obj/projectile/bullet/rifle/a556
	heavy = TRUE
	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(60,50,45), dispersion=list(0.0, 0.6, 0.6))
//		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30,-30,-45), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/ballistic/automatic/sts35/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m556/small))
		icon_state = "arifle-small" // If using the small magazines, use the small magazine sprite.

/obj/item/gun/projectile/ballistic/automatic/sts35/update_icon(ignore_inhands)
	. = ..()

	update_held_icon()

//Muh Alternator
/obj/item/gun/projectile/ballistic/automatic/wt274
	name = "alternating barrel SMG"
	desc = "Although it experienced an initially successful production run, the WT274 AB-SMG was discontinued in favor of the more reliable WT550. Utilizing a twin-linked barrel assembly, the WT274's ammo consumption was a major factor in its retirement."
	icon_state = "wt274"
	item_state = "gun"
	load_method = MAGAZINE
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	magazine_type = /obj/item/ammo_magazine/m45uzi/wt274
	allowed_magazines = list(/obj/item/ammo_magazine/m45uzi/wt274)
	one_handed_penalty = 10

	firemodes = list(
		list(mode_name="standard fire", burst=2, fire_delay=0),
		list(mode_name="double tap", burst=4, burst_delay=1, fire_delay=4, move_delay=2, burst_accuracy = list(40,30,20,15), dispersion = list(0.6, 0.6, 1.0, 1.0))
		)

/obj/item/gun/projectile/ballistic/automatic/wt274/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-empty"

//NT SpecOps SMG

// Please don't spawn these regularly. I'm mostly just adding these for fun.
/obj/item/gun/ballistic/automatic/bolter
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

/obj/item/gun/ballistic/automatic/bolter/update_icon_state()
	. = ..()
	icon_state = "bolter-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"

/obj/item/gun/ballistic/automatic/bolter/storm
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

/obj/item/gun/ballistic/automatic/bolter/storm/update_icon_state()
	. = ..()
	icon_state = "stormbolter-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 10) : "empty"]"
