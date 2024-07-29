/datum/firemode/energy/pulse_rifle

/datum/firemode/energy/pulse_rifle/laser
	render_key = "kill"
	settings = list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 80)

/datum/firemode/energy/pulse_rifle/pulse
	render_key = "destroy"
	settings = list(mode_name="destroy", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 180)

/datum/firemode/energy/pulse_carbine

/datum/firemode/energy/pulse_carbine/laser
	render_key = "kill"
	settings = list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 120)

/datum/firemode/energy/pulse_carbine/pulse
	render_key = "destroy"
	settings = list(mode_name="destroy", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 240)

/obj/item/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "The absolute pinnacle of Nanotrasen's beam weaponry, the NT-PR2 pulse rifle uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/pulse.dmi'
	icon_state = "rifle"
	base_icon_state = "rifle"
	render_mob_base = "pulse"
	slot_flags = SLOT_BACK
	one_handed_penalty = 10
	heavy = TRUE

	firemodes = list(
		/datum/firemode/energy/pulse_rifle/laser,
		/datum/firemode/energy/pulse_rifle/pulse,
	)

/obj/item/gun/energy/pulse_carbine
	name = "pulse carbine"
	desc = "Compact NT-PS-4 pulse pistols are only issued to trained Central Command Officers for personal defense. They are sometimes selected by ERT or DDO operatives as a fallback sidearm."
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/pulse.dmi'
	icon_state = "carbine"
	base_icon_state = "carbine"
	render_mob_base = "pulse"
	slot_flags = SLOT_BELT|SLOT_HOLSTER

	firemodes = list(
		/datum/firemode/energy/pulse_carbine/laser,
		/datum/firemode/energy/pulse_carbine/pulse,
	)
