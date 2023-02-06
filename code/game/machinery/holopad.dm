GLOBAL_LIST_EMPTY(holopads)

#define HOLO_NORMAL_COLOR null
#define HOLO_VORE_COLOR "#d97de0"
#define HOLO_NORMAL_ALPHA 120
#define HOLO_VORE_ALPHA 200

/obj/machinery/holopad
	name = "\improper AI holopad"
	desc = "It's a floor-mounted device for projecting holographic images. It is activated remotely."
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

	//? balancing
	/// base power used to project at all
	var/power_base_usage = 50
	/// power used for local call
	var/power_for_local_call = 50
	/// power used for ship to ship call
	var/power_for_sector_call = 2000
	/// power used per hologram
	var/power_per_hologram = 150

	//? ai's
	/// last world.time we requested AI
	var/last_ai_request = 0
	/// cooldown between AI requests
	var/ai_request_cooldown = 60 SECONDS
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
	/// holocall capable
	var/call_receiver = TRUE
	/// visibility
	var/visibility = TRUE
	/// video enabled
	var/video_enabled = TRUE
	/// ringer enabled
	var/ringer_enabled = TRUE
	/// cross overmap capable
	var/long_range = FALSE
	/// ONLY allow communications to other long-range holopads
	var/sector_only = FALSE
	/// active holocall - outgoing
	var/datum/holocall/outgoing_call
	/// active holocalls - inbound
	var/list/datum/holocall/active_calls
	/// inbound holocalls
	var/list/datum/holocalls/ringing

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
	holograms = list()
	GLOB.holopads += src
	var/area/our_area = isturf(loc)? loc.loc : null
	if(our_area)
		LAZYADD(our_area.holopads, src)

/obj/machinery/holopad/Destroy()
	#warn impl rest like disconnect
	destroy_holograms()
	GLOB.holopads -= src
	return ..()

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
	for(var/obj/machinery/holopad/pad as anything in GLOB.holopads)
		if(pad.turf_in_range(T))
			return pad

//? Holocall Connectivity

/**
 * returns if we can reach another holopad
 */
/obj/machinery/holopad/proc/holocall_connectivity(obj/machinery/holopad/other)
	var/obj/effect/overmap/visitable/our_sector = get_overmap_sector(src)
	var/obj/effect/overmap/visitable/their_sector = get_overmap_sector(other)
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
	var/obj/effect/overmap/visitable/our_sector = get_overmap_sector(src)
	for(var/obj/machinery/holopad/pad as anything in GLOB.holopads)
		var/obj/effect/overmap/visitable/their_sector = get_overmap_sector(pad)
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

//? Holocall Helpers

/**
 * generate holocall target ui
 */
/obj/machinery/holopad/proc/ui_connectivity_data()
	. = list()
	for(var/obj/machinery/holopad/pad as anything in holocall_query())
	#warn impl - include refs

/**
 * update holocall target ui
 */
/obj/machinery/holopad/proc/push_ui_connectivity_data()
	send_tgui_data_immediate(data = list("connectivity" = ui_connectivity_data()))

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
	#warn impl

/**
 * checks if we have incoming calls, whether or not connected
 */
/obj/machinery/holopad/proc/incoming_calls_exist()
	#warn impl

/**
 * is call source
 */
/obj/machinery/holopad/proc/is_call_source()
	return !!outgoing_call

/**
 * is call destination
 */
/obj/machinery/holopad/proc/is_call_destination()
	return length(active_calls)

/**
 * checks if we should automatically answer a holocall
 */
/obj/machinery/holopad/proc/should_auto_pickup(datum/holocall/inbound)
	#warn impl but for now TRUE for debug
	return TRUE

//? Relaying say / emote

#warn impl

//? UI

/**
 * CRITICAL CODE:
 * Assembles call data.
 */
/obj/machinery/holopad/proc/ui_call_data()
	. = list()
	// it's very important wet set the values properly!
	if(outgoing_call_connected())
		// SOURCE MODE
		.["calling"] = "source"
		#warn impl
	else if(incoming_calls_connected())
		// DESITNATION MODE
		.["calling"] = "destination"
		#warn impl
	else
		.["calling"] = null
		.["calldata"] = null

/obj/machinery/holopad/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holopad")
		ui.open()

/obj/machinery/holopad/ui_static_data(mob/user)
	. = ..()
	.["connectivity"] = ui_connectivity_data()
	.["is_ai"] = isAI(user)

/obj/machinery/holopad/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn impl

/obj/machinery/holopad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		// user requesting ai
		if("request_ai")

		// ai requesting project
		if("ai_project")

		// user requesting to hang up all calls
		if("disconnect_all")

		// user requesting to hang up a call
		if("disconnect")

		// user requesting to call
		if("call")
			#warn 30 second per unique holopad cooldown for ringing

		// user requesting to connect an incoming/ringing call
		if("connect")

		// user requesting to connect all incoming/ringing calls
		if("connect_all")

		// user toggling holocall ringer
		if("ringer")

		// user toggling holocall visibility
		if("visibility")

		// user toggling video being allowed
		if("toggle_video")

		// user requesting or confirming side swap - must be singular 1:1 call.
		if("request_swap")

		// user requesting to use remote presence
		if("remote_presence")

	#warn impl

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
	#warn impl

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
	update_activity_hologram(active)

/**
 * makes sure we have an activity hologram if we need one
 */
/obj/machinery/holopad/proc/update_activity_hologram(state)
	var/needed = state? (!length(holograms)) : FALSE
	if(needed && !activity_hologram)
		activity_hologram = new(loc, activity_hologram_style, src)
		activity_hologram.set_light(2)
	else if(!needed && activity_hologram)
		QDEL_NULL(activity_hologram)

//? AI holograms

/**
 * requests AI presence
 */
/obj/machinery/holopad/proc/request_ai()

/**
 * starts AI presence
 */
/obj/machinery/holopad/proc/initiate_ai_hologram(mob/living/silicon/ai/the_ai)

/**
 * stops all AI presence
 */
/obj/machinery/holopad/proc/kill_all_ai_holograms()

/**
 * stops AI presence
 */
/obj/machinery/holopad/proc/kill_ai_hologram(mob/living/silicon/ai/the_ai)


#warn parse below

/obj/machinery/holopad/attackby(obj/item/I, mob/user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		attack_hand(user)
	return

/obj/machinery/holopad/attack_hand(mob/living/carbon/human/user) //Carn: Hologram requests.
	if(!istype(user))
		return
	if(tgui_alert(user, "Would you like to request an AI's presence?", "Request AI", list("Yes", "No")) == "Yes")
		if(last_request + 200 < world.time) //don't spam the AI with requests you jerk!
			last_request = world.time
			to_chat(user, SPAN_NOTICE("You request an AI's presence."))
			var/area/area = get_area(src)
			for(var/mob/living/silicon/ai/AI in living_mob_list)
				if(!AI.client)	continue
				to_chat(AI, SPAN_INFO("Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>."))
		else
			to_chat(user, SPAN_WARNING("A request for AI presence was already sent recently."))

/obj/machinery/holopad/attack_ai(mob/living/silicon/ai/user)
	if(!istype(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj.loc != src.loc)//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(get_turf(src))
	else if(!masters[user])//If there is no hologram, possibly make one.
		activate_holo(user)
	else//If there is a hologram, remove it.
		clear_holo(user)
	return

/obj/machinery/holopad/proc/activate_holo(mob/living/silicon/ai/user)
	if(!(machine_stat & NOPOWER) && user.eyeobj.loc == src.loc)//If the projector has power and client eye is on it
		if(user.holo)
			to_chat(user, "<span class='danger'>ERROR:</span> Image feed in progress.")
			return
		create_holo(user)//Create one.
		visible_message("A holographic image of [user] flicks to life right before your eyes!")
	else
		to_chat(user, "[SPAN_DANGER("ERROR:")] Unable to project hologram.")

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	if(M)
		for(var/mob/living/silicon/ai/master in masters)
			if(!master.say_understands(M, speaking))//The AI will be able to understand most mobs talking through the holopad.
				if(speaking)
					text = speaking.scramble(text)
				else
					text = stars(text)
			var/name_used = M.GetVoice()
			//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
			var/rendered
			if(speaking)
				rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
			else
				rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
			master.show_message(rendered, 2)

/obj/machinery/holopad/see_emote(mob/living/M, text)
	if(M)
		for(var/mob/living/silicon/ai/master in masters)
			//var/name_used = M.GetVoice()
			var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
			//The lack of name_used is needed, because message already contains a name.  This is needed for simple mobs to emote properly.
			master.show_message(rendered, 2)
	return

/obj/machinery/holopad/show_message(msg, type, alt, alt_type)
	for(var/mob/living/silicon/ai/master in masters)
		var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)
	return

/obj/machinery/holopad/proc/request_ai_hologram(mob/living/silicon/ai/requesting, turf/T = get_turf(src))

/obj/machinery/holopad/proc/clear_ai_hologram(mob/liivng/silicon/ai/clearing)

/obj/machinery/holopad/proc/create_holo(mob/living/silicon/ai/A, turf/T = loc)
	var/obj/effect/overlay/aiholo/hologram = new(T)//Spawn a blank effect at the location.
	hologram.master = A // So you can reference the master AI from in the hologram procs
	hologram.icon = A.holo_icon
	hologram.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = 1//So space wind cannot drag it.
	hologram.name = "[A.name] (Hologram)"//If someone decides to right click.
	hologram.set_light(2)	//hologram lighting
	hologram.color = color //painted holopad gives coloured holograms
	masters[A] = hologram
	set_light(2)			//pad lighting
	icon_state = "holopad1"
	A.holo = src
	return TRUE

/obj/machinery/holopad/proc/clear_holo(mob/living/silicon/ai/user)
	if(user.holo == src)
		user.holo = null
	qdel(masters[user])//Get rid of user's hologram
	masters -= user //Discard AI from the list of those who use holopad
	if(!masters.len)//If no users left
		set_light(0)			//pad lighting (hologram lighting will be handled automatically since its owner was deleted)
		icon_state = "holopad0"
	return TRUE

/obj/machinery/holopad/process(delta_time)
	for (var/mob/living/silicon/ai/master in masters)
		var/active_ai = (master && !master.stat && master.client && master.eyeobj)//If there is an AI attached, it's not incapacitated, it has a client, and the client eye is centered on the projector.
		if((machine_stat & NOPOWER) || !active_ai)
			clear_holo(master)
			continue

		use_power(power_per_hologram)
	return TRUE

/obj/machinery/holopad/proc/move_hologram(mob/living/silicon/ai/user)
	if(masters[user])
		var/obj/effect/overlay/aiholo/H = masters[user]
		if(H.bellied)
			walk_to(H, user.eyeobj) //Walk-to respects obstacles
		else
			walk_towards(H, user.eyeobj) //Walk-towards does not
		//Hologram left the screen (got stuck on a wall or something)
		if(get_dist(H, user.eyeobj) > world.view)
			clear_holo(user)
		if((HOLOPAD_MODE == RANGE_BASED && (get_dist(H, src) > holo_range)))
			clear_holo(user)

		if(HOLOPAD_MODE == AREA_BASED)
			var/area/holopad_area = get_area(src)
			var/area/hologram_area = get_area(H)

			if(!(hologram_area in holopad_area))
				clear_holo(user)

	return TRUE


#warn parse above

//? AI

#warn ai stuff

//? Say / Emote

/obj/machinery/holopad/see_emote(mob/living/M, text)
	. = ..()
	relay_intercepted_emote(M, msg)

/obj/machinery/holopad/show_message(msg, type, alt, alt_type)
	. = ..()
	relay_intercepted_emote("-- INTERCEPTED -- ", msg)

/obj/machinery/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	. = ..()
	relay_intercepted_say(M, M.name, text, speaking, FALSE)

/obj/machinery/holopad/hear_signlang(mob/M, text, verb, datum/language/speaking)
	. = ..()
	relay_intercepted_say(M, M.name, text, speaking, TRUE)


#warn impl all

/**
 * relays a heard say
 */
/obj/machinery/holopad/proc/relay_intercepted_say(voice_name, msg, datum/language/using_language)

/**
 * relays a seen emote
 */
/obj/machinery/holopad/proc/relay_intercepted_emote(visible_name, msg)

/**
 * relays a say sent to us
 */
/obj/machinery/holopad/proc/relay_inbound_say(mob/speaker, speaker_name, msg, datum/language/using_language, sign_lang = FALSE, using_verb = "says")
	var/scrambled = stars(message)
	var/for_knowers = "[SPAN_NAME(speaker_name)] [using_language? using_language.format_message(msg, using_verb) : "[using_verb], [msg]"]"
	var/for_not_knowers = "[SPAN_NAME(speaker_name)] [using_language? using_language.format_message(scrambled, using_verb) : "[using_verb], [scrambled]"]"
	for(var/atom/movable/AM as anything in get_hearers_in_view(world.view, src))
		if(ismob(AM))
			var/mob/M = AM
			if(M.say_understands(src, speaking))
				M.show_message(for_knowers, 2)
			else
				M.show_message(for_not_knowers, 2)
		else if(isobj(AM))
			var/obj/O = AM
			if(O == src)
				continue
			O.hear_talk(src, message, using_verb, using_language)

#warn impl all

/**
 * relays an emote sent to us
 */
/obj/machinery/holopad/proc/relay_inbound_emote(mob/speaker, obj/effect/overlay/hologram/holo, speaker_name, msg)
	// attempt autodetect
	if(!speaker_name)
		speaker_name = speaker.name
	if(!holo)
		if(isAI(speaker))
			var/mob/living/silicon/ai/AI = speaker
			holo = AI.hologram
	if(!(holo in holograms))
		return FALSE
	holo.relay_emote(speaker_name, msg)

//? holograms

/obj/machinery/holopad/proc/create_hologram(initial_appearance)
	. = new /obj/effect/overlay/hologram/holopad(get_turf(src), initial_appearance, src)

/obj/machinery/holopad/proc/destroy_holograms()
	QDEL_NULL(activity_hologram)
	QDEL_LIST(holograms)

/obj/machinery/holopad/proc/register_hologram(obj/effect/overlay/hologram/holopad/holo)
	holograms += holo

/obj/machinery/holopad/proc/unregister_hologram(obj/effect/overlay/hologram/holopad/holo)
	holograms -= holo

/obj/machinery/holopad/ship
	name = "Command Holopad"
	desc = "An expensive and immobile holopad used for long range ship-to-ship communications."
	icon_state = "shippad"
	base_icon_state = "shippad"
	long_range = TRUE

#warn put on trade post, trade shuttle, pirate post, pirate shuttle, every fucking shuttle in general, bridge, meeting room

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
	/// the mob on the pad we're relaying right now (if any); their emotes will be relayed.
	var/mob/remoting
	/// hang up action
	var/datum/action/holocall/hang_up/action_hang_up
	/// toggle view action
	var/datum/action/holocall/swap_view/action_swap_view
	/// our hologram
	var/obj/effect/overlay/holographic
	/// is video/remote presence allowed?
	var/video_enabled = FALSE

/datum/holocall/New(obj/machinery/holopad/sender, obj/machinery/holopad/receiver)
	#warn impl

/datum/holocall/Destroy()
	disconnect()
	update_activity_hologram(FALSE)
	#warn impl
	return ..()

/datum/holocall/proc/initiate_remote_presence(mob/user)

/datum/holocall/proc/cleanup_remote_presence()

/datum/holocall/proc/swap_sides()

/datum/holocall/proc/connect()

/datum/holocall/proc/ring()

/datum/holocall/proc/disconnect()

/datum/holocall/proc/check()
	// check bidirectional connectivity
	if(!source.holocall_connectivity(destination))
		return FALSE
	if(!destination.holocall_connectivity(source))
		return FALSE
	return TRUE

/datum/holocall/process()
	if(!check())
		disconnect()
		return

#warn relay procs too

/**
 * obj used for holograms
 */
/obj/effect/overlay/hologram
	name = "hologram"
	desc = "Some kind of hologram."
	alpha = HOLO_NORMAL_ALPHA
	color = HOLO_NORMAL_COLOR
	density = FALSE
	opacity = FALSE
	pass_flags = ATOM_PASS_ALL
	pass_flags_self = ATOM_PASS_BLOB | ATOM_PASS_GLASS | ATOM_PASS_GRILLE | ATOM_PASS_MOB | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_THROWN | ATOM_PASS_TABLE
#warn impl

/obj/effect/overlay/hologram/Initialize(mapload, appearance/clone_from)
	. = ..()
	if(clone_from)
		from_appearance(clone_from)

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
 *   value is ignored if string as the dautm contains this information
 * * cheap - use appearance rendering instead of icon rendering
 */
/obj/effect/overlay/hologram/proc/from_appearance(appearance/appearancelike, process_appearance = TRUE, cheap = TRUE)
	if(istext(appearancelike))
		var/datum/hologram/holo = GLOB.holograms[appearancelike]
		if(!holo)
			return FALSE
	else if(isicon(appearancelike))

	else

	#warn impl

#warn emissives :D

#warn icons/screen/actions/generic.dmi hang_up, swap_cam
#warn background icon set to icons/screen/actions/backgrounds too!!

/obj/effect/overlay/hologram/proc/relay_speech(speaker_name, message)
	// TODO: ATOM SAY(), not janky ass atom_say().
	#warn impl

/obj/effect/overlay/hologram/proc/relay_emote(speaker_name, message)
	visible_message("[icon2html(src)] [SPAN_NAME(speaker_name)] [message]")

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

/**
 * AI holograms
 */
/obj/effect/overlay/hologram/holopad/ai
	/// master AI
	var/mob/living/silicon/ai/owner
	/// who we vored
	var/mob/living/vored

/obj/effect/overlay/hologram/holopad/ai/Destroy()
	#warn handle owner somehow
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

#warn impl

#undef HOLO_NORMAL_COLOR
#undef HOLO_VORE_COLOR
#undef HOLO_NORMAL_ALPHA
#undef HOLO_VORE_ALPHA
