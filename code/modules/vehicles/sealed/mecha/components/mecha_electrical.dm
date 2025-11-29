/obj/item/vehicle_component/mecha_electrical
	name = "mecha electrical harness"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "board"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 1000)
	emp_resistance = 1
	integrity_danger_mod = 0.4
	integrity_max = 40
	internal_damage_flag = MECHA_INT_SHORT_CIRCUIT

	/**
	 * Multiplier to the mech's power draw.
	 *
	 * * Values below 1 are generally ignored by mechs.
	 */
	var/base_draw_multiplier = 1

/**
 * @return 1 = 100%, 2 = 2x power, 1.5 = 1.5x power, etc
 */
/obj/item/vehicle_component/mecha_electrical/proc/get_electrical_draw_penalty()
	return base_draw_multiplier
