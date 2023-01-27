/obj/item/tape_recorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon_state = "taperecorder_empty"
	item_state = "analyzer"
	icon = 'icons/obj/device.dmi'
	w_class = ITEMSIZE_SMALL

	matter = list(MAT_STEEL = 60, MAT_GLASS = 30)

	var/emagged = 0.0
	var/recording = 0.0
	var/playing = 0.0
	var/playsleepseconds = 0.0
	var/obj/item/cassette_tape/mytape = /obj/item/cassette_tape/random
	var/canprint = 1
	slot_flags = SLOT_BELT
	throw_force = 2
	throw_speed = 4
	throw_range = 20

/obj/item/tape_recorder/Initialize(mapload)
	. = ..()
	if(ispath(mytape))
		mytape = new mytape(src)
		update_icon()
	listening_objects += src

/obj/item/tape_recorder/empty
	mytape = null

/obj/item/tape_recorder/Destroy()
	listening_objects -= src
	if(mytape)
		qdel(mytape)
		mytape = null
	return ..()


/obj/item/tape_recorder/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/cassette_tape))
		if(mytape)
			to_chat(user, SPAN_NOTICE("There's already a tape inside."))
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		mytape = I
		to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
		update_icon()
		return
	..()


/obj/item/tape_recorder/fire_act()
	if(mytape)
		mytape.ruin() //Fires destroy the tape
	return ..()


/obj/item/tape_recorder/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src)
		if(mytape)
			eject()
			return
	..()


/obj/item/tape_recorder/verb/eject()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape in \the [src]."))
		return
	if(emagged)
		to_chat(usr, SPAN_NOTICE("The tape seems to be stuck inside."))
		return

	if(playing || recording)
		stop()
	to_chat(usr, SPAN_NOTICE("You remove [mytape] from [src]."))
	usr.put_in_hands(mytape)
	mytape = null
	update_icon()


/obj/item/tape_recorder/hear_talk(mob/living/M as mob, msg, var/verb="says", datum/language/speaking=null)
	if(mytape && recording)

		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			mytape.record_speech("[M.name] [speaking.format_message_plain(msg, verb)]")
		else
			mytape.record_speech("[M.name] [verb], \"[msg]\"")


/obj/item/tape_recorder/see_emote(mob/M as mob, text, var/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(mytape && recording)
		mytape.record_speech("[strip_html_properly(text)]")


/obj/item/tape_recorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == 2) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(mytape && recording)
		mytape.record_noise("[strip_html_properly(recordedtext)]")

/obj/item/tape_recorder/emag_act(var/remaining_charges, var/mob/user)
	if(emagged == 0)
		emagged = 1
		recording = 0
		to_chat(user, SPAN_WARNING("PZZTTPFFFT"))
		update_icon()
		return 1
	else
		to_chat(user, SPAN_WARNING("It is already emagged!"))

/obj/item/tape_recorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_DANGER("\The [src] explodes!"))
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/tape_recorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(usr, SPAN_NOTICE("You're already recording!"))
		return
	if(playing)
		to_chat(usr, SPAN_NOTICE("You can't record when playing!"))
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(mytape.used_capacity < mytape.max_capacity)
		to_chat(usr, SPAN_NOTICE("Recording started."))
		recording = 1
		update_icon()

		mytape.record_speech("Recording started.")

		//count seconds until full, or recording is stopped
		while(mytape && recording && mytape.used_capacity < mytape.max_capacity)
			sleep(10)
			mytape.used_capacity++
			if(mytape.used_capacity >= mytape.max_capacity)
				if(ismob(loc))
					var/mob/M = loc
					to_chat(M, SPAN_NOTICE("The tape is full."))
				stop_recording()


		update_icon()
		return
	else
		to_chat(usr, SPAN_NOTICE("The tape is full."))


/obj/item/tape_recorder/proc/stop_recording()
	//Sanity checks skipped, should not be called unless actually recording
	recording = 0
	update_icon()
	mytape.record_speech("Recording stopped.")
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_NOTICE("Recording stopped."))


/obj/item/tape_recorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(recording)
		stop_recording()
		return
	else if(playing)
		playing = 0
		update_icon()
		to_chat(usr, SPAN_NOTICE("Playback stopped."))
		return
	else
		to_chat(usr, SPAN_NOTICE("Stop what?"))


/obj/item/tape_recorder/verb/wipe_tape()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(mytape.ruined)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording || playing)
		to_chat(usr, SPAN_NOTICE("You can't wipe the tape while playing or recording!"))
		return
	else
		if(mytape.storedinfo)	mytape.storedinfo.Cut()
		if(mytape.timestamp)	mytape.timestamp.Cut()
		mytape.used_capacity = 0
		to_chat(usr, SPAN_NOTICE("You wipe the tape."))
		return


/obj/item/tape_recorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(usr, SPAN_NOTICE("You can't playback when recording!"))
		return
	if(playing)
		to_chat(usr, SPAN_NOTICE("You're already playing!"))
		return
	playing = 1
	update_icon()
	to_chat(usr, SPAN_NOTICE("Playing started."))
	for(var/i=1 , i < mytape.max_capacity , i++)
		if(!mytape || !playing)
			break
		if(mytape.storedinfo.len < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: [playedmessage]</font>")

		if(mytape.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: End of recording.</font>")
			break
		else
			playsleepseconds = mytape.timestamp[i+1] - mytape.timestamp[i]

		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		sleep(10 * playsleepseconds)


	playing = 0
	update_icon()

	if(emagged)
		var/turf/T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: This tape recorder will self-destruct in... Five.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Four.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Three.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Two.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: One.</font>")
		sleep(10)
		explode()


/obj/item/tape_recorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(!canprint)
		to_chat(usr, SPAN_NOTICE("The recorder can't print that fast!"))
		return
	if(recording || playing)
		to_chat(usr, SPAN_NOTICE("You can't print the transcript while playing or recording!"))
		return

	to_chat(usr, SPAN_NOTICE("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,mytape.storedinfo.len >= i,i++)
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	sleep(300)
	canprint = 1


/obj/item/tape_recorder/attack_self(mob/user)
	if(recording || playing)
		stop()
	else
		record()


/obj/item/tape_recorder/update_icon()
	if(!mytape)
		icon_state = "taperecorder_empty"
	else if(recording)
		icon_state = "taperecorder_recording"
	else if(playing)
		icon_state = "taperecorder_playing"
	else
		icon_state = "taperecorder_idle"



/obj/item/cassette_tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon = 'icons/obj/device.dmi'
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = ITEMSIZE_TINY
	matter = list(MAT_STEEL=20, "glass"=5)
	force = 1
	throw_force = 0
	var/max_capacity = 1800
	var/used_capacity = 0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/ruined = 0


/obj/item/cassette_tape/update_icon()
	cut_overlays()
	if(ruined)
		add_overlay("ribbonoverlay")


/obj/item/cassette_tape/fire_act()
	ruin()

/obj/item/cassette_tape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, SPAN_NOTICE("You pull out all the tape!"))
		ruin()


/obj/item/cassette_tape/proc/ruin()
	ruined = 1
	update_icon()


/obj/item/cassette_tape/proc/fix()
	ruined = 0
	update_icon()


/obj/item/cassette_tape/proc/record_speech(text)
	timestamp += used_capacity
	storedinfo += "\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


//shows up on the printed transcript as (Unrecognized sound)
/obj/item/cassette_tape/proc/record_noise(text)
	timestamp += used_capacity
	storedinfo += "*\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


/obj/item/cassette_tape/attackby(obj/item/I, mob/user, params)
	if(ruined && I.is_screwdriver())
		to_chat(user, SPAN_NOTICE("You start winding the tape back in..."))
		playsound(src, I.tool_sound, 50, 1)
		if(do_after(user, 120 * I.tool_speed, target = src))
			to_chat(user, SPAN_NOTICE("You wound the tape back in."))
			fix()
		return
	else if(istype(I, /obj/item/pen))
		if(loc == user && !user.incapacitated())
			var/new_name = input(user, "What would you like to label the tape?", "Tape labeling") as null|text
			if(isnull(new_name)) return
			new_name = sanitizeSafe(new_name)
			if(new_name)
				name = "tape - '[new_name]'"
				to_chat(user, SPAN_NOTICE("You label the tape '[new_name]'."))
			else
				name = "tape"
				to_chat(user, SPAN_NOTICE("You scratch off the label."))
		return
	..()

//Random colour tapes
/obj/item/cassette_tape/random/Initialize(mapload)
	. = ..()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"
