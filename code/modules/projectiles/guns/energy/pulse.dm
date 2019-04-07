/obj/item/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	slot_flags = SLOT_BELT|SLOT_BACK
	force = 10

	firemodes = list(
		/datum/firemode/energy/stun/pulse,
		/datum/firemode/energy/laser/pulse,
		/datum/firemode/energy/pulse
		)

/obj/item/gun/energy/pulse_rifle/mounted
	self_recharge = TRUE
	use_external_power = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	firemodes = /datum/firemode/energy/pulse

//WHY?
/obj/item/gun/energy/pulse_rifle/M1911
	name = "\improper M1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "m1911-p"

	firemodes = list(
		/datum/firemode/energy/stun,
		/datum/firemode/energy/laser,
		/datum/firemode/energy/pulse/pistol
		)
