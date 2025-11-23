/datum/armor/vehicle/mecha/combat/gygax
	melee = 0.25
	melee_tier = 4
	bullet = 0.35
	bullet_tier = 4
	laser = 0.35
	laser_tier = 4
	energy = 0.35
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/gygax
	name = "Gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	description_fluff = "The Gygax is a relatively modern exosuit designed for agility and speed without sacrificing durability. These traits have made the Gygax fairly popular among well funded private and corporate security forces. The Gygax features a bespoke actuator assembly that grants the exosuit short-term bursts of unparalleled speed. Consequently, the strain this assembly puts on the exosuit causes damage the unit's structural integrity. In spite of the drawbacks, this feature is frequently utilized by those who require the ability to rapidly respond to conflict. 10'(3m) tall and rotund, the Gygax's cockpit is fully enclosed and protected by the design's diamond-weave armor plating."
	icon_state = "gygax_adv"
	initial_icon = "gygax_adv"

	base_movement_speed = 4
	armor_type = /datum/armor/vehicle/combat/gygax

	comp_armor = /obj/item/vehicle_component/plating/armor/marshal
	comp_hull = /obj/item/vehicle_component/plating/hull/lightweight

	dir_in = 1 //Facing North.
	integrity = 250
	integrity_max = 250			//Don't forget to update the /old variant if  you change this number.
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/adv
	internal_damage_threshold = 35

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
	)

	icon_scale_x = 1.35
	icon_scale_y = 1.35

/obj/effect/decal/mecha_wreckage/gygax
	name = "Gygax wreckage"
	icon_state = "gygax-broken"

/obj/effect/decal/mecha_wreckage/gygax/New()
	..()
	var/list/parts = list(
		/obj/item/vehicle_part/gygax_torso,
		/obj/item/vehicle_part/gygax_head,
		/obj/item/vehicle_part/gygax_left_arm,
		/obj/item/vehicle_part/gygax_right_arm,
		/obj/item/vehicle_part/gygax_left_leg,
		/obj/item/vehicle_part/gygax_right_leg,
	)
	for(var/i=0;i<2;i++)
		if(!!length(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part

/obj/effect/decal/mecha_wreckage/gygax/dark
	name = "Dark Gygax wreckage"
	icon_state = "darkgygax-broken"

/obj/effect/decal/mecha_wreckage/gygax/adv
	name = "Gygax wreckage"
	icon_state = "gygax_adv-broken"

/obj/effect/decal/mecha_wreckage/gygax/dark_adv
	name = "Advanced Dark Gygax wreckage"
	icon_state = "darkgygax_adv-broken"

/obj/effect/decal/mecha_wreckage/gygax/medgax
	name = "Medgax wreckage"
	icon_state = "medgax-broken"

/obj/effect/decal/mecha_wreckage/gygax/serenity
	name = "Serenity wreckage"
	icon_state = "medgax-broken"

/datum/armor/vehicle/mecha/combat/gygax/dark
	melee = 0.35
	bullet = 0.45
	laser = 0.45
	energy = 0.45
	bomb = 0.65

/obj/vehicle/sealed/mecha/combat/gygax/dark
	name = "Dark Gygax"
	desc = "A lightweight exosuit used by paramilitary forces. A significantly upgraded Gygax security mech."
	description_fluff = "This variant of the standard Gygax is colloquially referred to as the 'Dark Gygax', on account of the exotic materials used in its construction. The standard Gygax's diamond-weave armor system is augmented with depleted morphium, lending it a darker and marginally more sinister hue. Simultaneously, this upgrade grants the Dark Gygax considerably more resilience without sacrificing the standard model's agility or speed. Due to the gross expenditure required to fabricate a Dark Gygax's armor plating, these platforms are exceedingly rare. Most security forces are content with the protection and utility of the standard Gygax, making this upgrade appear unnecessary. However, the Dark Gygax is often sought out by high-tier asset protection teams and paramilitary outfits."
	integrity = 400
	integrity_max = 400
	icon_state = "darkgygax_adv"
	initial_icon = "darkgygax_adv"

	base_movement_speed = 3.75
	armor_type = /datum/armor/vehicle/combat/gygax/dark
	integrity = 1.25 * /obj/vehicle/sealed/mecha/combat/gygax::integrity
	integrity_max = 1.25 * /obj/vehicle/sealed/mecha/combat/gygax::integrity_max

	max_temperature = 45000
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/dark_adv
	mech_faction = MECH_FACTION_SYNDI

/obj/vehicle/sealed/mecha/combat/gygax/dark/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/grenade/concussion,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/lazy/legacy/teleporter,
	)
	power_cell_type = /obj/item/cell/hyper

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/gygax/old
	desc = "A lightweight, security exosuit. Popular among private and corporate security. This one is particularly worn looking and likely isn't as sturdy."
	integrity = 0.66 * /obj/vehicle/sealed/mecha/combat/gygax/dark::integrity
	integrity_max = 0.66 * /obj/vehicle/sealed/mecha/combat/gygax/dark::integrity_max

/obj/vehicle/sealed/mecha/combat/gygax/old/Initialize(mapload)
	. = ..()
	cell.charge = rand(0, (cell.charge/2))
