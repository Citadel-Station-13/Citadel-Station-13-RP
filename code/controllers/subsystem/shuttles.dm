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
	// shuttles use spinlocks for now, we'll use subsystem processing at some point
	subsystem_flags = SS_NO_FIRE | SS_NO_TICK_CHECK | SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	//* Docks
	/// shuttle docks by type for non-id registration
	//  todo: non-static, recover()?
	var/static/list/obj/shuttle_dock/dock_type_registry = list()
	/// shuttle docks by id for id registration
	//  todo: non-static, recover()?
	var/static/list/obj/shuttle_dock/dock_id_registry = list()
	/// docks by zlevel
	//  todo: non-static, recover()?
	var/static/list/docks_by_level = list()

	//* Controllers & Maps
	/// Web maps by path
	//  todo: non-static, recover()?
	var/static/list/shuttle_web_map_type_registry = list()
	/// Web nodes by path
	//  todo: non-static, recover()?
	var/static/list/shuttle_web_node_type_registry = list()

	//* Shuttles
	/// All shuttles by id
	//  todo: non-static, recover()?
	var/static/list/datum/shuttle/shuttle_id_registry = list()

	//* Templates
	/// templates by path
	var/list/datum/shuttle_template/templates_by_path = list()
	/// templates by id; hardcoded templates still register in here.
	var/list/datum/shuttle_template/templates_by_id = list()

/datum/controller/subsystem/shuttle/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	docks_by_level.len = new_z_count
	for(var/i in old_z_count to new_z_count)
		if(!isnull(docks_by_level[i]))
			continue
		docks_by_level[i] = list()

//* Docks - Registration *//

/datum/controller/subsystem/shuttle/proc/resolve_dock(obj/shuttle_dock/dock_like)
	if(istext(dock_like))
		return dock_id_registry[dock_like]
	else if(ispath(dock_like))
		return dock_type_registry[dock_like]
	else if(istype(dock_like))
		return dock_like
	else
		CRASH("what?")

/datum/controller/subsystem/shuttle/proc/register_dock(obj/shuttle_dock/dock)
	if(dock.register_by_type)
		if(dock_type_registry[dock.type])
			stack_trace("type collision between [dock] [COORD(dock)] and [dock_type_registry[dock.type]] [COORD(dock_type_registry[dock.type])] on [dock.type]")
		else
			dock_type_registry[dock.type] = dock
	if(dock.dock_id)
		if(dock_id_registry[dock.dock_id])
			stack_trace("id collision between [dock] [COORD(dock)] and [dock_id_registry[dock.dock_id]] [COORD(dock_id_registry[dock.dock_id])] on [dock.dock_id]")
		else
			dock_id_registry[dock.dock_id] = dock
	docks_by_level[dock.z] += dock
	dock.registered = TRUE
	return TRUE

/datum/controller/subsystem/shuttle/proc/unregister_dock(obj/shuttle_dock/dock)
	if(dock.register_by_type)
		if(dock_type_registry[dock.type] != dock)
			stack_trace("dock type registry mismatch during unregister on [dock] [COORD(dock)] for [dock.type], got [dock_type_registry[dock.type]] [COORD(dock_type_registry[dock.type])]")
		else
			dock_type_registry -= dock.type
	if(dock.dock_id)
		if(dock_id_registry[dock.dock_id] != dock)
			stack_trace("dock id registry mismatch during unregister on [dock] [COORD(dock)] for [dock.dock_id], got [dock_id_registry[dock.dock_id]] [COORD(dock_id_registry[dock.dock_id])]")
		else
			dock_id_registry -= dock.dock_id
	docks_by_level[dock.z] -= dock
	dock.registered = FALSE
	return TRUE

//* Shuttles *//

/**
 * @return /datum/shuttle
 */
/datum/controller/subsystem/shuttle/proc/create_shuttle(datum/shuttle_template/templatelike, shuttle_type_override, list/datum/map_injection/map_injections)
	var/datum/shuttle_template/template = fetch_template(templatelike)
	var/datum/shuttle/created = template.instance(map_injections)
	register_shuttle(created)
	return created

/datum/controller/subsystem/shuttle/proc/register_shuttle(datum/shuttle/shuttle)
	ASSERT(istext(shuttle.id))
	ASSERT(isnull(shuttle_id_registry[shuttle.id]))
	shuttle_id_registry[shuttle.id] = shuttle

//* Shuttle Templates *//

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

//* Shuttle Webs *//

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

//* Transit *//

/**
 * sets in_transit_reservation and in_transit_dock and in_transit for a shuttle
 */
/datum/controller/subsystem/shuttle/proc/prepare_transit(datum/shuttle/shuttle)
	// * hardcoded values *//
	// bit above widescreen vision range
	var/border_size = 10
	// bit more space so you can walk out without getting deleted
	var/interior_padding = 10
	#warn what the fuck
