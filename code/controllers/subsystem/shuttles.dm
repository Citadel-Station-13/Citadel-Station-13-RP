//
// SSshuttle subsystem - Handles initialization and processing of shuttles.
//
// Also handles initialization and processing of overmap sectors.	// For... some reason...
//

SUBSYSTEM_DEF(shuttle)
	name = "Shuttles"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_SHUTTLES
	init_order = INIT_ORDER_SHUTTLES
	subsystem_flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	//* Docks
	/// shuttle docks by type for non-id registration
	var/static/list/dock_type_registry = list()
	/// shuttle docks by id for id registration
	var/static/list/dock_id_registry = list()
	/// docks by zlevel
	#warn hook
	var/static/list/docks_by_level = list()

	//* Controllers & Maps
	/// Web maps by path
	var/static/list/shuttle_web_map_type_registry = list()
	/// Web nodes by path
	var/static/list/shuttle_web_node_type_registry = list()

	//* Templates
	/// templates by path
	var/list/datum/shuttle_template/templates_by_path = list()
	/// templates by id; hardcoded templates still register in here.
	var/list/datum/shuttle_template/templates_by_id = list()

	#warn below

	/// Shuttles remaining to process this fire() tick
	var/tmp/list/current_run



#warn above

/datum/controller/subsystem/shuttle/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	docks_by_level.len = new_z_count
	for(var/i in old_z_count to new_z_count)
		if(!isnull(docks_by_level[i]))
			continue
		docks_by_level[i] = list()

//* Shuttle Templates

/datum/controller/subsystem/shuttle/proc/fetch_template(datum/shuttle_template/templatelike)
	if(ispath(templatelike, /datum/shuttle_template))
		if(isnull(templates_by_path[templatelike]))
			templates_by_path[templatelike] = load_shuttle_template(new templatelike)
		return templates_by_path[templatelike]
	else if(istext(templatelike))
		return templates_by_id[templatelike]
	else if(istype(templatelike))
		return templatelike
	CRASH("what?")

/datum/controller/subsystem/shuttle/proc/load_shuttle_template(datum/shuttle_template/template)
	templates_by_id[template.id] = template
	return template

//* Shuttle Webs

/datum/controller/subsystem/shuttle/proc/fetch_or_load_shuttle_web_node_type(type)
	if(isnull(shuttle_web_node_type_registry[type]))
		var/datum/shuttle_web_node/node = new type
		shuttle_web_node_type_registry[type] = node
		node.initialize()
	return shuttle_web_node_type_registry[type]

/datum/controller/subsystem/shuttle/proc/fetch_or_load_shuttle_web_map_type(type)
	if(isnull(shuttle_web_map_type_registry[type]))
		var/datum/shuttle_web_map/map = new type
		shuttle_web_map_type_registry[type] = map
	return shuttle_web_map_type_registry[type]

#warn below

/datum/controller/subsystem/shuttle/fire(resumed = 0)
	if (!resumed)
		src.current_run = process_shuttles.Copy()

	var/list/working_shuttles = src.current_run	// Cache for sanic speed
	while(working_shuttles.len)
		var/datum/shuttle/S = working_shuttles[working_shuttles.len]
		working_shuttles.len--
		if(!istype(S) || QDELETED(S))
			log_debug(SPAN_DEBUG("Bad entry in SSshuttle.process_shuttles - [log_info_line(S)] "))
			process_shuttles -= S
			continue
		// NOTE - In old system, /datum/shuttle/ferry was processed only if (F.process_state || F.always_process)
		if(S.process_state && (S.process(wait, times_fired, src) == PROCESS_KILL))
			process_shuttles -= S

		if(MC_TICK_CHECK)
			return

// Initializes all shuttles in shuttles_to_initialize
/datum/controller/subsystem/shuttle/proc/initialize_shuttles()
	var/list/shuttles_made = list()
	for(var/shuttle_type in shuttles_to_initialize)
		var/shuttle = initialize_shuttle(shuttle_type)
		if(shuttle)
			shuttles_made += shuttle
	hook_up_motherships(shuttles_made)
	hook_up_shuttle_objects(shuttles_made)
	shuttles_to_initialize = null
	//! citadel edit - initialize overmaps shuttles here until we rewrite overmaps to not be a dumpster fire god damnit
	for(var/obj/machinery/atmospherics/component/unary/engine/E in unary_engines)
		if(E.linked)
			continue
		E.link_to_ship()
	for(var/obj/machinery/ion_engine/E in ion_engines)
		if(E.linked)
			continue
		E.link_to_ship()

/datum/controller/subsystem/shuttle/proc/register_landmark(shuttle_landmark_tag, obj/effect/shuttle_landmark/shuttle_landmark)
	if (registered_shuttle_landmarks[shuttle_landmark_tag])
		CRASH("Attempted to register shuttle landmark with tag [shuttle_landmark_tag], but it is already registered!")
	if (istype(shuttle_landmark))
		registered_shuttle_landmarks[shuttle_landmark_tag] = shuttle_landmark
		last_landmark_registration_time = world.time

		var/obj/overmap/entity/visitable/O = landmarks_still_needed[shuttle_landmark_tag]
		if(O)	// These need to be added to sectors, which we handle.
			try_add_landmark_tag(shuttle_landmark_tag, O)
			landmarks_still_needed -= shuttle_landmark_tag
		else if(istype(shuttle_landmark, /obj/effect/shuttle_landmark/automatic))	// These find their sector automatically
			O = map_sectors["[shuttle_landmark.z]"]
			O ? O.add_landmark(shuttle_landmark, shuttle_landmark.shuttle_restricted) : (landmarks_awaiting_sector += shuttle_landmark)

/datum/controller/subsystem/shuttle/proc/initialize_shuttle(var/shuttle_type)
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)	// Skip if its an "abstract class" datum
		shuttle = new shuttle()
		shuttle_types[shuttle.type] = shuttle
		shuttle_areas |= shuttle.shuttle_area
		log_debug(SPAN_DEBUG("Initialized shuttle [shuttle] ([shuttle.type])"))
		return shuttle
		// Historical note:  No need to call shuttle.init_docking_controllers(), controllers register themselves
		// and shuttles fetch refs in New().  Shuttles also dock() themselves in new if they want.

// Let shuttles scan their owned areas for objects they want to configure (Called after mothership hookup)
/datum/controller/subsystem/shuttle/proc/hook_up_shuttle_objects(shuttles_list)
	for(var/datum/shuttle/S in shuttles_list)
		S.populate_shuttle_objects()
