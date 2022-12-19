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
	/// What is our current genre?
	var/current_genre = "Electronic"
	var/list/genres = list("Arcade", "Alternative", "Classical and Orchestral", "Country and Western", "Disco, Funk, Soul, and R&B", "Electronic", "Folk and Indie", "Hip-Hop and Rap", "Jazz and Lounge", "Metal", "Pop", "Rock", "Sol Common Precursors") //Avaliable genres.
	var/datum/track/current_track
	var/list/datum/track/tracks = list(
		new/datum/track("Beyond", 'sound/ambience/ambispace.ogg'),
		new/datum/track("Clouds of Fire", 'sound/music/clouds.s3m'),
		new/datum/track("D`Bert", 'sound/music/title2.ogg'),
		new/datum/track("D`Fort", 'sound/ambience/song_game.ogg'),
		new/datum/track("Floating", 'sound/music/main.ogg'),
		new/datum/track("Endless Space", 'sound/music/space.ogg'),
		new/datum/track("Part A", 'sound/misc/TestLoop1.ogg'),
		new/datum/track("Scratch", 'sound/music/title1.ogg'),
		new/datum/track("Trai`Tor", 'sound/music/traitor.ogg'),
		new/datum/track("Stellar Transit", 'sound/ambience/space/space_serithi.ogg'),
	)

	// Only visible if hacked
	var/list/datum/track/secret_tracks = list(
		new/datum/track("Clown", 'sound/music/clown.ogg'),
		new/datum/track("Space Asshole", 'sound/music/space_asshole.ogg'),
		new/datum/track("Thunderdome", 'sound/music/THUNDERDOME.ogg'),
		new/datum/track("Russkiy rep Diskoteka", 'sound/music/russianrapdisco.ogg')
	)

	// Only visible if emagged
	var/list/datum/track/emag_tracks = list(
	)


/obj/machinery/media/jukebox/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/media/jukebox/Destroy()
	qdel(wires)
	wires = null
	return ..()

// On initialization, copy our tracks from the global list
/obj/machinery/media/jukebox/Initialize(mapload)
	. = ..()
	wires = new/datum/wires/jukebox(src)
	update_icon()
	if(LAZYLEN(all_jukebox_tracks)) //Global list has tracks
		tracks.Cut()
		secret_tracks.Cut()
		emag_tracks.Cut()
		for(var/datum/track/T in all_jukebox_tracks) //Load them
			if(!T.jukebox)
				continue
			if(T.secret)
				secret_tracks |= T
			if(T.emag)
				emag_tracks |=T
			else
				tracks |= T
	else if(!LAZYLEN(tracks)) //We don't even have default tracks
		machine_stat |= BROKEN // No tracks configured this round!

/obj/machinery/media/jukebox/process(delta_time)
	if(!playing)
		return
	if(inoperable())
		disconnect_media_source()
		playing = FALSE
		return
	// If the current track isn't finished playing, let it keep going
	if(current_track && world.time < media_start_time + current_track.duration)
		return
	// Otherwise time to pick a new one!
	if(queue.len > 0)
		current_track = queue[1]
		queue.Cut(1, 2)  // Remove the item we just took off the list
	else
		// Oh... nothing in queue? Well then pick next according to our rules
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
				playing = FALSE
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
	if (hacked == newhacked) return
	hacked = newhacked
	if (hacked)
		tracks.Add(secret_tracks)
	else
		tracks.Remove(secret_tracks)
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

/obj/machinery/media/jukebox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || istype(usr, /mob/living/silicon)))
		return

	if(!anchored)
		to_chat(usr, SPAN_WARNING("You must secure \the [src] first."))
		return

	if(inoperable())
		to_chat(usr, SPAN_WARNING("\The [src] doesn't appear to function."))
		return

	if(href_list["change_track"])
		var/datum/track/T = locate(href_list["change_track"]) in tracks
		if(istype(T))
			current_track = T
			StartPlaying()
	else if(href_list["change_genre"])
		var/new_genre = input("Choose Genre", "Genre Selection") in genres
		current_genre = new_genre
	else if(href_list["loopmode"])
		var/newval = text2num(href_list["loopmode"])
		loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SONG, JUKEMODE_PLAY_ONCE), loop_mode)
	else if(href_list["volume"])
		var/newval = input("Choose Jukebox volume (0-100%)", "Jukebox volume", round(volume * 100.0))
		newval = sanitize_integer(text2num(newval), min = 0, max = 100, default = volume * 100.0)
		volume = newval / 100.0
		update_music() // To broadcast volume change without restarting song
	else if(href_list["stop"])
		StopPlaying()
	else if(href_list["play"])
		if(emagged)
			//playsound(src.loc, 'sound/items/AirHorn.ogg', 100, 1)
			//for(var/mob/living/carbon/M in ohearers(6, src))
				//if(M.get_ear_protection() >= 2)
					//continue
				//M.SetSleeping(0)
				//M.stuttering += 20
				//M.ear_deaf += 30
				//M.Weaken(3)
				//if(prob(30))
					//M.Stun(10)
					//M.Unconscious(4)
				//else
					//M.make_jittery(500)
			//spawn(15)
				//explode()
		else if(current_track == null)
			to_chat(usr, "No track selected.")
		else
			StartPlaying()

	return 1

/obj/machinery/media/jukebox/interact(mob/user)
	if(inoperable())
		to_chat(usr, "\The [src] doesn't appear to function.")
		return
	nano_ui_interact(user)

/obj/machinery/media/jukebox/nano_ui_interact(mob/user, ui_key = "jukebox", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data[0]

	if(operable())
		data["playing"] = playing
		data["hacked"] = hacked
		data["max_queue_len"] = max_queue_len
		data["media_start_time"] = media_start_time
		data["loop_mode"] = loop_mode
		data["volume"] = volume
		if(current_track)
			data["current_track_ref"] = "\ref[current_track]"  // Convenient shortcut
			data["current_track"] = current_track.toNanoList()
		data["percent"] = playing ? min(100, round(world.time - media_start_time) / current_track.duration) : 0;

		data["current_genre"] = current_genre

		var/list/nano_tracks = new
		for(var/datum/track/T in tracks)
			if(T.genre != current_genre)
				continue
			nano_tracks[++nano_tracks.len] = T.toNanoList()
		data["tracks"] = nano_tracks

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(playing)

/obj/machinery/media/jukebox/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(mob/user)
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
		return 1
	if(emagged == 1)
		tracks.Add(emag_tracks)
		visible_message(SPAN_NOTICE("\The [src] abruptly stops before rebooting itself. A notice flashes on the screen indicating new songs have been added to the tracklist."))
		update_icon()
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
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/PrevTrack()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()
