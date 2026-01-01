/datum/armor/vehicle/mecha/combat
	melee = 0.3
	melee_tier = 4
	melee_deflect = 5
	bullet = 0.3
	bullet_tier = 4
	bullet_deflect = 2.5
	laser = 0.3
	laser_tier = 4
	laser_deflect = 2.5
	energy = 0.2
	bomb = 0.35

#warn can we emit a message on full block?

/obj/vehicle/sealed/mecha/combat
	melee_standard_force = 30

	var/melee_cooldown = 10
	var/melee_can_hit = 1
	internal_damage_threshold = 50

	armor_type = /datum/armor/vehicle/mecha/combat
	integrity = /obj/vehicle/sealed/mecha::integrity
	integrity_max = /obj/vehicle/sealed/mecha::integrity_max

	comp_hull_relative_thickness = /obj/vehicle/sealed/mecha::comp_hull_relative_thickness
	comp_hull = /obj/item/vehicle_component/plating/mecha_hull/durable
	comp_armor_relative_thickness = /obj/vehicle/sealed/mecha::comp_armor_relative_thickness
	comp_armor = /obj/item/vehicle_component/plating/mecha_armor/reinforced

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
	)

	cargo_capacity = 1

/obj/vehicle/sealed/mecha/combat/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(adding.client)
		adding.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")

/obj/vehicle/sealed/mecha/combat/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(removing.client)
		removing.client.mouse_pointer_icon = initial(removing.client.mouse_pointer_icon)

