/**
 * captures a picture
 */
/obj/item/camera/proc/capture(turf/center, radius, mob/user)
	RETURN_TYPE(/datum/picture)

GLOBAL_LIST_INIT(camera_default_ignore_planes, list(
	SONAR_PLANE,
	PLANE_GHOSTS,
	PLANE_MESONS,
	PLANE_AI_EYE
))

/**
 * makes a picture from a portion of the map, complete with visual metadata
 */
/proc/capture_picture(list/turfs, turf/bottom_left, psize_x = 96, psize_y = 96, offset_x = 0, offset_y = 0, datum/agent, list/planes_ignored = GLOB.camera_default_ignore_planes)
	RETURN_TYPE(/datum/picture)

	// optimize planes
	for(var/plane in planes_ignored)
		planes_ignored[plane] = TRUE

	// sanitize to a max of screenwide
	psize_x = clamp(psize_x, 1, world.icon_size * 15)
	psize_y = clamp(psize_y, 1, world.icon_size * 15)

	// detect tile size
	var/tsize_x = CEILING(psize_x / 32, 1)
	var/tsize_y = CEILING(psize_y / 32, 1)

	// set up appearance clone boundaries
	var/datum/turf_reservation/reservation = SSmapping.RequestBlockReservation(tsize_x, tsize_y)

	// make mobs holder for special handling
	var/list/mobs = list()
	// start assembling visual data
	var/list/visual_data = list()

	// turf scan - clone directly into reserved area
	for(var/turf/T in turfs)
		#warn impl
		for(var/atom/movable/AM as anything in T.contents)
			// AM grabs lighting objects
			if(planes_ignored[AM.plane])
				continue
			// appearance clone
			#warn impl
			if(ismob(AM))
				// add to mobs
				mobs += AM

	// assemble visual data
	// in the future we can probably have flags & DETAILED_PICTURE_DATA instead
	for(var/mob/M as anything in mobs)
		var/data = M.camera_visual_data(actor)
		if(!data)
			continue
		visual_data += data

	// the actual visual rendering goes in here - this is a slow proc and will sleep!
	var/datum/picture/P = __make_picture(translated_turfs, translated_center, psize_x, psize_y)

	// release reservation
	qdel(reservation)

	return P

/**
 * returns nothing or a text string or a full list
 *
 * @params
 * agent - the thing initiating the camera capture, if any
 */
/atom/proc/camera_visual_data(datum/agent)

/**
 * does the full work of making a /datum/picture with just size metadata + the icon from a portion of the map
 */
/proc/__make_picture(list/turfs, turf/center, psize_x, psize_y)

/**
 * does the full work of making an icon from a portion of the map for pictures
 */
/proc/__capture_picture(list/turfs, turf/center, psize_x, psize_y)
	RETURN_TYPE(/icon)

#warn finish
