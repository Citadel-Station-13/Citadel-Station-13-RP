/datum/armor/vehicle_plating/hull

/datum/armor/vehicle_plating_redirection/mecha_hull

/**
 * * Acquirable from R&D / lathes
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
	internal_damage_flag = MECHA_INT_FIRE

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
