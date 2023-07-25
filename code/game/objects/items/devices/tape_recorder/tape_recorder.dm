/obj/item/tape_recorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon_state = "taperecorder_empty"
	item_state = "analyzer"
	icon = 'icons/obj/device.dmi'
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	atom_flags = ATOM_HEAR
	throw_force = 2
	throw_speed = 4
	throw_range = 20
	materials = list(MAT_STEEL = 60, MAT_GLASS = 30)

	/// inserted tape
	var/obj/item/cassette_tape/tape = /obj/item/cassette_tape/random
	/// obtained lock on the tape, whether read or write
	var/datum/cassette_tape_iterator/tape_iterator
	/// are we in writing mode? null if we shouldn't be doing anything
	var/write_lock

	/// are we playing?
	var/playing = FALSE
	/// timerid for play tick
	var/play_timerid
	/// how long a delay has to be before we skip it
	var/play_skip_threshold = 10 SECONDS

	/// are we recording?
	var/recording = FALSE


/obj/item/tape_recorder/Initialize(mapload)
	. = ..()
	if(ispath(tape))
		tape = new tape(src)
		update_icon()
	listening_objects += src

/obj/item/tape_recorder/Destroy()
	stop_everything()
	listening_objects -= src
	if(tape)
		QDEL_NULL(tape)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/tape_recorder/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/cassette_tape))
		if(tape)
			to_chat(user, "<span class='notice'>There's already a tape inside.</span>")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		tape = I
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		update_icon()
		return
	..()

/obj/item/tape_recorder/fire_act()
	if(tape)
		tape.ruin() //Fires destroy the tape
	return ..()

/obj/item/tape_recorder/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src)
		if(tape)
			eject()
			return
	..()

/obj/item/tape_recorder/proc/stop_recording(mob/user, silent)
	if(!recording)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] isn't recording."))
		return
	var/datum/cassette_tape_iterator/write/writer = tape_iterator
	if(!writer)
		recording = FALSE
		CRASH("no writer?")
	writer.mark_stop()
	_release_lock()
	recording = FALSE
	if(user && !silent)
		to_chat(user, SPAN_NOTICE("Recording stopped."))
	update_icon()

/obj/item/tape_recorder/proc/start_recording(mob/user, silent)
	if(!tape)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("There's no tape in [src]!"))
		return
	if(tape.ruined)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] makes a scratchy noise."))
		return
	if(recording)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] is already recording."))
		return
	if(playing)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] can't both record and play at the same time."))
		return
	if(is_busy())
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] is busy!"))
		return
	if(obj_flags & EMAGGED)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] makes a scratchy noise."))
		return
	if(tape.full())
		if(user && !silent)
			to_chat(user, SPAN_WARNING("The tape is full!"))
		return
	if(!_write_lock())
		if(user && !silent)
			to_chat(user, SPAN_WARNING("The tape is busy."))
		return
	var/datum/cassette_tape_iterator/write/writer = tape_iterator
	writer.mark_start()
	if(user && !silent)
		to_chat(user, SPAN_NOTICE("Recording started."))
	recording = TRUE
	update_icon()

/obj/item/tape_recorder/proc/stop_playing(mob/user, silent, ending)
	if(!silent)
		if(ending)
			audible_message("[SPAN_BOLD("[src]")]: End of recording.")
		else
			audible_message("[SPAN_BOLD("[src]")]: Playback stopped.")

	if(play_timerid)
		deltimer(play_timerid)
	_release_lock()
	playing = FALSE
	update_icon()

	if(obj_flags & EMAGGED)
		tape.ruin()
		audible_message("<font color=Maroon><B>Tape Recorder</B>: This tape recorder will self-destruct in... Five.</font>")
		addtimer(CALLBACK(src, /atom/proc/audible_message, "<font color=Maroon><B>Tape Recorder</B>: Four.</font>"), 1 SECONDS)
		addtimer(CALLBACK(src, /atom/proc/audible_message, "<font color=Maroon><B>Tape Recorder</B>: Three.</font>"), 2 SECONDS)
		addtimer(CALLBACK(src, /atom/proc/audible_message, "<font color=Maroon><B>Tape Recorder</B>: Two.</font>"), 3 SECONDS)
		addtimer(CALLBACK(src, /atom/proc/audible_message, "<font color=Maroon><B>Tape Recorder</B>: One.</font>"), 4 SECONDS)
		addtimer(CALLBACK(src, /obj/item/tape_recorder/proc/explode), 5 SECONDS)

/obj/item/tape_recorder/proc/start_playing(mob/user, silent)
	if(!tape)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("There's no tape in [src]."))
		return
	if(tape.ruined)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] makes a scratchy noise."))
		return
	if(is_recording())
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] can't playback while recording."))
		return
	if(is_playing())
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] is already playing!"))
		return
	if(!_read_lock())
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[src] failed to lock the tape for reading."))
		return
	if(!silent)
		audible_message("[SPAN_BOLD("[src]")]: Playback started.")
	playing = TRUE
	update_icon()
	_play_next()

/obj/item/tape_recorder/proc/_play_next()
	PRIVATE_PROC(TRUE)
	var/datum/cassette_tape_iterator/reader = tape_iterator
	var/list/got = reader.next_slow()
	if(!got)
		stop_playing(ending = TRUE)
		return
	var/msg = got[CASSETTE_TAPE_DATA_MESSAGE]
	if(msg)
		var/datum/language/L = got[CASSETTE_TAPE_DATA_LANGUAGE]
		var/speaker = got[CASSETTE_TAPE_DATA_NAME]
		var/opcode = got[CASSETTE_TAPE_DATA_OPCODE]
		switch(opcode)
			if(/datum/cassette_opcode/next_is_audible_emote)
				audible_message("[SPAN_BOLD("[src]")]: *[SPAN_BOLD("-someone-")] [msg]*")
			if(/datum/cassette_opcode/next_is_direct_broadcast)
				audible_message("[SPAN_BOLD("[src]")]: [msg]")
			else
				audible_message("[SPAN_BOLD("[src]")]: [speaker] [L.speech_verb], <span class='[L.colour]'>[msg]</span>", L)
	// delays
	var/delay = got[CASSETTE_TAPE_DATA_DELAY]
	if(delay > play_skip_threshold)
		audible_message("[SPAN_BOLD("[src]")]: Skipping [round(delay * 0.1)] seconds of silence.")
		delay = 3 SECONDS
	play_timerid = addtimer(CALLBACK(src, .proc/_play_next), delay, TIMER_STOPPABLE)

/obj/item/tape_recorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	start_playing(usr)

/obj/item/tape_recorder/proc/is_playing()
	return playing

/obj/item/tape_recorder/proc/is_recording()
	return recording

/obj/item/tape_recorder/proc/is_busy()
	return playing || recording

/obj/item/tape_recorder/proc/_release_lock()
	PRIVATE_PROC(TRUE)
	if(tape_iterator)
		QDEL_NULL(tape_iterator)
		return TRUE
	return FALSE

/obj/item/tape_recorder/proc/_lock_deleted(datum/source)
	PRIVATE_PROC(TRUE)
	if(source == tape_iterator)
		tape_iterator = null
	else
		stack_trace("lock deleted called with something that isn't ours?")

/obj/item/tape_recorder/proc/_read_lock()
	PRIVATE_PROC(TRUE)
	ASSERT(!tape_iterator)
	tape_iterator = tape.iterator()
	return !!tape_iterator

/obj/item/tape_recorder/proc/_write_lock()
	PRIVATE_PROC(TRUE)
	ASSERT(!tape_iterator)
	tape_iterator = tape.obtain_recording_lock()
	return !!tape_iterator

/obj/item/tape_recorder/proc/has_read_lock()
	return write_lock == FALSE

/obj/item/tape_recorder/proc/has_write_lock()
	return write_lock == TRUE

/obj/item/tape_recorder/proc/has_lock()
	return !isnull(write_lock)

/obj/item/tape_recorder/verb/eject()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!tape)
		to_chat(usr, "<span class='notice'>There's no tape in \the [src].</span>")
		return
	if(obj_flags & EMAGGED)
		to_chat(usr, "<span class='notice'>The tape seems to be stuck inside.</span>")
		return
	to_chat(usr, "<span class='notice'>You remove [tape] from [src].</span>")
	stop_everything()
	usr.grab_item_from_interacted_with(tape, src)
	tape = null
	update_icon()

/obj/item/tape_recorder/proc/stop_everything(mob/user, silent)
	stop_playing(user, silent)
	stop_recording(user, silent)

/obj/item/tape_recorder/process(delta_time)
	if(!is_recording())
		return PROCESS_KILL
	var/datum/cassette_tape_iterator/write/writer = tape_iterator
	writer.tick(delta_time)

#warn identifiers

/obj/item/tape_recorder/hear_say(raw_message, message, name, voice_ident, atom/movable/actor, remote, datum/language/lang, list/spans, list/params)
	. = ..()
	if(!recording)
		return
	var/datum/cassette_tape_iterator/write/writer = tape_iterator
	if(istype(speaking, /datum/language/audible_action))
		writer.write_emote(msg, M.name)
	else
		writer.write_speech(msg, M.name, speaking.id)

/obj/item/tape_recorder/emag_act(var/remaining_charges, var/mob/user)
	if(obj_flags & EMAGGED)
		obj_flags |= EMAGGED
		recording = 0
		to_chat(user, "<span class='warning'>PZZTTPFFFT</span>")
		update_icon()
		return TRUE
	else
		to_chat(user, "<span class='warning'>It is already emagged!</span>")

/obj/item/tape_recorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, "<span class='danger'>\The [src] explodes!</span>")
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, light_impact_range = 3)
	qdel(src)

/obj/item/tape_recorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.incapacitated())
		return
	start_recording(usr)

/obj/item/tape_recorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!is_busy())
		to_chat(usr, SPAN_WARNING("[src] isn't doing anything right now."))
	stop_everything(usr)

/obj/item/tape_recorder/verb/wipe_tape()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(obj_flags & EMAGGED)
		to_chat(usr, "<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(!tape)
		to_chat(usr, SPAN_WARNING("The tape recorder has no tape inside."))
		return
	if(tape.ruined)
		to_chat(usr, "<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(is_busy())
		to_chat(usr, SPAN_WARNING("The tape recorder is busy!"))
		return
	tape.wipe()
	to_chat(usr, SPAN_WARNING("You wipe the tape."))

/obj/item/tape_recorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!tape)
		to_chat(usr, "<span class='notice'>There's no tape!</span>")
		return
	if(tape.ruined)
		to_chat(usr, "<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(obj_flags & EMAGGED)
		to_chat(usr, "<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(!print_ready())
		to_chat(usr, "<span class='notice'>The recorder can't print that fast!</span>")
		return
	if(is_busy())
		to_chat(usr, "<span class='notice'>You can't print the transcript while playing or recording!</span>")
		return
	if(!_read_lock())
		to_chat(usr, SPAN_WARNING("The tape is busy!"))
		return

	to_chat(usr, "<span class='notice'>Transcript printed.</span>")
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/list/constructed = list()
	constructed += "<center><b>Transcript:</b></center><hr>"
	var/list/head = list()
	head.len = CASSETTE_TAPE_DATA_LEN
	var/datum/cassette_tape_iterator/reader = tape_iterator
	var/msg
	var/name
	var/datum/language/lang
	var/delay
	var/current_time = 0
	var/opcode
	while(reader.next_fast(head))
		msg = head[CASSETTE_TAPE_DATA_MESSAGE]
		name = head[CASSETTE_TAPE_DATA_NAME]
		delay = head[CASSETTE_TAPE_DATA_DELAY]
		opcode = head[CASSETTE_TAPE_DATA_OPCODE]
		current_time += delay
		switch(opcode)
			if(/datum/cassette_opcode/next_is_audible_emote)
				// constructed += "*[name]* --- [msg] ---"
				constructed += "[time2text(current_time, "mm:ss")] (unrecognizable / not speech)"
			if(/datum/cassette_opcode/next_is_direct_broadcast)
				constructed += "<center>[time2text(current_time, "mm:ss")]<br>[msg]</center>"
			else
				lang = head[3]
				if(lang.id == LANGUAGE_ID_COMMON)
					constructed += "[time2text(current_time, "mm:ss")] [name]: [msg]"
				else
					constructed += "[time2text(current_time, "mm:ss")] [name]: (unknown language)"
	P.info = constructed.Join("<br>")
	P.name = "Transcript"
	print_cooldown()
	QDEL_NULL(tape_iterator)

/obj/item/tape_recorder/proc/print_ready()
	return !TIMER_COOLDOWN_CHECK(src, CD_INDEX_TAPE_PRINT)

/obj/item/tape_recorder/proc/print_cooldown()
	TIMER_COOLDOWN_START(src, CD_INDEX_TAPE_PRINT, 30 SECONDS)

/obj/item/tape_recorder/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(is_playing())
		stop_playing(user)
	else if(is_recording())
		stop_recording(user)
	else
		start_recording(user)

/obj/item/tape_recorder/update_icon_state()
	. = ..()
	if(!tape)
		icon_state = "taperecorder_empty"
	else if(recording)
		icon_state = "taperecorder_recording"
	else if(playing)
		icon_state = "taperecorder_playing"
	else
		icon_state = "taperecorder_idle"

/obj/item/tape_recorder/empty
	tape = null
