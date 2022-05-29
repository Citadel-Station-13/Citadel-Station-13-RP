//
// Recipies for Pipe Dispenser and the RPD
//

GLOBAL_LIST_INIT(atmos_pipe_recipes, list(
	"Pipes" = list(
		new /datum/pipe_info/pipe("Pipe", /obj/machinery/atmospherics/pipe/simple, TRUE),
		new /datum/pipe_info/pipe("Manifold", /obj/machinery/atmospherics/pipe/manifold, TRUE),
		new /datum/pipe_info/pipe("Manual Valve", /obj/machinery/atmospherics/valve, TRUE),
		new /datum/pipe_info/pipe("Digital Valve", /obj/machinery/atmospherics/valve/digital, TRUE),
		new /datum/pipe_info/pipe("Pipe cap", /obj/machinery/atmospherics/pipe/cap, TRUE),
		new /datum/pipe_info/pipe("4-Way Manifold", /obj/machinery/atmospherics/pipe/manifold4w, TRUE),
		new /datum/pipe_info/pipe("Manual T-Valve", /obj/machinery/atmospherics/tvalve, TRUE),
		new /datum/pipe_info/pipe("Digital T-Valve", /obj/machinery/atmospherics/tvalve/digital, TRUE),
		new /datum/pipe_info/pipe("Upward Pipe", /obj/machinery/atmospherics/pipe/zpipe/up, TRUE),
		new /datum/pipe_info/pipe("Downward Pipe", /obj/machinery/atmospherics/pipe/zpipe/down, TRUE),
		new /datum/pipe_info/pipe("Universal Pipe Adaptor",/obj/machinery/atmospherics/pipe/simple/visible/universal, FALSE),
	),
	"Devices" = list(
		new /datum/pipe_info/pipe("Connector", /obj/machinery/atmospherics/portables_connector, TRUE),
		new /datum/pipe_info/pipe("Unary Vent", /obj/machinery/atmospherics/component/unary/vent_pump, TRUE),
		new /datum/pipe_info/pipe("Aux Vent", /obj/machinery/atmospherics/component/unary/vent_pump/aux, TRUE),
		new /datum/pipe_info/pipe("Passive Vent", /obj/machinery/atmospherics/pipe/vent, TRUE),
		new /datum/pipe_info/pipe("Injector", /obj/machinery/atmospherics/component/unary/outlet_injector, TRUE),
		new /datum/pipe_info/pipe("Gas Pump", /obj/machinery/atmospherics/component/binary/pump, TRUE),
		new /datum/pipe_info/pipe("Fuel Pump", /obj/machinery/atmospherics/component/binary/pump/fuel, TRUE),
		new /datum/pipe_info/pipe("Aux Pump", /obj/machinery/atmospherics/component/binary/pump/aux, TRUE),
		new /datum/pipe_info/pipe("Pressure Regulator", /obj/machinery/atmospherics/component/binary/passive_gate, TRUE),
		new /datum/pipe_info/pipe("High Power Gas Pump", /obj/machinery/atmospherics/component/binary/pump/high_power, TRUE),
		new /datum/pipe_info/pipe("Heat Pump", /obj/machinery/atmospherics/component/binary/heat_pump, TRUE),
		//new /datum/pipe_info/pipe("Automatic Shutoff Valve",/obj/machinery/atmospherics/valve/shutoff, TRUE),
		new /datum/pipe_info/pipe("Scrubber", /obj/machinery/atmospherics/component/unary/vent_scrubber, TRUE),
		new /datum/pipe_info/pipe("Gas Filter", /obj/machinery/atmospherics/component/trinary/atmos_filter, TRUE),
		new /datum/pipe_info/pipe("Gas Mixer", /obj/machinery/atmospherics/component/trinary/mixer, TRUE),
		new /datum/pipe_info/pipe("Gas Mixer 'T'", /obj/machinery/atmospherics/component/trinary/mixer/t_mixer, TRUE),
		new /datum/pipe_info/pipe("Omni Gas Mixer", /obj/machinery/atmospherics/component/quaternary/mixer, TRUE),
		new /datum/pipe_info/pipe("Omni Gas Filter", /obj/machinery/atmospherics/component/quaternary/atmos_filter, TRUE),
		new /datum/pipe_info/meter("Meter"),
	),
	"Heat Exchange" = list(
		new /datum/pipe_info/pipe("Pipe", /obj/machinery/atmospherics/pipe/simple/heat_exchanging, FALSE),
		new /datum/pipe_info/pipe("Junction", /obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction, FALSE),
		new /datum/pipe_info/pipe("Heat Exchanger", /obj/machinery/atmospherics/component/unary/heat_exchanger, FALSE),
	),
	"Insulated pipes" = list(
		new /datum/pipe_info/pipe("Pipe", /obj/machinery/atmospherics/pipe/simple/insulated, TRUE),
	)
))

GLOBAL_LIST_INIT(disposal_pipe_recipes, list(
	"Disposal Pipes" = list(
		new /datum/pipe_info/disposal("Pipe", DISPOSAL_PIPE_STRAIGHT, "conpipe-s", PIPE_STRAIGHT),
		new /datum/pipe_info/disposal("Bent Pipe", DISPOSAL_PIPE_CORNER, "conpipe-c"),
		new /datum/pipe_info/disposal("Junction", DISPOSAL_PIPE_JUNCTION, "conpipe-j1", PIPE_TRIN_M),
		new /datum/pipe_info/disposal("Y-Junction", DISPOSAL_PIPE_JUNCTION_Y, "conpipe-y"),
		new /datum/pipe_info/disposal("Sort Junction", DISPOSAL_PIPE_SORTER, "conpipe-j1s", PIPE_TRIN_M, DISPOSAL_SORT_NORMAL),
		new /datum/pipe_info/disposal("Sort Junction (Wildcard)",	DISPOSAL_PIPE_SORTER, "conpipe-j1s", PIPE_TRIN_M, DISPOSAL_SORT_WILDCARD),
		new /datum/pipe_info/disposal("Sort Junction (Untagged)",	DISPOSAL_PIPE_SORTER, "conpipe-j1s", PIPE_TRIN_M, DISPOSAL_SORT_UNTAGGED),
		new /datum/pipe_info/disposal("Tagger", DISPOSAL_PIPE_TAGGER, "pipe-tagger", PIPE_STRAIGHT),
		new /datum/pipe_info/disposal("Tagger (Partial)", DISPOSAL_PIPE_TAGGER_PARTIAL, "pipe-tagger-partial", PIPE_STRAIGHT),
		new /datum/pipe_info/disposal("Trunk", DISPOSAL_PIPE_TRUNK, "conpipe-t"),
		new /datum/pipe_info/disposal("Upwards", DISPOSAL_PIPE_UPWARD, "pipe-u"),
		new /datum/pipe_info/disposal("Downwards", DISPOSAL_PIPE_DOWNWARD, "pipe-d"),
		new /datum/pipe_info/disposal("Bin", DISPOSAL_PIPE_BIN, "disposal", PIPE_ONEDIR),
		new /datum/pipe_info/disposal("Outlet", DISPOSAL_PIPE_OUTLET, "outlet"),
		new /datum/pipe_info/disposal("Chute", DISPOSAL_PIPE_CHUTE, "intake"),
	)
))

GLOBAL_LIST_INIT(pipe_layers, list(
		"Aux" = PIPING_LAYER_AUX,
		"Supply" = PIPING_LAYER_SUPPLY,
		"Regular" = PIPING_LAYER_REGULAR,
		"Scrubber" = PIPING_LAYER_SCRUBBER,
		"Fuel" = PIPING_LAYER_FUEL
	))

//
// New method of handling pipe construction.  Instead of numeric constants and a giant switch statement of doom
// 	every pipe type has a datum instance which describes its name, placement rules and construction method, dispensing etc.
// The advantages are obvious, mostly in simplifying the code of the dispenser, and the ability to add new pipes without hassle.
//
/datum/pipe_info
	var/name = "Abstract Pipe (fixme)"		// Recipe name
	var/pipe_type							// The type PATH of what actual pipe the fitting becomes, used by RCD to print the pipe.
	var/icon = 'icons/obj/pipe-item.dmi'	// This tells the RPD which icon file to look for preview images in.
	var/icon_state							// This tells the RPD what kind of pipe icon to render for the preview.
	var/icon_state_m						// This stores the mirrored version of the regular state (if available).
	var/dirtype								// If using an RPD, this tells more about what previews to show.
	var/subtype = 0							// Used for certain disposals pipes types.
	var/paintable = FALSE					// If TRUE, allow the RPD to paint this pipe.
	var/all_layers

// Get preview for UIs
/datum/pipe_info/proc/get_preview(selected_dir)
	var/list/dirs

	switch(dirtype)

		if(PIPE_STRAIGHT, PIPE_BENDABLE)
			dirs = list("[NORTH]" = "Vertical", "[EAST]" = "Horizontal")
			if(dirtype == PIPE_BENDABLE)
				dirs += list(
					"[NORTHWEST]" = "West to North", "[NORTHEAST]" = "North to East",
					"[SOUTHWEST]" = "South to West", "[SOUTHEAST]" = "East to South"
					)

		if(PIPE_TRINARY)
			dirs = list(
				"[NORTH]" = "West South East", "[SOUTH]" = "East North West",
				"[EAST]" = "North West South", "[WEST]" = "South East North"
				)

		if(PIPE_TRIN_M)
			dirs = list(
				"[NORTH]" = "North East South", "[SOUTHWEST]" = "North West South",
				"[NORTHEAST]" = "South East North", "[SOUTH]" = "South West North",
				"[WEST]" = "West North East", "[SOUTHEAST]" = "West South East",
				"[NORTHWEST]" = "East North West", "[EAST]" = "East South West",
				)

		if(PIPE_DIRECTIONAL)
			dirs = list(
				"[NORTH]" = "North", "[SOUTH]" = "South",
				"[WEST]" = "West", "[EAST]" = "East"
				)

		if(PIPE_ONEDIR)
			dirs = list("[SOUTH]" = name)

		if(PIPE_UNARY_FLIPPABLE)
			dirs = list(
				"[NORTH]" = "North", "[EAST]" = "East",
				"[SOUTH]" = "South", "[WEST]" = "West",
				"[NORTHEAST]" = "North Flipped", "[SOUTHEAST]" = "East Flipped",
				"[SOUTHWEST]" = "South Flipped", "[NORTHWEST]" = "West Flipped"
				)


	var/list/rows = list()
	var/list/row = list("previews" = list())
	var/i = 0
	for(var/dir in dirs)
		var/numdir = text2num(dir)
		var/flipped = ((dirtype == PIPE_TRIN_M) || (dirtype == PIPE_UNARY_FLIPPABLE)) && (numdir in GLOB.cornerdirs)
		row["previews"] += list(list("selected" = (numdir == selected_dir), "dir" = dir2text(numdir), "dir_name" = dirs[dir], "icon_state" = icon_state, "flipped" = flipped))
		if(i++ || dirtype == PIPE_ONEDIR)
			rows += list(row)
			row = list("previews" = list())
			i = 0

	return rows

//
// Subtype for actual pipes
//
/datum/pipe_info/pipe
	var/obj/item/pipe/construction_type //The type PATH to the type of pipe fitting object the recipe makes.

/datum/pipe_info/pipe/New(label, obj/machinery/atmospherics/path, var/use_five_layers, var/colorable=FALSE)
	name = label
	pipe_type = path
	all_layers = use_five_layers
	construction_type = initial(path.construction_type)
	icon_state = initial(path.pipe_state)
	dirtype = initial(construction_type.dispenser_class)
	if(dirtype == PIPE_TRIN_M)
		icon_state_m = "[icon_state]m"
	paintable = colorable

//
// Subtype for meters
//
/datum/pipe_info/meter
	dirtype = PIPE_ONEDIR
	icon_state = "meter"
	pipe_type = /obj/item/pipe_meter

/datum/pipe_info/meter/New(label)
	name = label

//
// Subtype for disposal pipes
//
/datum/pipe_info/disposal
	icon = 'icons/obj/pipes/disposal.dmi'

/datum/pipe_info/disposal/New(var/label, var/path, var/state, dt=PIPE_DIRECTIONAL, var/state_mirror=0, var/sort=0)
	name = label
	icon_state = state
	pipe_type = path
	dirtype = dt
	subtype = sort
	if (dirtype == PIPE_TRIN_M)
		icon_state_m = state_mirror
