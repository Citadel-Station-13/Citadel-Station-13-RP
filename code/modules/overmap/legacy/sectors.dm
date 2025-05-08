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

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles
	var/docking_codes

	var/start_x			//Coordinates for self placing
	var/start_y			//will use random values if unset

	var/in_space = 1	//can be accessed via lucky EVA

	var/sensors

	var/has_distress_beacon
	var/list/unowned_areas // areas we don't own despite them being present on our z

/obj/overmap/entity/visitable/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	//! legacy: make a 1-z sector if we spawned on a level without an entity, and without a struct. !//
	if(!overmap)
		#warn deal with this, needs to bind to map instead
		var/our_z = get_z(src)
		if(our_z)
			var/obj/overmap/entity/existing_entity = SSovermaps.get_enclosing_overmap_entity(our_z)
			if(!existing_entity)
				var/datum/map_struct/existing_struct = SSmapping.level_get_struct(our_z)
				if(!existing_struct)
					var/datum/map_struct/new_struct = new
					if(!new_struct.construct(list("0,0,0" = SSmapping.ordered_levels[our_z])))
						CRASH("failed to construct a legacy level's ephemeral struct.")
					var/datum/overmap_location/struct/new_location = new(new_struct)
					set_location(new_location)

	// todo: This is shitcode but sue me tbh we gotta refactor this shit anyways to be overmap_initializer's
	spawn(-1)
		if(!overmap)
			var/datum/overmap/legacy_bind_overmap = SSovermaps.get_or_load_default_overmap()
			var/turf/where_to_go = free_overmap_space(legacy_bind_overmap)
			start_x = where_to_go.x
			start_y = where_to_go.y

			forceMove(where_to_go)
			testing("Located legacy sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

		if(known)
			plane = ABOVE_LIGHTING_PLANE
			for(var/obj/machinery/computer/ship/helm/H in GLOB.machines)
				H.get_known_sectors()
		else
			real_appearance = image(icon, src, icon_state)
			real_appearance.override = TRUE
			name = unknown_name
			icon_state = unknown_state
			color = null
			desc = "Scan this to find out more information."

		LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
		SSshuttle.process_init_queues()

//This is called later in the init order by SSshuttles to populate sector objects. Importantly for subtypes, shuttles will be created by then.
/obj/overmap/entity/visitable/proc/populate_sector_objects()

/obj/overmap/entity/visitable/get_scan_data()
	if(!known)
		known = TRUE
		name = initial(name)
		icon_state = initial(icon_state)
		color = initial(color)
		desc = initial(desc)
	return ..()

/obj/overmap/entity/visitable/proc/get_space_zlevels()
	return in_space ? get_z_indices() : list()

//Helper for init.
/obj/overmap/entity/visitable/proc/check_ownership(obj/object)
	return get_overmap_sector(object) == src

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
