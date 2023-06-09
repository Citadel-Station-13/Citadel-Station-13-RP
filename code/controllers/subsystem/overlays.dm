SUBSYSTEM_DEF(overlays)
	name = "Overlays"
	wait = 1
	priority = FIRE_PRIORITY_OVERLAYS
	init_order = INIT_ORDER_OVERLAY
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/processing = list()
	var/list/stats = list()

	var/idex = 1
	var/list/overlay_icon_state_caches = list()
	var/list/overlay_icon_cache = list()
	var/overlays_initialized = FALSE

	// If the overlay set currently being considered contains a manglable overlay.
	// This is only safe because SSoverlays can only ever consider one overlay list at a time with no interior sleeps. Professional on closed course, do not attempt.
	var/context_needs_automangle

/datum/controller/subsystem/overlays/stat_entry()
	return ..() + " Ov:[processing.len - (idex - 1)]"

/datum/controller/subsystem/overlays/Initialize()
	overlays_initialized = TRUE
	Flush()
	..()

/datum/controller/subsystem/overlays/Shutdown()
	text2file(render_stats(stats), "[GLOB.log_directory]/overlay.log")


/datum/controller/subsystem/overlays/Recover()
	overlay_icon_state_caches = SSoverlays.overlay_icon_state_caches
	overlay_icon_cache = SSoverlays.overlay_icon_cache
	processing = SSoverlays.processing

/datum/controller/subsystem/overlays/fire(resumed = FALSE, mc_check = TRUE)
	var/list/processing = src.processing
	while(idex <= processing.len)
		var/atom/thing = processing[idex]
		idex += 1

		if(!QDELETED(thing) && (thing.atom_flags & ATOM_OVERLAY_QUEUED))	// Don't double-process if something already forced a compile.
			STAT_START_STOPWATCH
			thing.compile_overlays()
			STAT_STOP_STOPWATCH
			STAT_LOG_ENTRY(stats, thing.type)
		if(mc_check)
			if(MC_TICK_CHECK)
				break
		else
			CHECK_TICK

	if (idex > 1)
		processing.Cut(1, idex)
		idex = 1

/**
 * Converts an overlay list into text for debug printing
 * Of note: overlays aren't actually mutable appearances, they're just appearances
 * Don't have access to that type tho, so this is the best you're gonna get
 */
/proc/overlays2text(list/overlays)
	var/list/unique_overlays = list()
	// As anything because we're basically doing type coerrsion, rather then actually filtering for mutable apperances
	for(var/mutable_appearance/overlay as anything in overlays)
		var/key = "[overlay.icon]-[overlay.icon_state]-[overlay.dir]"
		unique_overlays[key] += 1
	var/list/output_text = list()
	for(var/key in unique_overlays)
		output_text += "([key]) = [unique_overlays[key]]"
	return output_text.Join("\n")

/datum/controller/subsystem/overlays/proc/Flush()
	if(processing.len)
		log_subsystem("overlays", "Flushing [processing.len] overlays.")
		fire(mc_check = FALSE)

/atom/proc/compile_overlays()
	var/list/oo = our_overlays
	var/ool = LAZYLEN(oo)
	var/list/po = priority_overlays
	var/pol = LAZYLEN(po)

	if (pol + ool > MAX_ATOM_OVERLAYS)
		//Break it real GOOD
		var/text_lays = overlays2text(overlays)
		stack_trace("Too many overlays - N [ool] / P [pol], refusing to update and cutting.\
			\n What follows is a printout of all existing overlays at the time of the overflow \n[text_lays]")
		LAZYCLEARLIST(our_overlays)
		LAZYCLEARLIST(priority_overlays)

		//Let them know they fucked up
		add_overlay(image('icons/testing/greyscale_error.dmi'))
		atom_flags &= ~ATOM_OVERLAY_QUEUED
		return

	// The two lists are nulled out in here instead of using LAZY* so the cut-add pattern a lot of code does doesn't cause alloc churn.
	if(pol && ool)
		overlays = oo + po
	else if(ool)
		overlays = oo
		priority_overlays = null
	else if(pol)
		overlays = po
		our_overlays = null
	else
		overlays.Cut()
		priority_overlays = null
		our_overlays = null

	if (alternate_appearances)
		for(var/I in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[I]
			if(AA.transfer_overlays)
				AA.copy_overlays(src, TRUE)

	atom_flags &= ~ATOM_OVERLAY_QUEUED

/atom/movable/compile_overlays()
	..()
	UPDATE_OO_IF_PRESENT

/turf/compile_overlays()
	..()
	if (above)
		update_above()

/*
	You might be wondering, 'why are all these x2appearance procs using images? aren't mutable_appearances faster?'.
	The answer is that using MAs here causes daemon to immediately hard crash when SSoverlays runs.
	It's fast enough with images.

	Last version checked: 514.1584
*/

/proc/iconstate2appearance(icon, iconstate)
	var/static/image/stringbro = new()
	var/list/icon_states_cache = SSoverlays.overlay_icon_state_caches
	var/list/cached_icon = icon_states_cache[icon]
	if (cached_icon)
		var/cached_appearance = cached_icon["[iconstate]"]
		if (cached_appearance)
			return cached_appearance
	stringbro.icon = icon
	stringbro.icon_state = iconstate
	if (!cached_icon) //not using the macro to save an associated lookup
		cached_icon = list()
		icon_states_cache[icon] = cached_icon
	var/cached_appearance = stringbro.appearance
	cached_icon["[iconstate]"] = cached_appearance
	return cached_appearance

/proc/icon2appearance(icon)
	var/static/image/iconbro = new()
	var/list/icon_cache = SSoverlays.overlay_icon_cache
	. = icon_cache[icon]
	if (!.)
		iconbro.icon = icon
		. = iconbro.appearance
		icon_cache[icon] = .

#define APPEARANCEIFY(origin, target) \
	if (istext(origin)) { \
		target = iconstate2appearance(icon, origin); \
	} \
	else if (isicon(origin)) { \
		target = icon2appearance(origin); \
	} \
	else { \
		appearance_bro.appearance = origin; \
		if (!ispath(origin)) { \
			appearance_bro.dir = origin.dir; \
		} \
		target = appearance_bro.appearance; \
	}

// If the overlay has a planeset (e.g., emissive), mark for ZM mangle. This won't catch overlays on overlays, but the flag can just manually be set in that case.
#define ZM_AUTOMANGLE(target) if ((target):plane != FLOAT_PLANE) { SSoverlays.context_needs_automangle = TRUE; }

/atom/proc/build_appearance_list(atom/new_overlays)
	var/static/image/appearance_bro = new
	if (islist(new_overlays))
		// A lot of code seems to assume that it's safe to pass long-lived lists to SSoverlays.
		// That was true with the old overlays SS, but is not true of this one.
		// So we're copying the list. Fix all the callsites if you want to avoid this copy.
		new_overlays = new_overlays:Copy()
		listclearnulls(new_overlays)
		for (var/i in 1 to length(new_overlays))
			var/image/cached_overlay = new_overlays[i]
			APPEARANCEIFY(cached_overlay, new_overlays[i])
		return new_overlays
	else
		APPEARANCEIFY(new_overlays, .)

// The same as the above, but with ZM_AUTOMANGLE.
/atom/movable/build_appearance_list(atom/new_overlays)
	// If the atom has explicitly opted into mangling, don't bother scanning for automangle.
	if (zmm_flags & ZMM_MANGLE_PLANES)
		return ..()

	var/static/image/appearance_bro = new
	if (islist(new_overlays))
		new_overlays = new_overlays:Copy()
		listclearnulls(new_overlays)
		for (var/i in 1 to length(new_overlays))
			var/image/cached_overlay = new_overlays[i]
			APPEARANCEIFY(cached_overlay, new_overlays[i])
			ZM_AUTOMANGLE(new_overlays[i])
		return new_overlays
	else
		APPEARANCEIFY(new_overlays, .)
		ZM_AUTOMANGLE(.)

#undef APPEARANCEIFY
#define NOT_QUEUED_ALREADY (!(atom_flags & ATOM_OVERLAY_QUEUED))
#define QUEUE_FOR_COMPILE atom_flags |= ATOM_OVERLAY_QUEUED; SSoverlays.processing += src;

/// Remove all overlays from this atom.
/atom/proc/cut_overlays(priority = FALSE)
	var/list/cached_overlays = our_overlays
	var/list/cached_priority = priority_overlays

	var/need_compile = FALSE

	if(LAZYLEN(cached_overlays)) //don't queue empty lists, don't cut priority overlays
		cached_overlays.Cut()  //clear regular overlays
		need_compile = TRUE

	if(priority && LAZYLEN(cached_priority))
		cached_priority.Cut()
		need_compile = TRUE

	if(NOT_QUEUED_ALREADY && need_compile)
		QUEUE_FOR_COMPILE

// This one gets to be done the sane way because it shouldn't be as hot as the others.
/atom/movable/cut_overlays(priority = FALSE)
	..()
	zmm_flags &= priority ? ~ZMM_AUTOMANGLE_PRI : ~ZMM_AUTOMANGLE_NRML

/// Remove one or more overlays from this atom.
/atom/proc/cut_overlay(list/overlays, priority)
	if(!overlays)
		return

	SSoverlays.context_needs_automangle = FALSE
	overlays = build_appearance_list(overlays)

	var/list/cached_overlays = our_overlays	//sanic
	var/list/cached_priority = priority_overlays
	var/init_o_len = LAZYLEN(cached_overlays)
	var/init_p_len = LAZYLEN(cached_priority)  //starter pokemon


	if(priority)
		LAZYREMOVE(cached_priority, overlays)
	else
		LAZYREMOVE(cached_overlays, overlays)

	if(NOT_QUEUED_ALREADY && ((init_o_len != LAZYLEN(cached_priority)) || (init_p_len != LAZYLEN(cached_overlays))))
		QUEUE_FOR_COMPILE

// This one also gets to be done sanely because it shouldn't be too hot.
/atom/movable/cut_overlay(list/overlays, priority)
	..()
	// If we removed an automangle-eligible overlay and have automangle enabled, reevaluate automangling.
	if (!SSoverlays.context_needs_automangle || !(zmm_flags & ZMM_AUTOMANGLE))
		return

	var/list/cached_overlays = our_overlays
	var/list/cached_priority = priority_overlays

	// If we cut some non-priority overlays but some are still left, we need to scan for AUTOMANGLE_STD.
	if (!priority && LAZYLEN(cached_overlays))
		// need to scan overlays
		var/found = FALSE
		for (var/i in 1 to length(cached_overlays))
			var/image/I = cached_overlays[i]
			if (I.plane != FLOAT_PLANE)
				found = TRUE
				break
		if (!found)
			zmm_flags &= ~ZMM_AUTOMANGLE_NRML

	// Likewise, but now for priority and AUTOMANGLE_PRI.
	else if (priority && LAZYLEN(cached_priority))
		// need to scan priority overlays
		var/found = FALSE
		for (var/i in 1 to length(cached_priority))
			var/image/I = cached_priority[i]
			if (I.plane != FLOAT_PLANE)
				found = TRUE
				break
		if (!found)
			zmm_flags &= ~ZMM_AUTOMANGLE_PRI

	// None left, just unset the bit.
	else
		zmm_flags &= priority ? ~ZMM_AUTOMANGLE_PRI : ~ZMM_AUTOMANGLE_NRML

/// Add one or more overlays to this atom.
/atom/proc/add_overlay(list/overlays, priority = FALSE)
	if(!overlays)
		return

	// the things I do for performance
	var/is_movable = istype(src, /atom/movable)

	SSoverlays.context_needs_automangle = FALSE
	overlays = build_appearance_list(overlays)
	if (SSoverlays.context_needs_automangle && is_movable)
		// This is a movable flag.
		src:zmm_flags |= priority ? ZMM_AUTOMANGLE_PRI : ZMM_AUTOMANGLE_NRML

	if (!overlays || (islist(overlays) && !overlays.len))
		// No point trying to compile if we don't have any overlays.
		return

	if(priority)
		LAZYADD(priority_overlays, overlays)
	else
		LAZYADD(our_overlays, overlays)

	if(NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/// Overwrite overlays with a given set of overlays. Like with other overlay procs, single overlays are also valid.
/atom/proc/set_overlays(list/overlays, priority = FALSE)
	if (!overlays)
		return

	var/is_movable = istype(src, /atom/movable)

	SSoverlays.context_needs_automangle = FALSE
	overlays = build_appearance_list(overlays)

	if (priority)
		if (!SSoverlays.context_needs_automangle && is_movable)
			src:zmm_flags &= ~ZMM_AUTOMANGLE_PRI

		LAZYCLEARLIST(priority_overlays)
		if (overlays)
			LAZYADD(priority_overlays, overlays)
	else
		if (!SSoverlays.context_needs_automangle && is_movable)
			src:zmm_flags &= ~ZMM_AUTOMANGLE_NRML

		LAZYCLEARLIST(our_overlays)
		if (overlays)
			LAZYADD(our_overlays, overlays)

	if (NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/// Copy overlays from another atom.
/atom/proc/copy_overlays(atom/other, cut_old = FALSE)
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if (istype(src, /atom/movable))
			for (var/i in 1 to length(cached_other))
				var/image/I = cached_other[i]
				if (I.plane != FLOAT_PLANE)
					src:zmm_flags |= ZMM_AUTOMANGLE_NRML
					break

		if(cut_old)
			our_overlays = cached_other.Copy()
		else
			LAZYINITLIST(our_overlays)	// We might not have overlays yet.
			our_overlays |= cached_other
		if(NOT_QUEUED_ALREADY)
			QUEUE_FOR_COMPILE
	else if(cut_old)
		cut_overlays()

#undef NOT_QUEUED_ALREADY
#undef QUEUE_FOR_COMPILE

//TODO: Better solution for these?
/image/proc/add_overlay(x)
	overlays += x

/image/proc/cut_overlay(x)
	overlays -= x

/image/proc/cut_overlays(x)
	overlays.Cut()

/image/proc/copy_overlays(atom/other, cut_old)
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	if(other.atom_flags & ATOM_OVERLAY_QUEUED)
		other.compile_overlays()
	var/list/cached_other = other.overlays.Copy()
	if(cut_old || !overlays.len)
		overlays = cached_other
	else
		overlays |= cached_other

/atom
	var/tmp/list/our_overlays	//! our local copy of (non-priority) overlays without byond magic. Use procs in SSoverlays to manipulate
	var/tmp/list/priority_overlays	//! overlays that should remain on top and not normally removed when using cut_overlay functions, like c4.
