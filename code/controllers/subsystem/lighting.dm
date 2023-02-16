SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = LIGHTING_INTERVAL
	priority = FIRE_PRIORITY_LIGHTING
	init_order = INIT_ORDER_LIGHTING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/total_lighting_overlays = 0
	var/total_lighting_sources = 0
	var/total_ambient_turfs = 0
	var/total_lighting_corners = 0

	/// lighting sources  queued for update.
	var/list/light_queue   = list()
	var/lq_idex = 1
	/// lighting corners  queued for update.
	var/list/corner_queue  = list()
	var/cq_idex = 1
	/// lighting overlays queued for update.
	var/list/overlay_queue = list()
	var/oq_idex = 1

	var/tmp/processed_lights = 0
	var/tmp/processed_corners = 0
	var/tmp/processed_overlays = 0

	var/total_ss_updates = 0
	var/total_instant_updates = 0

	var/instant_ctr = 0

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	var/force_queued = TRUE
	/// For admins.
	var/force_override = FALSE
#endif

/datum/controller/subsystem/lighting/stat_entry()
	var/list/out = list(
#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
		"IUR: [total_ss_updates ? round(total_instant_updates/(total_instant_updates+total_ss_updates)*100, 0.1) : "NaN"]% Instant: [force_queued ? "Disabled" : "Allowed"] <br>",
#endif
		"&emsp;T: { L: [total_lighting_sources] C: [total_lighting_corners] O:[total_lighting_overlays] A: [total_ambient_turfs] }<br>",
		"&emsp;P: { L: [light_queue.len - (lq_idex - 1)] C: [corner_queue.len - (cq_idex - 1)] O: [overlay_queue.len - (oq_idex - 1)] }<br>",
		"&emsp;L: { L: [processed_lights] C: [processed_corners] O: [processed_overlays]}<br>"
	)
	return ..() + out.Join()

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES

/hook/roundstart/proc/lighting_init_roundstart()
	SSlighting.handle_roundstart()
	return TRUE

/datum/controller/subsystem/lighting/proc/handle_roundstart()
	force_queued = FALSE
	total_ss_updates = 0
	total_instant_updates = 0

#endif

/// Disable instant updates, relying entirely on the (slower, but less laggy) queued pathway. Use if changing a *lot* of lights.
/datum/controller/subsystem/lighting/proc/pause_instant()
	if (force_override)
		return

	instant_ctr += 1
	if (instant_ctr == 1)
		force_queued = TRUE

/// Resume instant updates.
/datum/controller/subsystem/lighting/proc/resume_instant()
	if (force_override)
		return

	instant_ctr = max(instant_ctr - 1, 0)

	if (!instant_ctr)
		force_queued = FALSE

/datum/controller/subsystem/lighting/Initialize(timeofday)
	var/overlaycount = 0
	var/starttime = REALTIMEOFDAY

	// Generate overlays.
	for (var/zlevel = 1 to world.maxz)
		overlaycount += InitializeZlev(zlevel)

	var/overlay_blurb = "Created [overlaycount] lighting overlays in [(REALTIMEOFDAY - starttime)/10] seconds!"

	starttime = REALTIMEOFDAY
	// Tick once to clear most lights.
	fire(FALSE, TRUE)

	var/time = (REALTIMEOFDAY - starttime) / 10
	var/list/blockquote_data = list(
		SPAN_BOLDANNOUNCE("[overlay_blurb]\n"),
		SPAN_BOLDANNOUNCE("Lighting pre-bake completed within [time] second[time == 1 ? "" : "s"]!<hr>"),
		SPAN_DEBUGINFO("Processed [processed_lights] light sources."),
		SPAN_DEBUGINFO("\nProcessed [processed_corners] light corners."),
		SPAN_DEBUGINFO("\nProcessed [processed_overlays] light overlays."),
	)

	to_chat(
		target = world,
		html   = SPAN_BLOCKQUOTE(JOINTEXT(blockquote_data), "info"),
		type   = MESSAGE_TYPE_DEBUG,
	)
	log_subsystem("lighting", "NOv:[overlaycount] L:[processed_lights] C:[processed_corners] O:[processed_overlays]")

	return ..()

/datum/controller/subsystem/lighting/proc/InitializeZlev(zlev)
	for (var/thing in Z_ALL_TURFS(zlev))
		var/turf/T = thing
		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
			if (T.lighting_overlay)
				log_subsystem(name, "Found unexpected lighting overlay at [T.x],[T.y],[T.z]")
			else
				new /atom/movable/lighting_overlay(T)
				. += 1
			if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
				T.generate_missing_corners()	// Forcibly generate corners.

		CHECK_TICK

// It's safe to pass a list of non-turfs to this list - it'll only check turfs.
/datum/controller/subsystem/lighting/proc/InitializeTurfs(list/targets)
	for (var/turf/T in (targets || world))
		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
			T.lighting_build_overlay()

		// If this isn't here, BYOND will set-background us.
		CHECK_TICK

/datum/controller/subsystem/lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processed_lights = 0
		processed_corners = 0
		processed_overlays = 0

	MC_SPLIT_TICK_INIT(3)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_lights = light_queue
	var/list/curr_corners = corner_queue
	var/list/curr_overlays = overlay_queue

	while (lq_idex <= curr_lights.len)
		var/datum/light_source/L = curr_lights[lq_idex++]

		if (L.needs_update != LIGHTING_NO_UPDATE)
			total_ss_updates += 1
			L.update_corners()

			L.needs_update = LIGHTING_NO_UPDATE

			processed_lights++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (lq_idex > 1)
		curr_lights.Cut(1, lq_idex)
		lq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (cq_idex <= curr_corners.len)
		var/datum/lighting_corner/C = curr_corners[cq_idex++]

		if (C.needs_update)
			C.update_overlays()

			C.needs_update = FALSE

			processed_corners++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (cq_idex > 1)
		curr_corners.Cut(1, cq_idex)
		cq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (oq_idex <= curr_overlays.len)
		var/atom/movable/lighting_overlay/O = curr_overlays[oq_idex++]

		if (!QDELETED(O) && O.needs_update)
			O.update_overlay()
			O.needs_update = FALSE

			processed_overlays++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (oq_idex > 1)
		curr_overlays.Cut(1, oq_idex)
		oq_idex = 1

/datum/controller/subsystem/lighting/Recover()
	total_lighting_corners = SSlighting.total_lighting_corners
	total_lighting_overlays = SSlighting.total_lighting_overlays
	total_lighting_sources = SSlighting.total_lighting_sources

	light_queue = SSlighting.light_queue
	corner_queue = SSlighting.corner_queue
	overlay_queue = SSlighting.overlay_queue

	lq_idex = SSlighting.lq_idex
	cq_idex = SSlighting.cq_idex
	oq_idex = SSlighting.oq_idex

	if (lq_idex > 1)
		light_queue.Cut(1, lq_idex)
		lq_idex = 1

	if (cq_idex > 1)
		corner_queue.Cut(1, cq_idex)
		cq_idex = 1

	if (oq_idex > 1)
		overlay_queue.Cut(1, oq_idex)
		oq_idex = 1
