//NT Pulse Weapon Pinnacle Technology
/obj/item/gun/energy/pulse_rifle
	name = "\improper pulse rifle"
	desc = "The absolute pinnacle of Nanotrasen's beam weaponry, the NT-PR2 pulse rifle uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	slot_flags = SLOT_BELT|SLOT_BACK
	damage_force = 10
	projectile_type = /obj/projectile/beam
	charge_cost = 120
	sel_mode = 2
	accuracy = 90
	one_handed_penalty = 10
	heavy = TRUE

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_delay=null, charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 120),
		list(mode_name="DESTROY", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 240),
		)

/obj/item/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/gun/energy/pulse_rifle/destroyer
	name = "\improper pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, the NT-PD-1 pulse destroyer it is rarely seen in use except by specialists."
	projectile_type=/obj/projectile/beam/pulse
	charge_cost = 120

/obj/item/gun/energy/pulse_rifle/destroyer/attack_self(mob/user)
	. = ..()
	if(.)
		return
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")

/obj/item/gun/energy/pulse_pistol
	name = "\improper pulse pistol"
	desc = "Compact NT-PS-4 pulse pistols are only issued to trained Central Command Officers for personal defense. They are sometimes selected by ERT or DDO operatives as a fallback sidearm."
	icon_state = "pulse_pistol"
	item_state = null
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	damage_force = 10
	projectile_type = /obj/projectile/beam
	charge_cost = 240
	sel_mode = 2
	accuracy = 90
	one_handed_penalty = 10

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_delay=null, charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 240),
		list(mode_name="DESTROY", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 480),
		)

//I've always liked the M1911, but it's kinda silly, the more I think about it. So I'm just gonna comment it out and put in the Pulse Pistol to replace it.
/*
//WHY?
/obj/item/gun/energy/pulse_rifle/M1911
	name = "\improper M1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "m1911-p"
	charge_cost = 240
	one_handed_penalty = 0

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_delay=null, charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_delay=null, charge_cost = 240),
		list(mode_name="DESTROY", projectile_type=/obj/projectile/beam/pulse, fire_delay=null, charge_cost = 480),
		)
*/
