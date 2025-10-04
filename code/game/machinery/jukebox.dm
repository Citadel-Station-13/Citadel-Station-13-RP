//
// Media Player Jukebox
// Rewritten by Leshana from existing Polaris code, merging in D2K5 and N3X15 work
//

/// Advance to next song in the track list
#define JUKEMODE_NEXT        1
/// Not shuffle, randomly picks next each time.
#define JUKEMODE_RANDOM      2
/// Play the same song over and over
#define JUKEMODE_REPEAT_SONG 3
/// Play, then stop.
#define JUKEMODE_PLAY_ONCE   4

/obj/machinery/media/jukebox/
	name = "space jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/jukebox

	// Vars for hacking
	var/datum/wires/jukebox/wires = null
	/// Whether to show the hidden songs or not.
	var/hacked = 0
	/// Currently no effect, will return in phase II of mediamanager.
	var/freq = 0
	/// Behavior when finished playing a song.
	var/loop_mode = JUKEMODE_PLAY_ONCE
	/// How many songs are we allowed to queue up?
	var/max_queue_len = 3
	var/list/queue = list()
	var/datum/media_track/current_track


/obj/machinery/media/jukebox/Destroy()
	qdel(wires)
	wires = null
	return ..()

// On initialization, copy our tracks from the global list
/obj/machinery/media/jukebox/Initialize(mapload)
	. = ..()
	wires = new/datum/wires/jukebox(src)
	update_icon()
	if(!LAZYLEN(getTracksList()))
		machine_stat |= BROKEN

/obj/machinery/media/jukebox/proc/getTracksList()
	return emagged ? SSmedia_tracks.all_tracks : SSmedia_tracks.jukebox_tracks

/obj/machinery/media/jukebox/process()
	if(!playing)
		return
	if(inoperable())
		disconnect_media_source()
		playing = 0
		return
	// If the current track isn't finished playing, let it keep going
	if(current_track && world.time < media_start_time + current_track.duration)
		return
	// Oh... nothing in queue? Well then pick next according to our rules
	var/list/tracks = getTracksList()
	switch(loop_mode)
		if(JUKEMODE_NEXT)
			var/curTrackIndex = max(1, tracks.Find(current_track))
			var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
			current_track = tracks[newTrackIndex]
		if(JUKEMODE_RANDOM)
			var/previous_track = current_track
			do
				current_track = pick(tracks)
			while(current_track == previous_track && tracks.len > 1)
		if(JUKEMODE_REPEAT_SONG)
			current_track = current_track
		if(JUKEMODE_PLAY_ONCE)
			current_track = null
			playing = 0
			update_icon()
	updateDialog()
	start_stop_song()

// Tells the media manager to start or stop playing based on current settings.
/obj/machinery/media/jukebox/proc/start_stop_song()
	if(current_track && playing)
		media_url = current_track.url
		media_start_time = world.time
		visible_message(SPAN_NOTICE("\The [src] begins to play [current_track.display()]."))
	else
		media_url = ""
		media_start_time = 0
	update_music()

/obj/machinery/media/jukebox/proc/set_hacked(var/newhacked)
	if(hacked == newhacked)
		return
	hacked = newhacked
	updateDialog()

/obj/machinery/media/jukebox/attackby(obj/item/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(W.is_wirecutter())
		return wires.Interact(user)
	if(istype(W, /obj/item/multitool))
		return wires.Interact(user)
	if(W.is_wrench())
		add_fingerprint(user)
		if(playing)
			StopPlaying()
		user.visible_message( \
			SPAN_WARNING("[user] has [anchored ? "un" : ""]secured \the [src]."), \
			SPAN_NOTICE("You [anchored ? "un" : ""]secure \the [src]."))

		anchored = !anchored
		playsound(src, W.tool_sound, 50, TRUE)
		power_change()
		update_icon()
		if(!anchored)
			playing = FALSE
			disconnect_media_source()
		else
			update_media_source()
		return
	return ..()

/obj/machinery/media/jukebox/power_change()
	if(!powered(power_channel) || !anchored)
		machine_stat |= NOPOWER
	else
		machine_stat &= ~NOPOWER

	if(machine_stat & (NOPOWER|BROKEN) && playing)
		StopPlaying()
	update_icon()

/obj/machinery/media/jukebox/update_icon()
	cut_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		if(machine_stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			add_overlay("[state_base]-emagged")
		else
			add_overlay("[state_base]-running")
	if (panel_open)
		add_overlay("panel_open")

/obj/machinery/media/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	if(..())
		return TRUE

	switch(action)
		if("change_track")
			var/datum/media_track/T = locate(params["change_track"]) in getTracksList()
			if(istype(T))
				current_track = T
				StartPlaying()
			return TRUE
		if("loopmode")
			var/newval = text2num(params["loopmode"])
			loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SONG, JUKEMODE_PLAY_ONCE), loop_mode)
			return TRUE
		if("volume")
			var/newval = text2num(params["val"])
			volume = clamp(newval, 0, 1)
			update_music() // To broadcast volume change without restarting song
			return TRUE
		if("stop")
			StopPlaying()
			return TRUE
		if("play")
			if(emagged)
				//playsound(src.loc, 'sound/items/AirHorn.ogg', 100, 1)
				//for(var/mob/living/carbon/M in ohearers(6, src))
					//if(M.get_ear_protection() >= 2)
						//continue
					//M.set_sleeping(0)
					//M.stuttering += 20
					//M.ear_deaf += 30
					//M.afflict_paralyze(20 * 3)
					//if(prob(30))
						//M.afflict_stun(20 * 10)
						//M.afflict_unconscious(20 * 4)
					//else
						//M.make_jittery(500)
				//spawn(15)
					//explode()
			else if(current_track == null)
				to_chat(usr, "No track selected.")
			else
				StartPlaying()
			return TRUE

/obj/machinery/media/jukebox/interact(mob/user)
	if(inoperable())
		to_chat(usr, "\The [src] doesn't appear to function.")
		return
	ui_interact(user)

/obj/machinery/media/jukebox/ui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()

	data["playing"] = playing
	data["loop_mode"] = loop_mode
	data["volume"] = volume
	data["current_track_ref"] = null
	data["current_track"] = null
	data["current_genre"] = null
	if(current_track)
		data["current_track_ref"] = "\ref[current_track]"  // Convenient shortcut
		data["current_track"] = current_track.toTguiList()
		data["current_genre"] = current_track.genre
	data["percent"] = playing ? min(100, round(world.time - media_start_time) / current_track.duration) : 0;

	var/list/ui_tracks = list()
	for(var/datum/media_track/T in getTracksList())
		ui_tracks.Add(list(T.toTguiList()))
	data["tracks"] = ui_tracks

	return data

	// update the ui if it exists, returns null if no ui is passed/found
/obj/machinery/media/jukebox/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", "RetroBox - Space Style")
		ui.open()

/obj/machinery/media/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	if(..())
		return TRUE

	switch(action)
		if("change_track")
			var/datum/media_track/T = locate(params["change_track"]) in getTracksList()
			if(istype(T))
				current_track = T
				StartPlaying()
			return TRUE
		if("loopmode")
			var/newval = text2num(params["loopmode"])
			loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SONG, JUKEMODE_PLAY_ONCE), loop_mode)
			return TRUE
		if("volume")
			var/newval = text2num(params["val"])
			volume = clamp(newval, 0, 1)
			update_music() // To broadcast volume change without restarting song
			return TRUE
		if("stop")
			StopPlaying()
			return TRUE
		if("play")
			if(current_track == null)
				to_chat(usr, "No track selected.")
			else
				StartPlaying()
			return TRUE

/obj/machinery/media/jukebox/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	src.visible_message(SPAN_DANGER("\The [src] blows apart!"), 1)

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/debris/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/W, mob/user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(W.is_wrench())
		add_fingerprint(user)
		if(playing)
			StopPlaying()
		user.visible_message( \
			SPAN_WARNING("[user] has [anchored ? "un" : ""]secured \the [src]."), \
			SPAN_NOTICE("You [anchored ? "un" : ""]secure \the [src]."))

		anchored = !anchored
		playsound(src, W.tool_sound, 50, TRUE)
		power_change()
		update_icon()
		return
	return ..()

/obj/machinery/media/jukebox/emag_act(remaining_charges, mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
	else
		StopPlaying()
		visible_message(SPAN_NOTICE("\The [src] abruptly stops and reboots itself, but nothing else happens."))
		getTracksList()
		return 1
	if(emagged == 1)
		visible_message(SPAN_NOTICE("\The [src] abruptly stops before rebooting itself. A notice flashes on the screen indicating new songs have been added to the tracklist."))
		update_icon()
		getTracksList()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	playing = FALSE
	update_use_power(USE_POWER_IDLE)
	update_icon()
	start_stop_song()

/obj/machinery/media/jukebox/proc/StartPlaying()
	if(!current_track)
		return
	playing = TRUE
	update_use_power(USE_POWER_ACTIVE)
	update_icon()
	start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/NextTrack()
	var/list/tracks = getTracksList()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/PrevTrack()
	var/list/tracks = getTracksList()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()
