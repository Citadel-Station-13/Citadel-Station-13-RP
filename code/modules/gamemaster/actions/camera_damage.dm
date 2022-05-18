/datum/gm_action/camera_damage
	name = "random camera damage"
	reusable = TRUE
	departments = list(DEPARTMENT_SYNTHETIC, DEPARTMENT_ENGINEERING)

/datum/gm_action/camera_damage/start()
	var/obj/machinery/camera/C = acquire_random_camera()
	if(!C)
		return
	..()

	var/severity_range = 0
	severity = pickweight(EVENT_LEVEL_MUNDANE = 10,
		EVENT_LEVEL_MODERATE = 5,
		EVENT_LEVEL_MAJOR = 1
		)

	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			severity_range = 0
		if(EVENT_LEVEL_MODERATE)
			severity_range = 7
		if(EVENT_LEVEL_MAJOR)
			severity_range = 15

	for(var/obj/machinery/camera/cam in range(severity_range,C))
		if(is_valid_camera(cam))
			if(prob(2*severity))
				cam.destroy()
			else
				cam.wires.cut(WIRE_MAIN_POWER1)
				if(prob(5*severity))
					cam.wires.cut(WIRE_CAM_ALARM)

/datum/gm_action/camera_damage/proc/acquire_random_camera(var/remaining_attempts = 5)
	if(!GLOB.cameranet.cameras.len)
		return
	if(!remaining_attempts)
		return

	var/obj/machinery/camera/C = pick(GLOB.cameranet.cameras)
	if(is_valid_camera(C))
		return C
	return acquire_random_camera(remaining_attempts--)

/datum/gm_action/camera_damage/proc/is_valid_camera(var/obj/machinery/camera/C)
	// Only return a functional camera, not installed in a silicon/hardsuit/circuit/etc, and that exists somewhere players have access
	var/turf/T = get_turf(C)
	return T && C.can_use() && istype(C.loc, /turf) && (T.z in GLOB.using_map.player_levels)

/datum/gm_action/camera_damage/get_weight()
	return 40 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20) + (metric.count_people_in_department(DEPARTMENT_SYNTHETIC) * 40)
