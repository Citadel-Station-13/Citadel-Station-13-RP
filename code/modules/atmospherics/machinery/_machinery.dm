/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
/obj/machinery/atmospherics
	#warn split all icons
	#warn AAAAAAAAA

	anchored = TRUE
	// move_resist = INFINITY				//Moving a connected machine without actually doing the normal (dis)connection things will probably cause a LOT of issues.
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON
	layer = GAS_PIPE_HIDDEN_LAYER //under wires
	plane = ABOVE_WALL_PLANE
	// resistance_flags = FIRE_PROOF
	// max_integrity = 200
	obj_flags = CAN_BE_HIT | ON_BLUEPRINTS

	/// See __DEFINES/atmospherics
	var/pipe_flags = NONE
	/// The layer we're on. Overriden by PIPE_ALL_LAYER
	var/pipe_layer = PIPE_LAYER_DEFAULT
	/// Does this interact with the environment or just with pipenets? If so, it needs to be TRUE so we set it to the right processing bracket.
	var/interacts_with_air = FALSE
	/// List of atmosmachinery we're connected to
	var/list/obj/machinery/atmospherics/connected
	/// Device type, determining the number of connections we have. If we're PIPE_ALL_LAYER, this is multiplied by total pipe layers.
	var/device_type = NONE
	/// Directions we'll connect in. Set dynamically by our dir.
	var/initialize_directions = NONE
	#warn impl

#warn eval below (it's still new)

	var/nodealert = 0
	var/can_unwrench = 0
	var/pipe_color

	var/static/list/iconsetids = list()
	var/static/list/pipeimages = list()

	var/image/pipe_vision_img = null

	var/construction_type
	var/pipe_state //icon_state as a pipe item
	var/on = FALSE


#warn BELOW IS LEGACY

	///The color of the pipe
	var/pipe_color
	///The maximum amount of power the machine can use to do work, affects how powerful the machine is, in Watts
	var/power_rating
	///"-supply" or "-scrubbers"
	var/icon_connect_type = ""
	///The type path of the pipe item when this is deconstructed.
	var/construction_type = null
	///icon_state as a pipe item
	var/pipe_state

	var/global/datum/pipe_icon_manager/icon_manager
	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

#warn ABOVE IS LEGACY

/obj/machinery/atmospherics/Initialize(mapload, process = TRUE, setdir, setlayer, constructed = FALSE)
	if(!isnull(setdir))
		setDir(setdir)
	if(!isnull(setlayer))
		pipe_layer = setlayer
	if (!armor)
		armor = list("melee" = 25, "bullet" = 10, "laser" = 10, "energy" = 100, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 70)
	. = ..()
	if(process)
		if(interacts_with_air)
			SSair.atmos_air_machinery += src
		else
			SSair.atmos_machinery += src
	if(SSair.initialized && !mapload && !constructed)
		// if not custom constructing, immediately init
		// If mapload, we're in a template, wait for finish.
		InitAtmos()

/obj/machinery/atmospherics/Destroy()
	Leave()
	SSair.atmos_machinery -= src
	SSair.atmos_air_machinery -= src

	dropContents()
	if(pipe_vision_img)
		qdel(pipe_vision_img)

	return ..()
	//return QDEL_HINT_FINDREFERENCE

/**
 * Called once on init.
 */
/obj/machinery/atmospherics/proc/InitAtmos(immediate_join = TRUE)
	connected = new /list(MaximumPossibleNodes())
	if(!immediate_join)
		return
	Join()

#warn ABOVE AAAAAAAAAA
#warn BELOW IS LEGACY

/obj/machinery/atmospherics/Initialize(mapload, newdir)
	. = ..()
	if(!icon_manager)
		icon_manager = new()
	if(!isnull(newdir))
		setDir(newdir)
	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null
	init_dir()

/obj/machinery/atmospherics/proc/add_underlay(var/turf/T, var/obj/machinery/atmospherics/node, var/direction, var/icon_connect_type)
	if(node)
		if(!T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			//underlays += icon_manager.get_atmos_icon("underlay_down", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			//underlays += icon_manager.get_atmos_icon("underlay_intact", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		//underlays += icon_manager.get_atmos_icon("underlay_exposed", direction, pipe_color)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "exposed" + icon_connect_type)

/obj/machinery/atmospherics/proc/update_underlays()
	if(check_icon_cache())
		return 1
	else
		return 0

/obj/machinery/atmospherics/proc/check_icon_cache(var/safety = 0)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(1)
		return 0

	return 1

/obj/machinery/atmospherics/proc/color_cache_name(var/obj/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color


/obj/machinery/atmospherics/update_icon()
	return null

/obj/machinery/atmospherics/proc/unsafe_pressure()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		return TRUE
	return FALSE

// Deconstruct into a pipe item.
/obj/machinery/atmospherics/proc/deconstruct()
	if(QDELETED(src))
		return
	if(construction_type)
		var/obj/item/pipe/I = new construction_type(loc, null, null, src)
		I.setPipingLayer(piping_layer)
		transfer_fingerprints_to(I)
	qdel(src)

// Return a list of nodes which we should call atmos_init() and build_network() during on_construction()
/obj/machinery/atmospherics/proc/get_neighbor_nodes_for_init()
	return null

// Called on construction (i.e from pipe item) but not on initialization
/obj/machinery/atmospherics/proc/on_construction(obj_color, set_layer)
	pipe_color = obj_color
	setPipingLayer(set_layer)
	// TODO - M.connect_types = src.connect_types - Or otherwise copy from item? Or figure it out from piping layer?
	var/turf/T = get_turf(src)
	level = !T.is_plating() ? 2 : 1
	atmos_init()
	if(QDELETED(src))
		return // TODO - Eventually should get rid of the need for this.
	build_network()
	var/list/nodes = get_neighbor_nodes_for_init()
	for(var/obj/machinery/atmospherics/A in nodes)
		A.atmos_init()
		A.build_network()
	// TODO - Should we do src.build_network() before or after the nodes?
	// We've historically done before, but /tg does after. TODO research if there is a difference.
