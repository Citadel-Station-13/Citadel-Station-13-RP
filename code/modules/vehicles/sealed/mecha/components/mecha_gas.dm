/obj/item/vehicle_component/mecha_gas
	name = "mecha life-support"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "lifesupport"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 1500)
	emp_resistance = 1
	integrity_danger_mod = 0.4
	integrity_max = 40
	internal_damage_flag = MECHA_INT_TANK_BREACH

/obj/item/vehicle_component/mecha_gas/reinforced
	name = "reinforced mecha life-support"
	emp_resistance = 2
	integrity_max = 80
	relative_size = 40
