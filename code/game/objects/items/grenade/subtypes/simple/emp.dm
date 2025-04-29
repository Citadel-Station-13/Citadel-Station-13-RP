/obj/item/grenade/simple/emp
	name = "emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)
	worth_intrinsic = 70

	var/emp_heavy = 2
	var/emp_med = 4
	var/emp_light = 7
	var/emp_long = 10

/obj/item/grenade/simple/emp/on_detonate(turf/location, atom/grenade_location)
	..()
	empulse(location, emp_heavy, emp_med, emp_light, emp_long)

/obj/item/grenade/simple/emp/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the EMP grenade"
	icon_state = "lyemp"
	worth_intrinsic = 35
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)
	emp_heavy = 1
	emp_med = 2
	emp_light = 3
	emp_long = 4
