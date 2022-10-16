/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and "+TSC_HEPH+", the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_delay = 10 // Handguns should be inferior to two-handed weapons.

	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="energystun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill", charge_cost = 480),
		)

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1


/obj/item/gun/energy/gun/burst
	name = "burst laser"
	desc = "The FM-2t is a versatile energy based weapon, capable of switching between stun or kill with a three round burst option for both settings."
	icon_state = "fm-2tstun100"	//May resprite this to be more rifley
	item_state = null	//so the human update icon uses the icon_state instead.
	charge_cost = 100
	force = 8
	w_class = ITEMSIZE_LARGE	//Probably gonna make it a rifle sooner or later
	fire_delay = 6
	heavy = TRUE
	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "fm-2tstun"

//	requires_two_hands = 1
	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="fm-2tstun", charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(65,65,65), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="fm-2tstun"),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill", charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(65,65,65), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill"),
		)

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgunstun"
	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	w_class = ITEMSIZE_LARGE	//Looks bigger than a pistol, too.
	heavy = TRUE
	fire_delay = 6	//This one's not a handgun, it should have the same fire delay as everything else
	cell_type = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	modifystate = null

//	requires_two_hands = 1
	one_handed_penalty = 30 // It's rather bulky at the fore, so holding it in one hand is harder than with two.

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="nucgunstun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="nucgunkill", charge_cost = 480),
		)

/obj/item/gun/energy/gun/multiphase
	name = "\improper X-01 MultiPhase Energy Gun"
	desc = "This is an expensive, modern recreation of an antique laser gun. This gun has several unique firemodes, but lacks the ability to recharge over time."
	icon = 'icons/obj/multiphase.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/inhands/guns_left.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/inhands/guns_right.dmi',
		)
	icon_state = "multiphasedis100"
	projectile_type = /obj/item/projectile/beam/stun/disabler
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	force = 10 //for the HOS to lay down a good beating in desperate situations. Holdover from TG.
	w_class = ITEMSIZE_NORMAL
	fire_delay = 6	//standard rate
	battery_lock = 0
	modifystate = null

	firemodes = list(
		list(mode_name="disable", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/disabler, modifystate="multiphasedis", charge_cost = 100),
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/energy/electrode/goldenbolt, modifystate="multiphasestun", charge_cost = 480),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam, modifystate="multiphasekill", charge_cost = 240),
		)
