/obj/item/gun/energy/e_gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and "+TSC_HEPH+", the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	icon_state = "energystun100"
	icon = 'icons/obj/items/guns/energy/egun.dmi'
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_delay = 10 // Handguns should be inferior to two-handed weapons.

	projectile_type = /obj/item/projectile/beam/stun/med
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		/datum/firemode/energy/stun/egun,
		/datum/firemode/energy/laser/egun
		)

/obj/item/gun/energy/e_gun/mounted
	name = "mounted energy gun"
	self_recharge = TRUE
	use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/gun/energy/e_gun/burst
	name = "burst laser"
	desc = "The FM-2t is a versatile energy based weapon, capable of switching between stun or kill with a three round burst option for both settings."
	icon_state = "fm-2tstun100"	//May resprite this to be more rifley
	item_state = null	//so the human update icon uses the icon_state instead.
	charge_cost = 100
	force = 8
	w_class = ITEMSIZE_LARGE	//Probably gonna make it a rifle sooner or later
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)

	firemodes = list(
		/datum/firemode/energy/stun/burstlaser,
		/datum/firemode/energy/laser/burstlaser
		)

/obj/item/gun/energy/e_gun/martin
	name = "holdout energy gun"
	desc = "The FS PDW E \"Martin\" is small holdout energy gun. Don't miss!"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "PDW"
	item_state = "gun"
	w_class = ITEMSIZE_SMALL
	removable_battery = FALSE
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	firemodes = list(
		/datum/firemode/energy/stun/martin,
		/datum/firemode/energy/laser/martin
		)

/obj/item/gun/energy/e_gun/dominator
	name = "bulky energy gun"
	desc = "A MWPSB Dominator from the Federation. Like the basic Energy Gun, this gun has two settings. It is used by the United Federation Public Safety Bureau's Criminal Investigation Division. The weapon can only be fired by the owner and is alert-level locked."

	icon = 'icons/obj/items/guns/energy/egun.dmi'
	icon_state = "dominator"

	firemodes = list(
		/datum/firemode/energy/stun/egun,
		/datum/firemode/energy/laser/dominator
	)

	var/emagged = FALSE		//replace with obj flags later.

/obj/item/gun/energy/e_gun/dominator/special_check(mob/user)			//replace with harmful flag later!
	if(!emagged && mode_name == "kill" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting under security level green!</span>")
		return FALSE
	return ..()

/obj/item/gun/energy/gun/fluff/dominator/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")
	return TRUE
