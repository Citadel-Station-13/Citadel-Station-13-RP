/datum/armor/vehicle_plating/mecha_armor
	melee = 0.3
	melee_tier = 4
	melee_deflect = 3
	melee_soak = 2
	bullet = 0.4
	bullet_tier = 4
	bullet_deflect = 2
	bullet_soak = 1
	laser = 0.4
	laser_tier = 4
	laser_deflect = 2
	laser_soak = 1
	bomb = 0.55
	energy = 0.35
	bio = 1.0
	rad = 0.35
	fire = 0.85
	acid = 0.65

/datum/armor/vehicle_plating_redirection/mecha_armor
	melee = 0.3
	melee_tier = 4.5
	melee_deflect = 10
	bullet = 0.3
	bullet_tier = 4.5
	bullet_deflect = 10
	laser = 0.3
	laser_tier = 4.5
	laser_deflect = 10
	energy = 0.55
	bomb = 0.25
	rad = 0.5
	fire = 0.5
	acid = 0.75

/**
 * * Acquirable from R&D / lathes
 * * Tends to be harder than hull, but with less soak.
 */
/obj/item/vehicle_component/plating/mecha_armor
	name = "mecha plating"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "armor"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1000)

	integrity = 200
	integrity_max = 200
	integrity_failure = 50
	vehicle_encumbrance = 7.5

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor/lightweight
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (lightweight)"
	vehicle_encumbrance = 4

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor/durable
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (reinforced)"
	vehicle_encumbrance = 12.5

/obj/item/vehicle_component/plating/mecha_armor/durable/citadel
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (citadel)"
	vehicle_encumbrance = 25

/obj/item/vehicle_component/plating/mecha_armor/advanced
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (advanced)"
	vehicle_encumbrance = 7.5

/obj/item/vehicle_component/plating/mecha_armor/advanced/lightweight
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (advanced lightweight)"
	vehicle_encumbrance = 4

/obj/item/vehicle_component/plating/mecha_armor/alien
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (???)"
	vehicle_encumbrance = 5

#warn stats
