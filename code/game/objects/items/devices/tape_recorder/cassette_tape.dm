/**
 * this is a horror
 * we use the typepaths as enums...
 */
/datum/cassette_opcode
/datum/cassette_opcode/next_is_audible_emote
/datum/cassette_opcode/next_is_direct_broadcast

/**
 * cassette tapes; capable of storing spoken audio and their languages
 *
 * all access must be through getters/setters due to how ridiculously synchronized
 * and packed this has to be to store player speech.
 */
/obj/item/cassette_tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon = 'icons/obj/device.dmi'
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = ITEMSIZE_TINY
	materials = list(MAT_STEEL=20, "glass"=5)
	force = 1
	throw_force = 0

	/**
	 * this is a horror
	 * - text = message
	 * - positive number = delay of this many deciseconds after
	 * - negative number = list index of metadata
	 * - typepath = /datum/cassette_opcode opcode
	 *
	 * anything that modifies a message (e.g. delay) comes BEFORE a message.
	 *
	 * i'm sorry.
	 */
	var/list/reel
	/**
	 * names, language ids go in here
	 * prefix ^ = name
	 * prefix % = language
	 */
	var/list/metadata
	/// lookup for language id to metadata index
	var/list/language_lookup
	/// lookup for verbatim names to metadata indeix
	var/list/name_lookup
	/// active iterators
	VAR_PRIVATE/list/datum/cassette_tape_iterator/iterators
	/// active recording iterator
	var/datum/cassette_tape_iterator/write/recording_lock
	/// active translation iterator, or otherwise an iterator being used to rewrite our contents entirely
	var/datum/cassette_tape_iterator/translator/translation_lock
	/// max capacity in messages
	var/capacity_messages = 1800 // it would take you 30 minutes of nonstop chatter to deplete this
	/// used capacity in messages
	var/used_messages = 0
	/// max capacity in deciseconds to avoid people spamming these things for no reason
	var/capacity_time = 30 MINUTES
	/// used time
	var/used_time = 0
	/// last world.time of "tick"
	var/last_recording_tick
	/// last world.time of tangible messages
	var/last_message_time
	/// last language id
	var/last_language_id
	/// last speaker name
	var/last_speaker_name
	/// data list length - [text, speaker name, language id, opcode]
	var/const/data_list_length = 4

	/// did someone ruin this tape by unraveling the tape?
	var/ruined = FALSE

/obj/item/cassette_tape/Destroy()
	kill_iterators()
	return ..()

/obj/item/cassette_tape/proc/wipe()
	kill_iterators()
	reel = null
	metadata = null
	used_messages = 0
	used_time = 0
	last_recording_tick = null
	last_language_id = null
	last_speaker_name = null
	language_lookup = null
	name_lookup = null

/obj/item/cassette_tape/update_overlays()
	. = ..()
	if(ruined)
		. += "ribbonoverlay"

/obj/item/cassette_tape/fire_act()
	ruin()

/obj/item/cassette_tape/attack_self(mob/user)
	. = ..()
	if(.)
		return
	. = ..()
	if(user.a_intent != INTENT_HARM)
		return
	if(!ruined)
		to_chat(user, "<span class='notice'>You pull out all the tape!</span>")
		ruin()

/obj/item/cassette_tape/proc/ruin()
	ruined = TRUE
	update_icon()

/obj/item/cassette_tape/proc/fix()
	ruined = FALSE
	update_icon()

/obj/item/cassette_tape/attackby(obj/item/I, mob/user, params)
	if(ruined && I.is_screwdriver())
		to_chat(user, "<span class='notice'>You start winding the tape back in...</span>")
		playsound(src, I.tool_sound, 50, 1)
		if(do_after(user, 120 * I.tool_speed, target = src))
			to_chat(user, "<span class='notice'>You wound the tape back in.</span>")
			fix()
		return
	else if(istype(I, /obj/item/pen))
		if(loc == user && !user.incapacitated())
			var/new_name = input(user, "What would you like to label the tape?", "Tape labeling") as null|text
			if(isnull(new_name))
				return
			new_name = sanitizeSafe(new_name)
			if(new_name)
				name = "tape - '[new_name]'"
				to_chat(user, "<span class='notice'>You label the tape '[new_name]'.</span>")
			else
				var/old_name = name
				name = "tape"
				to_chat(user, "<span class='notice'>You scratch off '[old_name]' from the label.</span>")
		return
	..()

/**
 * returns an iterator for reading
 * returns null on fail, otherwise a read iterator
 */
/obj/item/cassette_tape/proc/iterator()
	if(translation_lock)
		return
	var/datum/cassette_tape_iterator/I = new
	I.tape = src
	LAZYADD(iterators, I)
	I._init()	// to first pos
	return I

/obj/item/cassette_tape/proc/kill_iterators()
	QDEL_LIST_NULL(iterators)
	QDEL_NULL(recording_lock)

/obj/item/cassette_tape/proc/iterator_killed(datum/cassette_tape_iterator/I)
	if(I == recording_lock)
		recording_lock = null
	if(iterators)
		iterators -= I

/**
 * try to lock this tape for recording
 * returns null on fail, otherwise a write-capable iterator
 */
/obj/item/cassette_tape/proc/obtain_recording_lock()
	if(translation_lock)
		return
	if(recording_lock)
		return recording_lock
	if(full())
		return
	LAZYINITLIST(reel)
	LAZYINITLIST(metadata)
	LAZYINITLIST(language_lookup)
	LAZYINITLIST(name_lookup)
	recording_lock = new /datum/cassette_tape_iterator/write
	recording_lock.tape = src
	recording_lock.current_language_id = last_language_id
	recording_lock.current_speaker_name = last_speaker_name
	return recording_lock

/**
 * locks tape for operation via translator
 * kicks off all read/write iterators
 * return null on fail, otherwise a translation iterator
 */
/obj/item/cassette_tape/proc/lock_for_translation()
	kill_iterators()
	if(translation_lock)
		return
	translation_lock = new /datum/cassette_tape_iterator/translator
	translation_lock.tape = src
	return translation_lock

/obj/item/cassette_tape/proc/full()
	return used_messages >= capacity_messages || used_time >= capacity_time

/obj/item/cassette_tape/proc/increment_messages()
	++used_messages
	if(full())
		kill_iterators()


/**
 * returns index in metadata
 */
/obj/item/cassette_tape/proc/inject_latest_name(name)
	var/index = name_lookup[name]
	if(!index)
		metadata += "^[name]"
		name_lookup[name] = index = metadata.len
	last_speaker_name = name
	reel += -index

/**
 * returns index in metadata
 */
/obj/item/cassette_tape/proc/inject_latest_language(id)
	var/index = language_lookup[id]
	if(!index)
		metadata += "%[id]"
		language_lookup[id] = index = metadata.len
	last_language_id = id
	reel += -index

//Random colour tapes
/obj/item/cassette_tape/random/Initialize(mapload)
	. = ..()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"

/obj/item/cassette_tape/premade
	/**
	 * JSON: [[message, delay, speaker name, language id, opcode], ...]
	 * message mandatory, rest can be skipped
	 * delay defaults to 2 seconds, rest defaults to last value
	 * if no last value, defaults to "Unknown" name and common language
	 */
	var/list/preformatted_data

/obj/item/cassette_tape/premade/Initialize(mapload)
	. = ..()
	inject(preformatted_data)
	preformatted_data = null

/obj/item/cassette_tape/premade/proc/inject(str)
	wipe()
	var/list/decoded
	if(!str)
		return
	if(!islist(str))
		decoded = safe_json_decode(str)
	else
		decoded = str
	if(!length(str))
		return
	last_recording_tick = 0
	last_language_id = LANGUAGE_ID_COMMON
	last_speaker_name = "Unknown"
	var/msg
	var/delay
	var/name
	var/lang
	var/opcode
	language_lookup = list()
	name_lookup = list()
	for(var/list/L in decoded)
		var/dec_len = length(L)
		msg = L[1]
		if(dec_len >= 2)
			delay = L[2]
		else
			delay = 1 SECONDS
		if(dec_len >= 3)
			name = L[3]
		else
			name = null
		if(dec_len >= 4)
			lang = L[4]
		else
			lang = null
		if(dec_len >= 5)
			opcode = text2path(L[5])
			ASSERT(ispath(opcode, /datum/cassette_opcode))
		else
			opcode = null
		if(opcode)
			reel += opcode
		if(name && name != last_speaker_name)
			inject_latest_name(name)
		if(lang && lang != last_language_id)
			inject_latest_language(lang)
		reel += delay	// delay after
		reel += msg
