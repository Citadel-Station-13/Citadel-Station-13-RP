/turf/simulated/floor/diona
	name = "biomass flooring"
	icon_state = "diona"

/turf/simulated/floor/diona/attackby()
	return

/turf/simulated/shuttle_ceiling
	name = "shuttle ceiling"
	icon = 'icons/turf/shuttle_white.dmi'
	icon_state = "light"
	desc = "An extremely thick segment of hull used by spacefaring vessels. Doesn't look like you'll be able to break it."
	baseturfs = /turf/simulated/shuttle_ceiling

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle_white.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

	var/interior_corner = 0
	var/takes_underlays = TRUE
	var/turf/under_turf	// Underlay override turf path.
	var/join_flags = 0	// Bitstring to represent adjacency of joining walls
	var/join_group = "shuttle"	// A tag for what other walls to join with. Null if you don't want them to.
	var/static/list/antilight_cache

/turf/simulated/shuttle/Initialize(mapload)
	. = ..()
	if(!antilight_cache)
		antilight_cache = list()
		for(var/diag in GLOB.cornerdirs)
			var/image/I = image(LIGHTING_ICON, null, icon_state = "diagonals", layer = 10, dir = diag)
			I.plane = LIGHTING_PLANE
			antilight_cache["[diag]"] = I

// For joined corners touching static lighting turfs, add an overlay to cancel out that part of our lighting overlay.
/turf/simulated/shuttle/proc/update_breaklights()
	if(join_flags in GLOB.cornerdirs)	// We're joined at an angle
		// Dynamic lighting dissolver
		var/turf/T = get_step(src, turn(join_flags,180))
		if(!T || !T.dynamic_lighting || !get_area(T).dynamic_lighting)
			add_overlay(antilight_cache["[join_flags]"], TRUE)
			return
	cut_overlay(antilight_cache["[join_flags]"], TRUE)

/turf/simulated/shuttle/proc/underlay_update()
	if(!takes_underlays)
		// Basically, if it's not forced, and we don't care, don't do it.
		return 0

	var/turf/under	// May be a path or a turf
	var/mutable_appearance/us = new(src)	// We'll use this for changes later
	us.underlays.Cut()

	// Mapper wanted something specific
	if(under_turf)
		under = under_turf

	if(!under)
		var/turf/T1
		var/turf/T2
		var/turf/T3

		T1 = get_step(src, turn(join_flags,135))	// 45 degrees before opposite
		T2 = get_step(src, turn(join_flags,225))	// 45 degrees beyond opposite
		T3 = get_step(src, turn(join_flags,180))	// Opposite from the diagonal

		if(isfloor(T1) && ((T1.type == T2.type) || (T1.type == T3.type)))
			under = T1
		else if(isfloor(T2) && T2.type == T3.type)
			under = T2
		else if(isfloor(T3) || istype(T3, /turf/space))
			under = T3
		else
			under = baseturf_underneath()

	if(istype(under,/turf/simulated/shuttle))
		interior_corner = 1	// Prevents us from 'landing on grass' and having interior corners update.

	var/mutable_appearance/under_ma

	if(ispath(under))		// It's just a mapper-specified path
		under_ma = new()
		under_ma.icon = initial(under.icon)
		under_ma.icon_state = initial(under.icon_state)
		under_ma.color = initial(under.color)

	else	// It's a real turf
		under_ma = new(under)

	if(under_ma)
		if(ispath(under,/turf/space) || istype(under,/turf/space))	// Space gets weird treatment
			under_ma.icon_state = "white"
			under_ma.plane = SPACE_PLANE
		us.underlays = list(under_ma)

	appearance = us

	spawn update_breaklights()	// So that we update the breaklight overlays only after turfs are connected

	return under

/turf/simulated/shuttle/floor
	name = "floor"
	icon = 'icons/turf/flooring/shuttle.dmi'
	icon_state = "floor_blue"

/turf/simulated/shuttle/floor/red
	icon_state = "floor_red"

/turf/simulated/shuttle/floor/yellow
	icon_state = "floor_yellow"

/turf/simulated/shuttle/floor/darkred
	icon_state = "floor_dred"

/turf/simulated/shuttle/floor/purple
	icon_state = "floor_purple"

/turf/simulated/shuttle/floor/white
	icon_state = "floor_white"

/turf/simulated/shuttle/floor/black
	icon_state = "floor_black"

/turf/simulated/shuttle/floor/glass
	icon_state = "floor_glass"
	takes_underlays = 1

/turf/simulated/shuttle/floor/alien
	icon_state = "alienpod1"
	block_tele = TRUE
	ambient_light = COLOR_LUMINOL
	ambient_light_multiplier = 0.6

/turf/simulated/shuttle/floor/alien/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1, 9)]"

/turf/simulated/shuttle/floor/alienplating
	icon_state = "alienplating"
	block_tele = TRUE

/turf/simulated/shuttle/floor/alienplating/external	// For the outer rim of the UFO, to avoid active edges.
// The actual temperature adjustment is defined if the SC or other future map is compiled.

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/plating/airless
	initial_gas_mix = GAS_STRING_VACUUM

// For 'carrying' otherwise empty turfs or stuff in space turfs with you or having holes in the floor or whatever.
/turf/simulated/shuttle/plating/carry
	name = "carry turf"
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "carry"
	takes_underlays = 1
	blocks_air = 1	// I'd make these unsimulated but it just fucks with so much stuff so many other places.

/turf/simulated/shuttle/plating/carry/Initialize(mapload)
	. = ..()
	icon_state = "carry_ingame"

/turf/simulated/shuttle/plating/airless/carry
	name = "airless carry turf"
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "carry"
	takes_underlays = 1
	blocks_air = 1

/turf/simulated/shuttle/plating/airless/carry/Initialize(mapload)
	. = ..()
	icon_state = "carry_ingame"

/turf/simulated/shuttle/plating/skipjack	// Skipjack plating
	initial_gas_mix = GAS_STRING_STP_NITROGEN

/turf/simulated/shuttle/floor/skipjack	 // Skipjack floors
	name = "skipjack floor"
	icon_state = "floor_dred"
	initial_gas_mix = GAS_STRING_STP_NITROGEN

/turf/simulated/shuttle/floor/voidcraft
	name = "voidcraft tiles"
	icon_state = "void"

/turf/simulated/shuttle/floor/voidcraft/dark
	name = "voidcraft tiles"
	icon_state = "void_dark"

/turf/simulated/shuttle/floor/voidcraft/light
	name = "voidcraft tiles"
	icon_state = "void_light"

/turf/simulated/shuttle/floor/voidcraft/external	// For avoiding active edges.
// The actual temperature adjustment is defined if the SC or other future map is compiled.

/turf/simulated/shuttle/floor/voidcraft/external/dark

/turf/simulated/shuttle/floor/voidcraft/external/light
