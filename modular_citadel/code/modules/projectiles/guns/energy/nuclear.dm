/*
	egun stuff goes here
*/

/obj/item/gun/energy/gun/multiphase
	name = "\improper X-01 MultiPhase Energy Gun"
	desc = "This is an expensive, modern recreation of an antique laser gun. This gun has several unique firemodes, but lacks the ability to recharge over time."
	icon = 'modular_citadel/icons/obj/multiphase.dmi'
	item_icons = list(
		slot_l_hand_str = 'modular_citadel/icons/mob/inhands/guns_left.dmi',
		slot_r_hand_str = 'modular_citadel/icons/mob/inhands/guns_right.dmi',
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