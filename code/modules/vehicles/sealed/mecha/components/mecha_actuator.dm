/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/mecha_actuator
	name = "mecha actuator"
	desc = "An actuator for an exosuit's movement subsystem."
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "motor"
	w_class = WEIGHT_CLASS_HUGE
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 1200)
	start_damaged = FALSE
	emp_resistance = 1
	integrity_danger_mod = 0.6	// Multiplier for comparison to integrity_max before problems start.
	integrity_max = 50
	internal_damage_flag = MECHA_INT_CONTROL_LOST
	vehicle_encumbrance = 2.5

	/// when not going forwards
	var/base_strafing_speed_multiplier = 0.5
	/// any dir
	var/base_speed_multiplier = 1
	#warn hook all

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/mecha_actuator/strafing
	name = /obj/item/vehicle_component/mecha_actuator::name + " (strafing optimized)"
	desc = "A set of actuators specialized for faster strafing."
	base_speed_multiplier = 0.85
	base_strafing_speed_multiplier = 0.9

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/mecha_actuator/heavy
	name = /obj/item/vehicle_component/mecha_actuator::name + " (high support)"
	desc = "A set of heavy-duty actuators more capable of handling higher weight loads on the exoframe, \
	at the cost of movement speed."
	base_speed_multiplier = 0.75
	#warn impl
