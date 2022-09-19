/datum/component/riding_filter/vehicle
	expected_typepath = /obj/vehicle
	handler_typepath = /datum/component/riding_handler/vehicle

/datum/component/riding_handler/vehicle
	expected_typepath = /obj/vehicle

/datum/component/riding_handler/vehicle/driver_check(mob/M)
	var/obj/vehicle/ridden/R = parent
	return R.drive_check(M)
