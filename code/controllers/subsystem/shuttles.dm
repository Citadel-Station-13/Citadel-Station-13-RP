//
// SSshuttles subsystem - Handles initialization and processing of shuttles.
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
	// TODO: recreate web shuttles
	/// Web maps by path
	//  todo: non-static, recover()?
	// var/static/list/shuttle_web_map_type_registry = list()
	/// Web nodes by path
	//  todo: non-static, recover()?
	// var/static/list/shuttle_web_node_type_registry = list()

	//* Shuttles
	/// All shuttles by id
	//  todo: non-static, recover()?
	var/static/list/datum/shuttle/shuttle_registry = list()

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
 * * The shuttle will initially be in a map reservation.
 *
 * @params
 * * template_like - a shuttle-template resolvable (type, id, instance, null)
 * * merge_in_descriptor - a shuttle descriptor whose non-null values will override the template's defaults; optional, default null
 * * map_injections - a list of map injections to apply to the shuttle's map;
 *
 * @return /datum/shuttle on success
 */
/datum/controller/subsystem/shuttle/proc/create_shuttle(datum/shuttle_template/template_like, datum/shuttle_descriptor/merge_in_descriptor, list/datum/map_injection/map_injections)
	var/datum/shuttle_template/template = fetch_template(template_like)
	if(!template)
		return null
	// template.instance() will register it
	var/datum/shuttle/created = template.instance(merge_in_descriptor, map_injections)
	return created

/datum/controller/subsystem/shuttle/proc/register_shuttle(datum/shuttle/shuttle)
	ASSERT(istext(shuttle.id))
	ASSERT(isnull(shuttle_registry[shuttle.id]))
	shuttle_registry[shuttle.id] = shuttle
	#warn impl; how to unregister / delete

/datum/controller/subsystem/shuttle/proc/generate_shuttle_id()
	var/static/notch = 0
	if(notch >= SHORT_REAL_LIMIT)
		stack_trace("how the hell are we at this number?")
		notch = (-SHORT_REAL_LIMIT) + 1
	return "shuttle-[SSmapping.round_global_descriptor]-[++notch]"

//* Shuttle Templates *//

/datum/controller/subsystem/shuttle/proc/fetch_template(datum/shuttle_template/template_like)
	if(ispath(template_like, /datum/shuttle_template))
		if(isnull(templates_by_path[template_like]))
			templates_by_path[template_like] = load_shuttle_template(new template_like)
		return templates_by_path[template_like]
	else if(istext(template_like))
		return templates_by_id[template_like]
	else if(istype(template_like))
		return template_like
	CRASH("what?")

/datum/controller/subsystem/shuttle/proc/load_shuttle_template(datum/shuttle_template/template) as /datum/shuttle_template
	#warn dupe check
	templates_by_id[template.id] = template
	return template

//* Web Shuttles *//

// TODO: recreate web shuttles
// /datum/controller/subsystem/shuttle/proc/fetch_or_load_shuttle_web_node_type(type)
// 	if(isnull(shuttle_web_node_type_registry[type]))
// 		var/datum/shuttle_web_node/node = new type
// 		shuttle_web_node_type_registry[type] = node
// 		node.initialize()
// 	return shuttle_web_node_type_registry[type]

// /datum/controller/subsystem/shuttle/proc/fetch_or_load_shuttle_web_map_type(type)
// 	if(isnull(shuttle_web_map_type_registry[type]))
// 		var/datum/shuttle_web_map/map = new type
// 		shuttle_web_map_type_registry[type] = map
// 	return shuttle_web_map_type_registry[type]

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
