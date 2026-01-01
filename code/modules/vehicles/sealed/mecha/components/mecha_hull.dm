/datum/armor/vehicle_plating/hull
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

/datum/armor/vehicle_plating_redirection/mecha_hull
	melee = 0.3
	melee_tier = 3.5
	melee_deflect = 7.5
	bullet = 0.3
	bullet_tier = 3.5
	bullet_deflect = 7.5
	laser = 0.3
	laser_tier = 3.5
	laser_deflect = 7.5
	energy = 0.35
	bomb = 0.65
	rad = 0.5
	fire = 0.5
	acid = 0.75

/**
 * * Acquirable from R&D / lathes
 * * Tends to be softer than armor, but with more soak.
 */
/obj/item/vehicle_component/plating/mecha_hull
	name = "mecha hull"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "hull"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 3500, MAT_GLASS = 200)

	integrity = 300
	integrity_max = 300
	integrity_failure = 200
	vehicle_encumbrance = 7.5

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_hull/durable
	name = /obj/item/vehicle_component/plating/mecha_hull::name + " (durable)"
	vehicle_encumbrance = 12.5

/obj/item/vehicle_component/plating/mecha_hull/durable/citadel
	name = /obj/item/vehicle_component/plating/mecha_hull::name + " (citadel)"
	vehicle_encumbrance = 25

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_hull/lightweight
	name = /obj/item/vehicle_component/plating/mecha_hull::name + " (lightweight)"
	vehicle_encumbrance = 4

#warn stats
