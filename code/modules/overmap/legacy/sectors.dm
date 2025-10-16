//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/overmap/entity/visitable
	name = "map object"
	scannable = TRUE
	scanner_desc = "!! No Data Available !!"

	icon_state = "generic"

	/// Name prior to being scanned if !known
	var/unknown_name = "unknown sector"
	/// Icon_state prior to being scanned if !known
	var/unknown_state = "unknown"

	var/list/map_z = list()
	var/list/extra_z_levels //if you need to manually insist that these z-levels are part of this sector, for things like edge-of-map step trigger transitions rather than multi-z complexes

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles
	var/docking_codes

	var/start_x			//Coordinates for self placing
	var/start_y			//will use random values if unset

	var/base = 0		//starting sector, counts as station_levels
	var/in_space = 1	//can be accessed via lucky EVA

	var/hide_from_reports = FALSE

	var/sensors

	var/has_distress_beacon
	var/list/unowned_areas // areas we don't own despite them being present on our z

/obj/overmap/entity/visitable/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	find_z_levels() // This populates map_z and assigns z levels to the ship.
	register_z_levels() // This makes external calls to update global z level information.

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	// todo: This is shitcode but sue me tbh we gotta refactor this shit anyways to be overmap_initializer's
	spawn(-1)
		var/datum/overmap/legacy_bind_overmap = SSovermaps.get_or_load_default_overmap()
		var/turf/where_to_go = free_overmap_space(legacy_bind_overmap)
		start_x = where_to_go.x
		start_y = where_to_go.y

		forceMove(where_to_go)
		testing("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

		if(known)
			plane = ABOVE_LIGHTING_PLANE
			SSovermaps.queue_helm_computer_rebuild()
		else
			real_appearance = image(icon, src, icon_state)
			real_appearance.override = TRUE
			name = unknown_name
			icon_state = unknown_state
			color = null
			desc = "Scan this to find out more information."

		LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
		SSshuttle.process_init_queues()

// You generally shouldn't destroy these.
/obj/overmap/entity/visitable/Destroy()
	testing("Deleting [src] overmap sector at [x],[y]")
	unregister_z_levels()
	return ..()

//This is called later in the init order by SSshuttles to populate sector objects. Importantly for subtypes, shuttles will be created by then.
/obj/overmap/entity/visitable/proc/populate_sector_objects()

/obj/overmap/entity/visitable/proc/get_areas()
	. = list()
	for(var/area/A)
		if (A.z in map_z)
			. += A

/obj/overmap/entity/visitable/proc/find_z_levels()
	if(!LAZYLEN(map_z)) // If map_z is already populated use it as-is, otherwise start with connected z-levels.
		map_z = GetConnectedZlevels(z)
	if(LAZYLEN(extra_z_levels))
		for(var/thing in extra_z_levels)
			var/datum/map_level/level
			if(ispath(thing))
				level = SSmapping.typed_levels[thing]
			else if(istext(thing))
				level = SSmapping.keyed_levels[thing]
			if(isnull(level))
				STACK_TRACE("failed to find level [thing] during init")
				continue
			map_z |= level.z_index

/obj/overmap/entity/visitable/proc/register_z_levels()
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	(LEGACY_MAP_DATUM).player_levels |= map_z
	if(!in_space)
		(LEGACY_MAP_DATUM).sealed_levels |= map_z

/obj/overmap/entity/visitable/proc/unregister_z_levels()
	map_sectors -= map_z

	(LEGACY_MAP_DATUM).player_levels -= map_z
	if(!in_space)
		(LEGACY_MAP_DATUM).sealed_levels -= map_z

/obj/overmap/entity/visitable/get_scan_data()
	if(!known)
		known = TRUE
		name = initial(name)
		icon_state = initial(icon_state)
		color = initial(color)
		desc = initial(desc)
	return ..()

/obj/overmap/entity/visitable/proc/get_space_zlevels()
	if(in_space)
		return map_z
	else
		return list()

//Helper for init.
/obj/overmap/entity/visitable/proc/check_ownership(obj/object)
	var/area/A = get_area(object)
	if(A in SSshuttle.shuttle_areas)
		return 0
	if(is_type_in_list(A, unowned_areas))
		return 0
	if(get_z(object) in map_z)
		return 1

//If shuttle_name is false, will add to generic waypoints; otherwise will add to restricted. Does not do checks.
/obj/overmap/entity/visitable/proc/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_name)
	landmark.sector_set(src, shuttle_name)
	if(shuttle_name)
		LAZYADD(restricted_waypoints[shuttle_name], landmark)
	else
		generic_waypoints += landmark

/obj/overmap/entity/visitable/proc/remove_landmark(obj/effect/shuttle_landmark/landmark, shuttle_name)
	if(shuttle_name)
		var/list/shuttles = restricted_waypoints[shuttle_name]
		LAZYREMOVE(shuttles, landmark)
	else
		generic_waypoints -= landmark

/obj/overmap/entity/visitable/proc/get_waypoints(var/shuttle_name)
	. = list()
	for(var/obj/overmap/entity/visitable/contained in src)
		. += contained.get_waypoints(shuttle_name)
	for(var/thing in generic_waypoints)
		.[thing] = name
	if(shuttle_name in restricted_waypoints)
		for(var/thing in restricted_waypoints[shuttle_name])
			.[thing] = name

/obj/overmap/entity/visitable/proc/cleanup()
	return FALSE

/obj/overmap/entity/visitable/MouseEntered(location, control, params)
	openToolTip(user = usr, tip_src = src, params = params, title = name)

	..()

/obj/overmap/entity/visitable/MouseDown()
	closeToolTip(usr) //No reason not to, really

	..()

/obj/overmap/entity/visitable/MouseExited()
	closeToolTip(usr) //No reason not to, really

	..()

/obj/overmap/entity/visitable/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = TRUE

/obj/overmap/entity/visitable/proc/distress(mob/user)
	if(has_distress_beacon)
		return FALSE
	has_distress_beacon = TRUE

	admin_chat_message(message = "Overmap panic button hit on z[z] ([name]) by '[user?.ckey || "Unknown"]'", color = "#FF2222")
	var/message = "This is an automated distress signal from a MIL-DTL-93352-compliant beacon transmitting on [FREQ_COMMON*0.1]kHz. \
	This beacon was launched from '[initial(name)]'. I can provide this additional information to rescuers: [get_distress_info()]. \
	Per the Interplanetary Convention on Space SAR, those receiving this message must attempt rescue, \
	or relay the message to those who can. This message will repeat one time in 5 minutes. Thank you for your urgent assistance."

	priority_announcement.Announce(message, new_title = "Automated Distress Signal", zlevel = -1)//announce now tells every z-level once if -1 is passed

	priority_announcement.Sound('sound/AI/sos.ogg')//play the sound once

	var/image/I = image(icon, icon_state = "distress")
	I.plane = ABOVE_LIGHTING_PLANE
	I.appearance_flags = KEEP_APART|RESET_TRANSFORM|RESET_COLOR
	add_overlay(I)

	addtimer(CALLBACK(src, PROC_REF(distress_update)), 5 MINUTES)
	return TRUE

/obj/overmap/entity/visitable/proc/get_distress_info()
	return "\[X:[x], Y:[y]\]"

/obj/overmap/entity/visitable/proc/distress_update()
	var/message = "This is the final message from the distress beacon launched from '[initial(name)]'. I can provide this additional information to rescuers: [get_distress_info()]. \
	Please render assistance under your obligations per the Interplanetary Convention on Space SAR, or relay this message to a party who can. Thank you for your urgent assistance."

	priority_announcement.Announce(message, new_title = "Automated Distress Signal", new_sound = 'sound/AI/sos.ogg', zlevel = -1)

/obj/overmap/entity/visitable/proc/free_overmap_space(datum/overmap/map)
	var/list/turf/potential_turfs = map.reservation.unordered_inner_turfs()
	var/safety = 1000
	var/turf/potential
	while((potential = pick_n_take(potential_turfs)))
		if(length(potential.contents))
			// something already here
			continue
		if(safety-- < 0)
			stack_trace("safety ran out, that shouldn't really happen but okay")
			break
		break
	if(!potential)
		potential = locate(map.lower_left_x, map.lower_left_y, map.reservation.bottom_left_coords[3])
	return potential
