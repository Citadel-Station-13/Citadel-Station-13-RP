
/obj/item/vehicle_component/electrical
	name = "mecha electrical harness"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "board"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 1000)

	component_type = MECH_ELECTRIC

	emp_resistance = 1

	integrity_danger_mod = 0.4
	integrity_max = 40

	step_delay = 0

	relative_size = 20

	internal_damage_flag = MECHA_INT_SHORT_CIRCUIT

	var/charge_cost_mod = 1

/obj/item/vehicle_component/electrical/high_current
	name = "efficient mecha electrical harness"

	emp_resistance = 0
	integrity_max = 30

	relative_size = 10
	charge_cost_mod = 0.6
