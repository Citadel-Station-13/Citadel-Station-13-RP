//* Rifle

/datum/firemode/energy/pulse_rifle
	abstract_type = /datum/firemode/energy/pulse_rifle

/datum/firemode/energy/pulse_rifle/pulse
	projectile_type = /obj/projectile/beam/pulse
	charge_cost = 160
	render_state = "pulse"

/datum/firemode/energy/pulse_rifle/laser
	projectile_type = /obj/projectile/beam
	charge_cost = 80
	render_state = "laser"

/datum/firemode/energy/pulse_rifle/stun
	projectile_type = /obj/projectile/beam/stun
	charge_cost = 80
	render_state = "stun"

#warn pulse/rifle
/obj/item/gun/projectile/energy/pulse_rifle
	name = "\improper pulse rifle"
	desc = "The absolute pinnacle of Nanotrasen's beam weaponry, the NT-PR2 pulse rifle uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon = 'icons/modules/projectiles/guns/energy/pulse.dmi'
	icon_state = "rifle"
	worn_state = "rifle"
	base_icon_state = "rifle"
	// override base worn state so that all subtypes of /pulse use it, as we
	// don't have carbine/pistol sprites yet
	base_mob_state = "rifle"
	use_mob_states = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	render_ammo_count = 4
	render_ammo_single_overlay = TRUE
	render_ammo_per_firemode = TRUE
	accuracy = 90
	one_handed_penalty = 10
	heavy = TRUE

	regex_this_firemodes = list(
		/datum/firemode/energy/pulse_rifle/pulse,
		/datum/firemode/energy/pulse_rifle/laser,
		/datum/firemode/energy/pulse_rifle/stun,
	)

// todo: legacy
/obj/item/gun/projectile/energy/pulse_rifle/mounted
	self_charging = TRUE
	charge_external_draw = TRUE

/obj/item/gun/projectile/energy/pulse_rifle/destroyer
	name = "\improper pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, the NT-PD-1 pulse destroyer it is rarely seen in use except by specialists."

	regex_this_firemodes = list(
		/datum/firemode/energy/pulse_rifle/pulse,
	)

//* Carbine

/datum/firemode/energy/pulse_carbine
	abstract_type = /datum/firemode/energy/pulse_carbine

/datum/firemode/energy/pulse_carbine/pulse
	projectile_type = /obj/projectile/beam/pulse
	charge_cost = 160
	render_state = "pulse"

/datum/firemode/energy/pulse_carbine/laser
	projectile_type = /obj/projectile/beam
	charge_cost = 80
	render_state = "laser"

/datum/firemode/energy/pulse_carbine/stun
	projectile_type = /obj/projectile/beam/stun
	charge_cost = 80
	render_state = "stun"

#warn pulse/carbine
/obj/item/gun/projectile/energy/pulse_rifle/carbine
	name = "pulse carbine"
	desc = "A compact carbine of Nanotrasen design."
	icon_state = "carbine"
	base_icon_state = "carbine"
	slot_flags = SLOT_BELT | SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	#warn impl

	regex_this_firemodes = list(
		/datum/firemode/energy/pulse_carbine/pulse,
		/datum/firemode/energy/pulse_carbine/laser,
		/datum/firemode/energy/pulse_carbine/stun,
	)

/datum/firemode/energy/pulse_pistol
	abstract_type = /datum/firemode/energy/pulse_pistol

/datum/firemode/energy/pulse_pistol/pulse
	projectile_type = /obj/projectile/beam/pulse
	charge_cost = 480
	render_state = "pulse"

/datum/firemode/energy/pulse_pistol/laser
	projectile_type = /obj/projectile/beam
	charge_cost = 240
	render_state = "laser"

/datum/firemode/energy/pulse_pistol/stun
	projectile_type = /obj/projectile/beam/stun
	charge_cost = 240
	render_state = "stun"

//* Pistol

#warn pulse/pistol
/obj/item/gun/projectile/energy/pulse_pistol
	name = "\improper pulse pistol"
	desc = "Compact NT-PS-4 pulse pistols are only issued to trained Central Command Officers for personal defense. They are sometimes selected by ERT or DDO operatives as a fallback sidearm."
	icon_state = "pistol"
	base_icon_state = "pistol"
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	w_class = WEIGHT_CLASS_SMALL
	accuracy = 90
	one_handed_penalty = 10

	regex_this_firemodes = list(
		/datum/firemode/energy/pulse_pistol/pulse,
		/datum/firemode/energy/pulse_pistol/laser,
		/datum/firemode/energy/pulse_pistol/stun,
	)
