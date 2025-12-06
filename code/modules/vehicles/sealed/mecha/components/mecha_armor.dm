/datum/armor/vehicle_plating/mecha_armor

/datum/armor/vehicle_plating_redirection/mecha_armor

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor
	name = "mecha plating"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "armor"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	vehicle_encumbrance = 7.5

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor/lightweight
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (lightweight)"

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor/durable
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (reinforced)"

/obj/item/vehicle_component/plating/mecha_armor/durable/citadel
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (citadel)"

/obj/item/vehicle_component/plating/mecha_armor/advanced
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (advanced)"

/obj/item/vehicle_component/plating/mecha_armor/advanced/lightweight
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (advanced lightweight)"

/obj/item/vehicle_component/plating/mecha_armor/alien
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (???)"

#warn stats
