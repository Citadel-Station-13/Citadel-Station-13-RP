/datum/firemode/energy/pulse_rifle

/datum/firemode/energy/pulse_rifle/laser
	name = "laser"
	render_key = "kill"
	settings = list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 80)

/datum/firemode/energy/pulse_rifle/pulse
	name = "pulse"
	render_key = "destroy"
	settings = list(mode_name="destroy", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 180)

/datum/firemode/energy/pulse_carbine

/datum/firemode/energy/pulse_carbine/laser
	name = "laser"
	render_key = "kill"
	settings = list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 120)

/datum/firemode/energy/pulse_carbine/pulse
	name = "pulse"
	render_key = "destroy"
	settings = list(mode_name="destroy", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 240)

/obj/item/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A powerful energy rifle with multiple intensity selectors."
	// intentionally the same as all pulse weapons to save memory
	description_fluff = {"
		A breakthrough weapon from Nanotrasen's Research Division, pulse weapons utilize rare crystals in its generation array,
		allowing for a more laminar and cohesive beam than prior thought possible. Closely guarded designs to this day,
		pulse weapons are some of the only energy-based armaments able to consistently outperform any kinetic alternative.
	"}
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

	item_renderer = /datum/gun_item_renderer/segments{
		count = 4;
		offset_x = 2;
		independent_firemode = TRUE;
		use_firemode = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		use_firemode = TRUE;
		count = 4;
		empty_state = TRUE;
	}

/obj/item/gun/energy/pulse_carbine
	name = "pulse carbine"
	desc = "A powerful energy carbine with multiple intensity selectors."
	// intentionally the same as all pulse weapons to save memory
	description_fluff = {"
		A breakthrough weapon from Nanotrasen's Research Division, pulse weapons utilize rare crystals in its generation array,
		allowing for a more laminar and cohesive beam than prior thought possible. Closely guarded designs to this day,
		pulse weapons are some of the only energy-based armaments able to consistently outperform any kinetic alternative.
	"}
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/pulse.dmi'
	icon_state = "carbine"
	base_icon_state = "carbine"
	render_mob_base = "pulse"
	slot_flags = SLOT_BELT

	firemodes = list(
		/datum/firemode/energy/pulse_carbine/laser,
		/datum/firemode/energy/pulse_carbine/pulse,
	)

	item_renderer = /datum/gun_item_renderer/segments{
		count = 4;
		offset_x = 2;
		independent_firemode = TRUE;
		use_firemode = TRUE;
		use_empty = TRUE;
	}
	mob_renderer = /datum/gun_mob_renderer/states{
		use_firemode = TRUE;
		count = 4;
		empty_state = TRUE;
	}
