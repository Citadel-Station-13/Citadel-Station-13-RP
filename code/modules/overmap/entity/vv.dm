/atom/movable/overmap_object/entity/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_DIVIDER
	VV_DROPDOWN_OPTION(VV_HK_OVERMAP_ENTITY_PAUSE, "Pause Physics")
	VV_DROPDOWN_OPTION(VV_HK_OVERMAP_ENTITY_SET_SPEED, "Set Velocity")
	VV_DROPDOWN_OPTION(VV_HK_OVERMAP_ENTITY_SET_ANGLE, "Set Rotation")
	VV_DROPDOWN_OPTION(VV_HK_OVERMAP_ENTITY_RESET_PHYSICS, "Reset Physics")

/atom/movable/overmap_object/entity/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_OVERMAP_ENTITY_RESET_PHYSICS])
		reset_physics()
		log_and_message_admins("reset physics for [src] ([id]).", usr)
	if(href_list[VV_HK_OVERMAP_ENTITY_PAUSE])
		if(physics_paused(ENTITY_PHYSICS_PAUSE_FOR_ADMIN))
			unpause_physics(ENTITY_PHYSICS_PAUSE_FOR_ADMIN)
			log_and_message_admins("unpaused physics for [src] ([id]).", usr)
		else
			pause_physics(ENTITY_PHYSICS_PAUSE_FOR_ADMIN)
			log_and_message_admins("unpaused physics for [src] ([id]).", usr)
	if(href_list[VV_HK_OVERMAP_ENTITY_SET_ANGLE])
		var/angle = input(usr, "Enter angle", "Set Rotation", angle) as num|null
		if(isnull(angle))
			return
		set_angle(angle)
		log_and_message_admins("set [pretty_log_name()] angle to [angle]", usr)
	if(href_list[VV_HK_OVERMAP_ENTITY_SET_SPEED])
		var/x = input(usr, "Enter vel-x", "Velocity Change", velocity_x) as num|null
		if(isnull(x))
			return
		var/y = input(usr, "Enter vel-y", "Velocity Change", velocity_y) as num|null
		if(isnull(y))
			return
		var/angular = input(usr, "Enter vel-angle", "Velocity Change", angular_velocity) as num|null
		if(isnull(angular))
			return
		set_velocity(x, y)
		set_angular_velocity(angular)
		log_and_message_admins("set [pretty_log_name()] velocity to [x], [y], [angular]", usr)

/atom/movable/overmap_object/entity/vv_get_header()
	. = ..()

	#warn render speed/rotation

