GLOBAL_LIST_EMPTY(holopad_lookup)

#define HOLO_NORMAL_COLOR color_matrix_from_rgb("#ccccff")
#define HOLO_VORE_COLOR color_matrix_from_rgb("#d97de0")
#define HOLO_NORMAL_ALPHA 140
#define HOLO_VORE_ALPHA 210

/proc/__rebuild_holopad_connectivity()
	for(var/id in GLOB.holopad_lookup)
		var/obj/machinery/holopad/pad = GLOB.holopad_lookup[id]
		pad.push_ui_connectivity_data()
	GLOB.holopad_connectivity_rebuild_queued = FALSE

GLOBAL_VAR_INIT(holopad_connectivity_rebuild_queued, FALSE)

/obj/item/circuitboard/holopad
	name = T_BOARD("holopad")
	build_path = /obj/machinery/holopad
	board_type = new /datum/frame/frame_types/holopad
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/machinery/holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon = 'icons/machinery/holopad.dmi'
	icon_state = "holopad"
	base_icon_state = "holopad"
	anchored = TRUE
	atom_flags = ATOM_HEAR
	show_messages = TRUE
	circuit = /obj/item/circuitboard/holopad
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	light_range = 1.5
	light_power = 0

	//? balancing
	/// base power used to project at all
	var/power_base_usage = 50
	/// power used for local call
	var/power_for_local_call = 50
	/// power used for ship to ship call
	var/power_for_sector_call = 2000
	/// power used per hologram
	var/power_per_hologram = 150
	/// light power when on
	var/active_light_power = 1.5
	/// light power when off
	var/inactive_light_power = 0

	//? ai's
	/// last world.time we requested AI
	var/last_ai_request = 0
	/// cooldown between AI requests
	var/ai_request_cooldown = 60 SECONDS
	/// allow AI requesting?
	var/ai_request_allowed = TRUE
	/// AIs currently using us
	var/list/mob/living/silicon/ai/ais_projecting
	/// AI presence enabled
	var/allow_ai = TRUE

	//? reach
	// todo: allow a list of areas (via signal to detect exit)
	/// anchor to our area for valid ranges instead of a literal range
	var/area_based = FALSE
	/// allow going to all areas under a master area instead of a subarea
	var/subarea_only = TRUE
	/// for non area based, tile range
	var/tile_range = 5

	//? holocalls
	/// unique id string: we have this for ui purposes
	var/holopad_uid
	/// next uid number
	var/static/holopad_uid_next
	/// pad name override, otherwise use location + area name
	var/holopad_name
	/// holocall capable
	var/call_receiver = TRUE
	/// visibility
	var/call_visibility = TRUE
	/// visibility toggleable
	var/call_toggleable = TRUE
	/// anonymous sector calls?
	var/call_anonymous_sector = FALSE
	/// anonymous sector calls toggleable
	var/call_anonymous_sector_toggle = TRUE
	/// video enabled
	var/video_enabled = TRUE
	/// video toggleable?
	var/video_toggleable = TRUE
	/// ringer enabled
	var/ringer_enabled = TRUE
	/// ringer toggleable
	var/ringer_toggleable = TRUE
	/// cross overmap capable
	var/long_range = FALSE
	/// ONLY allow communications to other long-range holopads
	var/sector_only = FALSE
	/// auto accept incoming call?
	var/call_auto_pickup = FALSE
	/// can toggle call auto pickup?
	var/call_auto_toggle = TRUE
	/// active holocall - outgoing
	var/datum/holocall/outgoing_call
	/// active holocalls - inbound
	var/list/datum/holocall/incoming_calls
	/// inbound holocalls - still ringing
	var/list/datum/holocall/ringing_calls
	/// lazy assoc list to track last "loud" ring of holopadid = time
	var/list/holocall_anti_spam
	/// last radio'd ring
	var/holocall_last_radio

	//? appearance
	/// current emissive
	var/active_emissive_overlay

	//? holograms
	/// an anchored hologram we use to signify that we are active if we don't need to project
	/// any sort of avatar
	var/obj/effect/overlay/hologram/activity_hologram
	/// activity hologram style
	var/activity_hologram_style = /datum/hologram/general/excalamation_point
	/// all holograms bound to us
	var/list/holograms

/obj/machinery/holopad/Initialize(mapload)
	. = ..()
	holopad_uid = "[num2text(++holopad_uid_next, 16)]"
	holograms = list()
	GLOB.holopad_lookup[holopad_uid] = src
	var/area/our_area = isturf(loc)? loc.loc : null
	if(our_area)
		LAZYADD(our_area.holopads, src)

/obj/machinery/holopad/Destroy()
	disconnect_all_calls()
	kill_all_ai_holograms()
	destroy_holograms()
	GLOB.holopad_lookup -= holopad_uid
	return ..()

/obj/machinery/holopad/get_perspective()
	ensure_self_perspective() // no lazy/temp-perspectives.
	return ..()

/obj/machinery/holopad/on_changed_z_level(old_z, new_z)
	. = ..()
	if(call_visibility)
		queue_global_connectivity_update()

/obj/machinery/holopad/proc/queue_global_connectivity_update()
	if(GLOB.holopad_connectivity_rebuild_queued)
		return
	GLOB.holopad_connectivity_rebuild_queued = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(__rebuild_holopad_connectivity)), 5 SECONDS)

//? movement hooks

/obj/machinery/holopad/Moved(atom/old_loc, direction, forced)
	. = ..()
	var/area/old_area = isturf(old_loc)? old_loc.loc : null
	var/area/new_area = isturf(loc)? loc.loc : null
	if(old_area)
		LAZYREMOVE(old_area.holopads, src)
	if(new_area)
		LAZYADD(new_area.holopads, src)
	activity_hologram?.forceMove(loc)

//? Holo reach

/**
 * checks if a turf is in range to project to
 */
/obj/machinery/holopad/proc/turf_in_range(turf/T)
	if(area_based)
		return T.loc == get_area(src)
	return get_dist(T, src) <= tile_range

/**
 * checks for holopad handoff
 */
/obj/machinery/holopad/proc/check_handoff(turf/T)
	// area check
	var/area/A = T.loc
	for(var/obj/machinery/holopad/pad as anything in A.holopads)
		if(pad.turf_in_range(T))
			return pad
	// global check
	for(var/id as anything in GLOB.holopad_lookup)
		var/obj/machinery/holopad/pad = GLOB.holopad_lookup[id]
		if(pad.turf_in_range(T))
			return pad

//? Holocall Connectivity

/**
 * returns if we can reach another holopad
 */
/obj/machinery/holopad/proc/holocall_connectivity(obj/machinery/holopad/other)
	var/obj/effect/overmap/visitable/our_sector = get_overmap_sector(get_z(src))
	var/obj/effect/overmap/visitable/their_sector = get_overmap_sector(get_z(other))
	if(!our_sector || !their_sector)
		return !(sector_only || other.sector_only) && (get_z(src) == get_z(other))
	if(our_sector != their_sector)
		return long_range && other.long_range
	return !(sector_only || other.sector_only)

/**
 * returns reachable holopads
 */
/obj/machinery/holopad/proc/holocall_query()
	. = list()
	var/obj/effect/overmap/visitable/our_sector = get_overmap_sector(get_z(src))
	for(var/id in GLOB.holopad_lookup)
		var/obj/machinery/holopad/pad = GLOB.holopad_lookup[id]
		if(!pad.operable() || !pad.call_visibility)
			continue
		var/obj/effect/overmap/visitable/their_sector = get_overmap_sector(get_z(pad))
		if(!our_sector || !their_sector)
			if((sector_only || pad.sector_only) || (get_z(src) != get_z(pad)))
				continue
			. += pad
			continue
		if(their_sector == our_sector)
			if(!(sector_only || pad.sector_only))
				. += pad
			continue
		if(long_range && pad.long_range)
			. += pad
	. -= src

/**
 * our holopad name
 *
 * todo: this proc is shit and shouldn't exist because we keep requerying this mid-call, holocalls need eventual redesigning
 */
/obj/machinery/holopad/proc/holocall_name(obj/machinery/holopad/in_respects_to)
	if(holopad_name)
		return holopad_name
	var/obj/effect/overmap/visitable/sector = get_overmap_sector(get_z(src))
	if(in_respects_to && call_anonymous_sector)
		var/obj/effect/overmap/visitable/other = get_overmap_sector(in_respects_to)
		if(sector != other)
			return "Anonymous"
	return "[sector? "[sector.scanner_name || sector.name]: " : ""][get_area(src)?:name] - [holopad_uid]"

/**
 * our holocall category
 */
/obj/machinery/holopad/proc/holocall_category()
	return "[get_area(src)?:name]"

//? Holocall Helpers

/**
 * generate holocall target ui
 */
/obj/machinery/holopad/proc/ui_connectivity_data()
	var/list/built = list()
	for(var/obj/machinery/holopad/pad as anything in holocall_query())
		var/obj/effect/overmap/visitable/sector = get_overmap_sector(get_z(pad))
		var/sector_name = sector?.scanner_name || sector?.name
		built[++built.len] = list(
			"id" = pad.holopad_uid,
			"name" = pad.holocall_name(),
			"category" = pad.holocall_category(),
			"sector" = sector_name,
		)
	return built

/**
 * update holocall target ui
 */
/obj/machinery/holopad/proc/push_ui_connectivity_data()
	if(!has_open_ui())
		return
	push_ui_data(data = list("connectivity" = ui_connectivity_data()))

//? Holocalls

/**
 * checks if we're in a call; if so, return datum
 * call is not necessarily connected
 */
/obj/machinery/holopad/proc/is_calling()
	return is_call_source() || is_call_destination()

/**
 * checks if we're in a connected outgoing call
 */
/obj/machinery/holopad/proc/outgoing_call_connected()
	return outgoing_call?.connected

/**
 * checks for an outgoing call, whether or not it's connected
 */
/obj/machinery/holopad/proc/outgoing_call_exists()
	return !!outgoing_call

/**
 * checks if we're in a connected incoming call
 */
/obj/machinery/holopad/proc/incoming_calls_connected()
	return length(incoming_calls)

/**
 * checks if we have incoming calls, whether or not connected
 */
/obj/machinery/holopad/proc/incoming_calls_exist()
	return length(incoming_calls) || length(ringing_calls)

/**
 * is call source
 */
/obj/machinery/holopad/proc/is_call_source()
	return !!outgoing_call

/**
 * is call destination
 */
/obj/machinery/holopad/proc/is_call_destination()
	return length(incoming_calls)

/**
 * checks if we should automatically answer a holocall
 */
/obj/machinery/holopad/proc/should_auto_pickup(datum/holocall/inbound)
	return call_auto_pickup

/**
 * hang up all calls
 */
/obj/machinery/holopad/proc/disconnect_all_calls()
	for(var/datum/holocall/disconnecting as anything in incoming_calls)
		disconnect_call(disconnecting)
	for(var/datum/holocall/disconnecting as anything in ringing_calls)
		disconnect_call(disconnecting)
	if(outgoing_call)
		disconnect_call(outgoing_call)

/**
 * hang up a call, or terminate a ringing call
 *
 * this assumes you checked that the call is actually valid.
 */
/obj/machinery/holopad/proc/disconnect_call(datum/holocall/disconnecting)
	disconnecting.disconnect(src)

/**
 * connect a ringing call
 *
 * this assumes you checked that the call is actually valid.
 */
/obj/machinery/holopad/proc/connect_call(datum/holocall/connecting)
	connecting.connect()

/**
 * makes a new call / rings a holopad
 */
/obj/machinery/holopad/proc/make_call(obj/machinery/holopad/other)
	if(other == src)
		return FALSE
	if(length(incoming_calls))
		return FALSE // already being called / connected
	if(!isnull(outgoing_call))
		return FALSE // already calling someone
	for(var/datum/holocall/holocall in (other.ringing_calls | other.incoming_calls))
		if(holocall.source == src)
			return FALSE
	var/datum/holocall/holocall = new(src, other)
	holocall.ring()

/**
 * get ring'd by a call
 */
/obj/machinery/holopad/proc/ring(datum/holocall/incoming)
	update_icon()
	if(LAZYACCESS(holocall_anti_spam, incoming.source.holopad_uid) > world.time)
		return
	LAZYSET(holocall_anti_spam, incoming.source.holopad_uid, world.time + 30 SECONDS)
	playsound(src, 'sound/machines/beep.ogg', 75)
	atom_say("Incoming holocall from [incoming.caller_id_source()]")
	if(!incoming.cross_sector)
		return // don't need the radio part
	if(world.time < holocall_last_radio + 30 SECONDS)
		return
	holocall_last_radio = world.time
	GLOB.global_announcer.autosay("Incoming call from [incoming.caller_id_source()] at [get_area(src)].", name, zlevels = GLOB.using_map.get_map_levels(get_z(src)))

/**
 * get hung up by a call
 */
/obj/machinery/holopad/proc/hung_up(datum/holocall/disconnecting, we_hung_up)
	SSdpc.queue_invoke(src, TYPE_PROC_REF(/atom, update_icon))

//? UI

/**
 * CRITICAL CODE:
 * Assembles call data.
 */
/obj/machinery/holopad/proc/ui_call_data()
	. = list()
	// it's very important wet set the values properly!
	if(outgoing_call_exists())
		// SOURCE MODE
		var/list/connected = list()
		if(outgoing_call.connected)
			for(var/datum/holocall/holocall as anything in outgoing_call.destination.incoming_calls)
				connected[++connected.len] = holocall.ui_caller_id_source()
		.["calling"] = "source"
		.["calldata"] = list(
			"target" = outgoing_call.destination.holopad_uid,
			"connected" = connected,
			"ringing" = !outgoing_call.connected,
			"remoting" = !!outgoing_call.remoting,
			"remotingAllowed" = outgoing_call.destination.video_enabled,
			"destination" = outgoing_call.ui_caller_id_destination()
		)
	else if(incoming_calls_connected())
		// DESITNATION MODE
		var/list/projecting = list()
		var/list/callers = list()
		for(var/datum/holocall/holocall as anything in incoming_calls)
			callers[++callers.len] = holocall.ui_caller_id_source()
			if(holocall.remoting)
				projecting += holocall.source.holopad_uid
		.["calling"] = "destination"
		.["calldata"] = list(
			"callers" = callers,
			"projecting" = projecting,
		)
	else
		.["calling"] = "none"
		.["calldata"] = null

/obj/machinery/holopad/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holopad")
		ui.open()

/obj/machinery/holopad/ui_static_data(mob/user)
	. = ..()
	.["connectivity"] = ui_connectivity_data()
	.["isAI"] = isAI(user)
	.["aiEnabled"] = allow_ai
	.["holopadName"] = holocall_name()
	.["aiRequestAllowed"] = ai_request_allowed
	.["canCall"] = call_receiver
	.["sectorAnonymousToggle"] = call_anonymous_sector_toggle
	.["toggleVisibility"] = call_toggleable
	.["sectorCall"] = long_range
	.["videoToggle"] = video_toggleable
	.["ringerToggle"] = ringer_toggleable
	.["autoToggle"] = call_auto_toggle

/obj/machinery/holopad/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["isAIProjecting"] = isAI(user) && is_ai_projecting(user)
	.["aiRequested"] = !request_ai_cooldown()
	.["callVisibility"] = call_visibility
	.["sectorAnonymous"] = call_anonymous_sector
	.["videoEnabled"] = video_enabled
	.["ringerEnabled"] = ringer_enabled
	.["autoPickup"] = call_auto_pickup
	. |= ui_call_data()
	var/list/ringing = list()
	for(var/datum/holocall/holocall as anything in ringing_calls)
		ringing[++ringing.len] = holocall.ui_caller_id_source()
	.["ringing"] = ringing

/obj/machinery/holopad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		// user requesting ai
		if("ai_request")
			if(!request_ai_cooldown())
				return TRUE
			request_ai()
			return TRUE
		// ai requesting project
		if("ai_project")
			/// do they want to start or end
			var/mode = text2num(params["mode"])
			var/mob/living/silicon/ai/the_ai = usr
			if(!istype(the_ai))
				return TRUE
			if(mode && !is_ai_projecting(usr))
				the_ai.initiate_holopad_connection(src)
			else if(!mode && is_ai_projecting(usr))
				the_ai.terminate_holopad_connection()
			return TRUE
		// user requesting to hang up a call, or all calls
		if("disconnect")
			// id, null for all
			var/id = params["id"]
			if(isnull(id))
				disconnect_all_calls()
				return TRUE
			var/obj/machinery/holopad/pad = GLOB.holopad_lookup[id]
			if(outgoing_call?.destination == pad)
				disconnect_call(outgoing_call)
				return TRUE
			for(var/datum/holocall/disconnecting as anything in incoming_calls)
				if(disconnecting.destination != pad)
					continue
				disconnect_call(disconnecting)
				return TRUE
			for(var/datum/holocall/disconnecting as anything in ringing_calls)
				if(disconnecting.destination != pad)
					continue
				disconnect_call(disconnecting)
				return TRUE
			return TRUE
		// user requesting to call
		if("call")
			var/id = params["id"]
			var/obj/machinery/holopad/pad = GLOB.holopad_lookup[id]
			make_call(pad)
			return TRUE
		// user requesting to connect an incoming/ringing call
		if("connect")
			var/id = params["id"]
			var/obj/machinery/holopad/pad = GLOB.holopad_lookup[id]
			for(var/datum/holocall/connecting as anything in ringing_calls)
				if(connecting.source != pad)
					continue
				connect_call(connecting)
				return TRUE
			return TRUE
		// user toggling holocall ringer
		if("toggle_ringer")
			if(!ringer_toggleable)
				return TRUE
			ringer_enabled = !ringer_enabled
			return TRUE
		// user toggling sector anonymous mode
		if("toggle_anonymous_sector")
			if(!call_anonymous_sector_toggle)
				return TRUE
			call_anonymous_sector = !call_anonymous_sector
			return TRUE
		// user toggling holocall visibility
		if("toggle_visibility")
			if(!call_toggleable)
				return TRUE
			call_visibility = !call_visibility
			queue_global_connectivity_update()
			return TRUE
		// user toggling video being allowed
		if("toggle_video")
			if(!video_toggleable)
				return TRUE
			video_enabled = !video_enabled
			return TRUE
		// user toggling auto pickup
		if("toggle_auto")
			if(!call_auto_toggle)
				return TRUE
			call_auto_pickup = !call_auto_pickup
			return TRUE
		// user requesting to use remote presence
		if("start_remote")
			if(isnull(outgoing_call))
				return TRUE
			if(!isAI(usr) && usr.loc != loc)
				to_chat(usr, SPAN_WARNING("You have to be standing on [src] to use remote telepresence!"))
				return TRUE
			outgoing_call.initiate_remote_presence(usr)
			return TRUE
		// user requesting to stop remote presence
		if("stop_remote")
			if(isnull(outgoing_call))
				return TRUE
			outgoing_call.cleanup_remote_presence()
			return TRUE

/obj/machinery/holopad/ui_close(mob/user)
	. = ..()
	// if they were remoting, kick 'em - they do get buttons on top left but
	// we want to enforce interface being open.
	if(outgoing_call?.remoting == user)
		outgoing_call.cleanup_remote_presence()

//? active & icon updates

/**
 * returns if we're projecting
 */
/obj/machinery/holopad/proc/is_active()
	return length(ais_projecting) || length(ringing_calls) || length(incoming_calls) || outgoing_call

/obj/machinery/holopad/update_icon()
	. = ..()
	var/active = is_active()
	icon_state = "[base_icon_state][active? "_active" : ""]"
	// update emissive-ness
	if(active && !active_emissive_overlay)
		active_emissive_overlay = cheap_become_emissive()
	else if(!active && active_emissive_overlay)
		cut_overlay(active_emissive_overlay)
		active_emissive_overlay = null
	set_light(l_power = active? active_light_power : inactive_light_power)
	update_activity_hologram(active)

/**
 * makes sure we have an activity hologram if we need one
 *
 * @params
 * * state - are we on?
 */
/obj/machinery/holopad/proc/update_activity_hologram(state)
	var/needed = state && !length(ais_projecting) && !length(incoming_calls) && !outgoing_call
	if(needed && !activity_hologram)
		activity_hologram = new(loc, activity_hologram_style, src)
		activity_hologram.pixel_y = 24
		activity_hologram.set_light(2)
		animate(activity_hologram, time = 5, loop = -1, flags = ANIMATION_RELATIVE, pixel_y = 2)
		animate(time = 5, flags = ANIMATION_RELATIVE, pixel_y = -2)
	else if(!needed && activity_hologram)
		QDEL_NULL(activity_hologram)

//? Ticking

/obj/machinery/holopad/process(delta_time)
	if(!operable())
		kill_all_ai_holograms()
		disconnect_all_calls()
		return

	outgoing_call?.validate()
	for(var/obj/effect/overlay/hologram/hologram as anything in holograms)
		use_power_oneoff(power_per_hologram)
		hologram.check_location()

/obj/machinery/holopad/proc/check_hologram(obj/effect/overlay/hologram/holopad/holo)
	if(!isturf(holo.loc) || !turf_in_range(holo.loc))
		return FALSE
	return TRUE

//? AI holograms

/**
 * requests AI presence
 */
/obj/machinery/holopad/proc/request_ai(mob/user)
	last_ai_request = world.time
	var/area/area = get_area(src)
	for(var/mob/living/silicon/ai/AI in living_mob_list)
		if(!AI.client)
			continue
		to_chat(AI, SPAN_INFO("Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>."))

/**
 * is request ai available
 */
/obj/machinery/holopad/proc/request_ai_cooldown()
	return !isnull(last_ai_request) && (last_ai_request + ai_request_cooldown < world.time)

/**
 * starts AI presence
 */
/obj/machinery/holopad/proc/initiate_ai_hologram(mob/living/silicon/ai/the_ai)
	. = FALSE
	if(the_ai.holopad)
		CRASH("already had holopad")
	//? legacy-ish
	if(the_ai.hologram_follow)
		the_ai.eyeobj.setLoc(get_turf(src))
	//? end
	the_ai.holopad = src
	the_ai.hologram = create_hologram(the_ai.hologram_appearance(), /obj/effect/overlay/hologram/holopad/ai)
	the_ai.hologram.owner = the_ai
	LAZYADD(ais_projecting, the_ai)
	update_icon()
	visible_message("A holographic image of [the_ai] flicks to life right before your eyes!")
	return TRUE

/**
 * stops all AI presence
 */
/obj/machinery/holopad/proc/kill_all_ai_holograms()
	for(var/mob/living/silicon/ai/the_ai as anything in ais_projecting)
		kill_ai_hologram(the_ai)

/**
 * stops AI presence
 */
/obj/machinery/holopad/proc/kill_ai_hologram(mob/living/silicon/ai/the_ai)
	. = FALSE
	if(the_ai.holopad != src)
		STACK_TRACE("wrong holopad")
	var/obj/effect/overlay/hologram/holo = the_ai.hologram
	if(!QDELETED(holo))
		qdel(holo)
	the_ai.holopad = null
	LAZYREMOVE(ais_projecting, the_ai)
	update_icon()
	return TRUE

/**
 * is an AI projecting via us?
 *
 * @params
 * * the_ai - (optional) specific ai; if not specified, then if any.
 */
/obj/machinery/holopad/proc/is_ai_projecting(mob/living/silicon/ai/the_ai)
	return the_ai? (the_ai in ais_projecting) : length(ais_projecting)

//? Legacy - Attack Handling
/obj/machinery/holopad/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	. = ..()
	if(.)
		return
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		attack_hand(user)

//? Say / Emote

/obj/machinery/holopad/see_emote(mob/living/M, text)
	. = ..()
	relay_intercepted_emote(M, M.name, say_emphasis(text))

/obj/machinery/holopad/show_message(msg, type, alt, alt_type)
	. = ..()
	relay_intercepted_emote(null, "-- INTERCEPTED -- ", say_emphasis(msg))

/obj/machinery/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	. = ..()
	relay_intercepted_say(M, M.name, say_emphasis(text), speaking, FALSE)

/obj/machinery/holopad/hear_signlang(mob/M, text, verb, datum/language/speaking)
	. = ..()
	relay_intercepted_say(M, M.name, say_emphasis(text), speaking, TRUE)

/**
 * relays a heard say
 */
/obj/machinery/holopad/proc/relay_intercepted_say(atom/movable/speaking, voice_name, msg, datum/language/using_language, sign_lang, list/heard = list())
	// no loops please - shame we can't have a room of 8 holopads acting as a council chamber though!
	if(istype(speaking, /obj/machinery/holopad))
		return
	// relay to whereever we're calling to
	outgoing_call?.destination.relay_inbound_say(speaking, voice_name, msg, using_language, sign_lang, source = src, heard = heard)
	// relay to whoever's calling us
	for(var/datum/holocall/holocall as anything in incoming_calls)
		holocall.source.relay_inbound_say(speaking, voice_name, msg, using_language, sign_lang, source = src, heard = heard)
	// relay to relevant AIs too
	if(!ais_projecting)
		return
	var/list/relevant_ais = ais_projecting - speaking
	for(var/mob/living/silicon/ai/the_ai as anything in relevant_ais)
		the_ai.hear_say(msg, "says ([src])", using_language, speaker = speaking)

/**
 * relays a seen emote
 */
/obj/machinery/holopad/proc/relay_intercepted_emote(atom/movable/emoting, visible_name, msg, list/heard = list())
	// no loops please - shame we can't have a room of 8 holopads acting as a council chamber though!
	if(istype(emoting, /obj/machinery/holopad) || isnull(emoting))
		return
	// if it's the outgoing caller, send to other side
	if(emoting == outgoing_call?.remoting)
		outgoing_call?.destination.relay_inbound_emote(emoting, visible_name, msg, outgoing_call.hologram, source = src, heard = heard)
		return
	// otherwise, anyone on our side can see it
	for(var/datum/holocall/holocall as anything in incoming_calls)
		holocall.remoting?.show_message("[msg]", 1)
	// relay to relevant AIs too
	if(!ais_projecting)
		return
	var/list/relevant_ais = ais_projecting - emoting
	for(var/mob/living/silicon/ai/the_ai as anything in relevant_ais)
		the_ai.show_message("(Holopad) [msg]")

/**
 * relays a say sent to us
 */
/obj/machinery/holopad/proc/relay_inbound_say(atom/movable/speaker, speaker_name, msg, datum/language/using_language, sign_lang = FALSE, using_verb = "says", obj/machinery/holopad/source, list/heard = list())
	. = TRUE
	var/scrambled = stars(msg)
	var/for_knowers = "[source && "[SPAN_NOTICE(source.holocall_name(src))]: "][SPAN_NAME(speaker_name)] [using_language? using_language.format_message(msg, using_verb) : "[using_verb], [msg]"]"
	var/for_not_knowers = "[source && "[SPAN_NOTICE(source.holocall_name(src))]: "][SPAN_NAME(speaker_name)] [using_language? using_language.format_message(scrambled, using_verb) : "[using_verb], [scrambled]"]"
	for(var/atom/movable/AM as anything in get_hearers_in_view(world.view, src))
		if(heard[AM])
			continue
		heard[AM] = TRUE
		if(ismob(AM))
			var/mob/M = AM
			if(M.say_understands(src, using_language))
				M.show_message(for_knowers, 2)
			else
				M.show_message(for_not_knowers, 2)
		else if(isobj(AM))
			var/obj/O = AM
			if(O == src)
				continue
			O.hear_talk(src, msg, using_verb, using_language)
	// conference calls!
	for(var/datum/holocall/holocall as anything in incoming_calls)
		if(holocall.source == source)
			continue
		holocall.source.relay_inbound_say(arglist(args))
	// relay to relevant AIs too
	if(!ais_projecting)
		return
	var/list/relevant_ais = ais_projecting - speaker
	for(var/mob/living/silicon/ai/the_ai as anything in relevant_ais)
		if(the_ai.say_understands(speaker, using_language))
			the_ai.show_message("(Holopad) [for_knowers]")
		else
			the_ai.show_message("(Holopad) [for_not_knowers]")
/**
 * relays an emote sent to us
 */
/obj/machinery/holopad/proc/relay_inbound_emote(atom/movable/speaker, speaker_name, msg, obj/effect/overlay/hologram/holo, obj/machinery/holopad/source, list/heard = list())
	. = TRUE
	// attempt autodetect
	if(!speaker_name)
		speaker_name = speaker.name
	if(!holo)
		if(isAI(speaker))
			var/mob/living/silicon/ai/AI = speaker
			holo = AI.hologram
	if(holo)
		holo.relay_emote(speaker_name, msg)
	else
		visible_message("[msg]")
	// conference calls!
	for(var/datum/holocall/holocall as anything in incoming_calls)
		if(holocall.source == source)
			continue
		holocall.source.relay_inbound_emote(arglist(args))
	// relay to relevant AIs too
	if(!ais_projecting)
		return
	var/list/relevant_ais = ais_projecting - speaker
	for(var/mob/living/silicon/ai/the_ai as anything in relevant_ais)
		the_ai.show_message("(Holopad) [msg]")

//? holograms

/obj/machinery/holopad/proc/create_hologram(initial_appearance, path = /obj/effect/overlay/hologram/holopad)
	ASSERT(ispath(path, /obj/effect/overlay/hologram/holopad))
	. = new path(get_turf(src), initial_appearance, src)

/obj/machinery/holopad/proc/destroy_holograms()
	QDEL_NULL(activity_hologram)
	QDEL_LIST(holograms)

/obj/machinery/holopad/proc/register_hologram(obj/effect/overlay/hologram/holopad/holo)
	LAZYADD(holograms, holo)

/obj/machinery/holopad/proc/unregister_hologram(obj/effect/overlay/hologram/holopad/holo)
	LAZYREMOVE(holograms, holo)

/obj/item/circuitboard/holopad/ship
	name = T_BOARD("sector holopad")
	build_path = /obj/machinery/holopad/ship

/obj/machinery/holopad/ship
	name = "sector holopad"
	desc = "An expensive and immobile holopad used for long range ship-to-ship communications."
	icon_state = "shippad"
	base_icon_state = "shippad"
	circuit = /obj/item/circuitboard/holopad/ship
	allow_unanchor = FALSE
	allow_deconstruct = FALSE
	long_range = TRUE

/obj/machinery/holopad/ship/starts_inactive
	call_visibility = FALSE

/**
 * state holder for holocall info
 * and handles a bunch of things
 */
/datum/holocall
	/// source pad
	var/obj/machinery/holopad/source
	/// destination pad
	var/obj/machinery/holopad/destination
	/// are we connected? did they pick up?
	var/connected = FALSE
	/// cross sector call
	var/cross_sector = FALSE
	/// the mob on the pad we're relaying right now (if any); their emotes will be relayed.
	var/mob/remoting
	/// hang up action
	var/datum/action/holocall/hang_up/action_hang_up
	/// toggle view action
	var/datum/action/holocall/swap_view/action_swap_view
	/// our hologram
	var/obj/effect/overlay/hologram/holopad/hologram
	/// last hologram move
	var/hologram_last_move
	/// tracking when to hang up if ringing (30 second timeout)
	var/ring_timerid

/datum/holocall/New(obj/machinery/holopad/sender, obj/machinery/holopad/receiver)
	action_hang_up = new(src)
	action_swap_view = new(src)
	src.source = sender
	src.destination = receiver
	register()

/datum/holocall/Destroy()
	cleanup()
	QDEL_NULL(action_hang_up)
	QDEL_NULL(action_swap_view)
	return ..()

/datum/holocall/proc/caller_id_source()
	return (source.call_anonymous_sector && cross_sector)? "Anonymous" : source.holocall_name()

/datum/holocall/proc/ui_caller_id_source()
	// todo: overmap sector names for anonymous.
	var/obj/effect/overmap/visitable/sector = get_overmap_sector(get_z(source))
	var/scanner_name = sector?.scanner_name || sector?.name || "Unknown"
	return list(
		"name" = (source.call_anonymous_sector && cross_sector)? "Anonymous" : source.holocall_name(),
		"sector" = "[scanner_name]",
		"id" = source.holopad_uid,
	)

/datum/holocall/proc/caller_id_destination()
	return (destination.call_anonymous_sector && cross_sector)? "Anonymous" : destination.holocall_name()

/datum/holocall/proc/ui_caller_id_destination()
	// todo: overmap sector names for anonymous.
	var/obj/effect/overmap/visitable/sector = get_overmap_sector(get_z(destination))
	var/scanner_name = sector?.scanner_name || sector?.name || "Unknown"
	return list(
		"name" = (destination.call_anonymous_sector && cross_sector)? "Anonymous" : destination.holocall_name(),
		"sector" = "[scanner_name]",
		"id" = destination.holopad_uid,
	)

/datum/holocall/proc/initiate_remote_presence(mob/user)
	if(remoting)
		cleanup_remote_presence()
	if(!isAI(user) && user.loc != source.loc)
		user.action_feedback(SPAN_WARNING("You have to be standing on the holopad!"), source)
		return FALSE
	if(!user.request_movement_intercept(src))
		user.action_feedback(SPAN_WARNING("You're already controlling something else!"), source)
		return FALSE
	if(!user.shunt_perspective(remote_perspective()))
		user.clear_movement_intercept()
		user.action_feedback(SPAN_WARNING("You're already focusing somewhere else!"), source)
		return FALSE
	remoting = user
	RegisterSignal(remoting, COMSIG_MOB_RESET_PERSPECTIVE, .proc/cleanup_remote_presence)
	action_hang_up.grant(remoting)
	action_swap_view.grant(remoting)
	if(isAI(user))
		var/mob/living/silicon/ai/ai_user = user
		hologram = destination.create_hologram(ai_user.hologram_appearance())
	else
		hologram = destination.create_hologram(user)
	return TRUE

/datum/holocall/proc/remote_perspective()
	return destination.get_perspective()

/datum/holocall/intercept_mob_move(mob/moving, dir)
	. = TRUE
	if(hologram_last_move + 1 > world.time)
		return
	hologram_last_move = world.time
	hologram.hologram_step(dir)

/datum/holocall/proc/cleanup_remote_presence()
	if(!remoting)
		return
	UnregisterSignal(remoting, COMSIG_MOB_RESET_PERSPECTIVE)
	remoting.unshunt_perspective()
	remoting.clear_movement_intercept()
	action_hang_up.remove(remoting)
	action_swap_view.remove(remoting)
	remoting = null
	if(hologram)
		qdel(hologram)

/datum/holocall/proc/connect()
	connected = TRUE
	LAZYADD(destination.incoming_calls, src)
	LAZYREMOVE(destination.ringing_calls, src)
	source.update_icon()
	destination.update_icon()
	if(ring_timerid)
		deltimer(ring_timerid)

/datum/holocall/proc/register()
	ASSERT(isnull(source.outgoing_call))
	source.outgoing_call = src
	source.update_icon()
	LAZYADD(destination.ringing_calls, src)
	cross_sector = get_overmap_sector(get_z(source)) != get_overmap_sector(get_z(destination))

/datum/holocall/proc/cleanup()
	if(remoting)
		cleanup_remote_presence()
	if(source.outgoing_call == src)
		source.outgoing_call = null
	source = null
	LAZYREMOVE(destination.incoming_calls, src)
	LAZYREMOVE(destination.ringing_calls, src)
	destination = null
	if(ring_timerid)
		deltimer(ring_timerid)

/datum/holocall/proc/ring()
	if(ring_timerid)
		deltimer(ring_timerid)
	destination.ring(src)
	ring_timerid = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/holocall, disconnect), src), 30 SECONDS, TIMER_STOPPABLE)

/datum/holocall/proc/disconnect(obj/machinery/holopad/initiating)
	destination.hung_up(src, initiating == destination)
	source.hung_up(src, initiating == source)
	if(!QDELING(src))
		qdel(src)

/datum/holocall/proc/validate()
	if(!check())
		disconnect(src)
		return FALSE
	. = TRUE
	if(remoting)
		if(!destination.video_enabled)
			cleanup_remote_presence()
		if(!check_remoting())
			cleanup_remote_presence()

/datum/holocall/proc/check_remoting()
	if(!IS_CONSCIOUS(remoting))
		return FALSE
	if(remoting.lying)
		return FALSE
	if(remoting.stunned)
		return TRUE
	return TRUE

/datum/holocall/proc/check()
	// check bidirectional connectivity
	if(!source.holocall_connectivity(destination))
		return FALSE
	if(!destination.holocall_connectivity(source))
		return FALSE
	return TRUE

/datum/action/holocall
	abstract_type = /datum/action/holocall
	target_type = /datum/holocall
	action_type = ACTION_TYPE_DEFAULT

/datum/action/holocall/hang_up
	name = "Hang Up"
	button_icon = 'icons/screen/actions/generic.dmi'
	button_icon_state = "hang_up"
	background_icon = 'icons/screen/actions/backgrounds.dmi'
	background_icon_state = "default"

/datum/action/holocall/hang_up/on_trigger(mob/user, datum/holocall/receiver)
	. = ..()
	receiver.disconnect(receiver.source)

/datum/action/holocall/swap_view
	name = "Stop View"
	button_icon = 'icons/screen/actions/generic.dmi'
	button_icon_state = "swap_cam"
	background_icon = 'icons/screen/actions/backgrounds.dmi'
	background_icon_state = "default"

/datum/action/holocall/swap_view/on_trigger(mob/user, datum/holocall/receiver)
	. = ..()
	receiver.cleanup_remote_presence()

/**
 * obj used for holograms
 */
/obj/effect/overlay/hologram
	name = "hologram"
	desc = "Some kind of hologram."
	alpha = HOLO_NORMAL_ALPHA
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	pass_flags = ATOM_PASS_ALL
	pass_flags_self = ATOM_PASS_BLOB | ATOM_PASS_GLASS | ATOM_PASS_GRILLE | ATOM_PASS_MOB | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_THROWN | ATOM_PASS_TABLE

/obj/effect/overlay/hologram/Initialize(mapload, appearance/clone_from = /datum/hologram/general/holo_female)
	. = ..()
	if(clone_from)
		from_appearance(clone_from)
	color = HOLO_NORMAL_COLOR

/obj/effect/overlay/hologram/Destroy()
	walk(src, NONE)
	return ..()

/obj/effect/overlay/hologram/proc/hologram_step(dir)
	move_to_target(get_step(src, dir))

/obj/effect/overlay/hologram/proc/move_to_target(turf/T, kill_on_failure)
	if(density)
		walk_to(src, T)
	else
		setDir(get_dir(src, T))
		forceMove(T)

/obj/effect/overlay/hologram/proc/stop_moving()
	walk(src, NONE)

/obj/effect/overlay/hologram/Moved()
	. = ..()
	check_location()

/obj/effect/overlay/hologram/proc/check_location()
	return

/obj/effect/overlay/hologram/proc/on_out_of_bounds()
	return

/**
 * used to set or generate holograms
 *
 * @return TRUE/FALSE based on success/failure.
 *
 * @params
 * * appearancelike - either a string corrosponding to a preset, or an /appearance-like object, or an /icon
 *   e.g. atom, mutable appearance, etc.
 * * process_appearance - automatically use required procs to render it into a hologram icon
 *   set to false if it's already processed
 *   value is ignored if string as the datum contains this information
 * * cheap - use appearance rendering instead of icon rendering
 */
/obj/effect/overlay/hologram/proc/from_appearance(appearance/appearancelike, process_appearance = TRUE, cheap = TRUE)
	if(istext(appearancelike))
		var/datum/hologram/holo = GLOB.holograms[appearancelike]
		if(!holo)
			return FALSE
		appearancelike = holo.render(cheap, 255)
	else if(istype(appearancelike, /datum/hologram))
		var/datum/hologram/holo = appearancelike
		appearancelike = holo.render(cheap, 255)
	else if(ispath(appearancelike, /datum/hologram))
		var/datum/hologram/holo = appearancelike
		holo = GLOB.holograms[initial(holo.name)]
		if(!holo)
			return FALSE
		appearancelike = holo.render(cheap, 255)
	else if(isicon(appearancelike))
		var/image/I = image(icon = appearancelike)
		if(process_appearance)
			I = cheap? make_hologram_appearance(I) : render_hologram_icon(I)
		appearancelike = I
	else if(IS_APPEARANCE(appearancelike) || istype(appearancelike, /mutable_appearance))
		var/image/I = image(icon = appearancelike.icon)
		I.appearance = appearancelike
		if(process_appearance)
			I = cheap? make_hologram_appearance(I) : render_hologram_icon(I)
		appearancelike = I
	else if(isatom(appearancelike))
		appearancelike = cheap? make_hologram_appearance(appearancelike, 255) : render_hologram_icon(appearancelike, 255)

	if(isicon(appearancelike))
		src.icon = appearancelike
		src.overlays = list()
		src.our_overlays = list()
	else
		src.appearance = appearancelike
		src.our_overlays = src.overlays
	src.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	src.alpha = HOLO_NORMAL_ALPHA
	src.color = HOLO_NORMAL_COLOR
	// mangle layer
	src.layer = MANGLE_PLANE_AND_LAYER(src.plane, src.layer)
	// revert plane
	src.plane = MOB_PLANE
	// emissive-fy
	cheap_become_emissive()

/obj/effect/overlay/hologram/proc/relay_speech(speaker_name, message, datum/language/lang)
	// TODO: ATOM SAY(), not janky ass atom_say().
	atom_say("[SPAN_NAME(speaker_name)] says, [message]", lang)

/obj/effect/overlay/hologram/proc/relay_emote(speaker_name, message)
	visible_message("[message]")

/**
 * holopad holograms - has some state tracking
 */
/obj/effect/overlay/hologram/holopad
	/// master pad
	var/obj/machinery/holopad/pad

/obj/effect/overlay/hologram/holopad/Initialize(mapload, appearance/clone_from, obj/machinery/holopad/pad)
	. = ..()
	if(pad)
		src.pad = pad
	pad.register_hologram(src)

/obj/effect/overlay/hologram/holopad/Destroy()
	pad.unregister_hologram(src)
	pad = null
	return ..()

/obj/effect/overlay/hologram/holopad/check_location()
	if(!pad)
		return
	if(!pad.check_hologram(src))
		on_out_of_bounds()

/obj/effect/overlay/hologram/holopad/on_out_of_bounds()
	forceMove(get_turf(pad))

/obj/effect/overlay/hologram/holopad/move_to_target(turf/T, kill_on_failure)
	if(!pad.turf_in_range(T))
		if(kill_on_failure)
			qdel(src)
		return FALSE
	return ..()

/**
 * AI holograms
 */
/obj/effect/overlay/hologram/holopad/ai
	/// master AI
	var/mob/living/silicon/ai/owner
	/// who we vored
	var/mob/living/vored

/obj/effect/overlay/hologram/holopad/ai/Destroy()
	if(owner?.hologram == src)
		owner.hologram = null
		owner.terminate_holopad_connection()
	// handle fetish content
	drop_vored()
	// dump shit out just in case
	for(var/atom/movable/AM as anything in contents)
		AM.forceMove(loc)
	return ..()

/obj/effect/overlay/hologram/holopad/ai/examine(mob/user)
	. = ..()
	//If you need an ooc_notes copy paste, this is NOT the one to use.
	var/ooc_notes = owner.ooc_notes
	if(ooc_notes)
		. += SPAN_BOLDNOTICE("OOC Notes: <a href='?src=\ref[owner];ooc_notes=1'>\[View\]</a>\n")
	if(vored)
		. += SPAN_WARNING("It seems to have [vored] inside of it!")

/obj/effect/overlay/hologram/holopad/ai/on_out_of_bounds()
	owner?.terminate_holopad_connection()

/obj/effect/overlay/hologram/holopad/ai/proc/vore_someone(mob/living/victim, mob/living/silicon/ai/user)
	if(vored)
		return FALSE
	playsound('sound/effects/stealthoff.ogg', 50, 0)
	vored = victim
	victim.forceMove(src)
	visible_message(SPAN_BOLDWARNING("[src] suddenly materializes around [victim], entirely engulfing them!"))
	to_chat(user, SPAN_NOTICE("You completely engulf [victim] with your hardlight hologram."))
	pass_flags = NONE
	pass_flags_self = NONE
	color = HOLO_VORE_COLOR
	alpha = HOLO_VORE_ALPHA
	return TRUE

/obj/effect/overlay/hologram/holopad/ai/proc/drop_vored()
	if(!vored)
		return FALSE
	playsound('sound/effects/stealthoff.ogg', 50, 0)
	vored.forceMove(drop_location())
	vored.Weaken(1)
	visible_message(SPAN_BOLDWARNING("[vored] flops out of [src]."))
	vored = null
	pass_flags = initial(pass_flags)
	pass_flags_self = initial(pass_flags_self)
	color = HOLO_NORMAL_COLOR
	alpha = HOLO_NORMAL_ALPHA

#undef HOLO_NORMAL_COLOR
#undef HOLO_VORE_COLOR
#undef HOLO_NORMAL_ALPHA
#undef HOLO_VORE_ALPHA
