/**
 * ftl destination that jumps the ship to a specified coordinate on an overmaps instance
 */
/datum/ftl_destination/map_location
	/// overmap to jump to
	var/datum/overmap/overmap
	/// x
	var/x
	/// y
	var/y
	/// angle to set if any
	var/angle
	/// velocity x to set if any
	var/velocity_x
	/// velocity y to set if any
	var/velocity_y
	/// angular velocity to set if any
	var/angular_velocity

/datum/ftl_destination/map_location/New(datum/overmap/overmap, x, y, angle, vel_x, vel_y, vel_angle)
	src.overmap = overmap
	src.x = x
	src.y = y
	src.angle = angle
	velocity_x = vel_x
	velocity_y = vel_y
	angular_velocity = vel_angle

	// set name/desc
	name = "[overmap] - [overmap.render_location(x, y)]"
	desc = "A FTL jump to [overmap.render_location(x, y)] @ [overmap]"

/datum/ftl_destination/map_location/Destroy()
	overmap = null
	return ..()

/datum/ftl_destination/map_location/Shunt(atom/movable/overmap_object/object)
	#warn impl
	return FTL_DESTINATION_SHUNT_COMPLETE
