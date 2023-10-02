/**
 * allows iteration of a cassette tape
 *
 * it is YOUR job to monitor for qdels!
 */
/datum/cassette_tape_iterator
	/// tape
	var/obj/item/cassette_tape/tape
	/// index in reel
	var/reel_index
	/// current speaker name
	var/current_speaker_name
	/// current language id
	var/current_language_id
	/// current language datum to save on lookups
	var/datum/language/current_language
	//? we stage things because we have to be one *ahead* of the playback so delays are done properly.
	/// staged message
	var/staged_msg
	/// staged opcode
	var/staged_opcode
	/// staged delay
	var/staged_delay
	/// default delay
	var/static/default_delay = 1 SECONDS

/datum/cassette_tape_iterator/Destroy()
	tape?.iterator_killed(src)
	tape = null	// lol if you try to access after you get a runtime
	return ..()

//? a note on iterators
//? key here of knowing how this works is
//? staged vars are flushed every step
//? when advancing, we read what's before a message, then stage it
//? peek, and next, always emit staged vars
//? when initializing, we read up to the first delay WITHOUT setting staged
//? that's how we emit an "empty" delay without a message.
//? if we get two opcodes/language changes/etc, we don't care,
//? because the only sync information we need are messages,
//? and the first and second delays.

/**
 * returns delay
 */
/datum/cassette_tape_iterator/proc/_advance()
	PRIVATE_PROC(TRUE)
	// prep
	if(!reel_index)
		return
	var/read
	var/index = reel_index
	var/list/reel = tape.reel
	staged_msg = null
	staged_opcode = null
	staged_delay = default_delay
	// scan
	while(index <= reel.len)
		read = reel[index]
		if(istext(read))
			staged_msg = read
			// flush
			reel_index = index + 1
			return
		else if(isnum(read))
			if(read >= 0)
				staged_delay = read
			else
				var/metadata = tape.metadata[-read]
				var/val = copytext(metadata, 2)
				switch(metadata[1])
					if(CASSETTE_METADATA_NAME)
						current_speaker_name = val
					if(CASSETTE_METADATA_LANGUAGE)
						current_language_id = val
						current_language = SScharacters.resolve_language_id(val)
		else if(ispath(read, /datum/cassette_opcode))
			staged_opcode = read
		index++
	// we moved past
	reel_index = null

/datum/cassette_tape_iterator/proc/_init()
	// reset
	if(!tape.reel.len)
		reel_index = null
		return
	reel_index = 1
	current_speaker_name = "Unknown"
	current_language_id = LANGUAGE_ID_COMMON
	current_language = SScharacters.resolve_language_id(LANGUAGE_ID_COMMON)
	staged_msg = null
	staged_opcode = null
	staged_delay = 1 SECONDS
	// read up to the first delay; if there isn't any, we just read up to the first message
	var/read
	var/index = reel_index
	var/list/reel = tape.reel
	while(index <= reel.len)
		read = reel[index]
		if(istext(read))
			staged_msg = read
			reel_index = index + 1
			return
		else if(isnum(read))
			if(read >= 0)
				staged_delay = read
				reel_index = index + 1
				return
			else
				var/metadata = tape.metadata[-read]
				var/val = copytext(metadata, 2)
				switch(metadata[1])
					if(CASSETTE_METADATA_NAME)
						current_speaker_name = val
					if(CASSETTE_METADATA_LANGUAGE)
						current_language_id = val
						current_language = SScharacters.resolve_language_id(val)
		else if(ispath(read, /datum/cassette_opcode))
			staged_opcode = read
		index++
	// we moved past
	reel_index = null

/**
 * dumps next data to a returned list and advances; returns null if end
 * [message, speaker name, language datum, delay, opcode]
 * delay is to be used to delay after read.
 * null name means it's a noise in the room
 * null message means it's just a delay (or maybe read the opcode)
 */
/datum/cassette_tape_iterator/proc/next_slow()
	if(!reel_index)
		return
	. = list(
		staged_msg,
		current_speaker_name,
		current_language,
		staged_delay,
		staged_opcode
	)
	_advance()

/**
 * dumps next data to a provided list and advances
 * [message, speaker name, language datum, delay, opcode]
 * delay is to be used to delay after read.
 * null name means it's a noise in the room
 * null message means it's just a delay (or maybe read the opcode)
 * returns false if nothing's there
 */
/datum/cassette_tape_iterator/proc/next_fast(list/L)
	if(!reel_index)
		return FALSE
	L[CASSETTE_TAPE_DATA_DELAY] = staged_delay
	L[CASSETTE_TAPE_DATA_LANGUAGE] = current_language
	L[CASSETTE_TAPE_DATA_NAME] = current_speaker_name
	L[CASSETTE_TAPE_DATA_OPCODE] = staged_opcode
	L[CASSETTE_TAPE_DATA_MESSAGE] = staged_msg
	_advance()
	return TRUE

/**
 * dumps next data to a returned list without advancing; returns null if end
 * [message, speaker name, language datum, delay, opcode]
 * delay is to be used to delay after read.
 * null name means it's a noise in the room
 * null message means it's just a delay (or maybe read the opcode)
 */
/datum/cassette_tape_iterator/proc/peek_slow()
	if(!reel_index)
		return
	. = list(
		staged_msg,
		current_speaker_name,
		current_language,
		staged_delay,
		staged_opcode
	)

/**
 * dumps next data to a provided list without advancing
 * [message, speaker name, language datum, delay, opcode]
 * delay is to be used to delay after read.
 * null name means it's a noise in the room
 * null message means it's just a delay (or maybe read the opcode)
 * returns false if nothing's there
 */
/datum/cassette_tape_iterator/proc/peek_fast(list/L)
	if(!reel_index)
		return FALSE
	L[CASSETTE_TAPE_DATA_DELAY] = staged_delay
	L[CASSETTE_TAPE_DATA_LANGUAGE] = current_language
	L[CASSETTE_TAPE_DATA_NAME] = current_speaker_name
	L[CASSETTE_TAPE_DATA_OPCODE] = staged_opcode
	L[CASSETTE_TAPE_DATA_MESSAGE] = staged_msg
	return TRUE

/**
 * used to **write** to a tape.
 */
/datum/cassette_tape_iterator/write

/**
 * expects **raw** message
 */
/datum/cassette_tape_iterator/write/proc/write_speech(message, speaker_name, language_id, override_pause)
	if(language_id != tape.last_language_id)
		tape.inject_latest_language(language_id)
	if(speaker_name != tape.last_speaker_name)
		tape.inject_latest_name(speaker_name)
	tape.reel += world.time - tape.last_message_time
	tape.last_message_time = world.time
	tape.reel += message
	tape.increment_messages()

/**
 * expects **raw** message
 *
 * speaker_name to null for actions that are heard by the recorder not associated to anyone
 */
/datum/cassette_tape_iterator/write/proc/write_emote(message, speaker_name, override_pause)
	if(speaker_name != tape.last_speaker_name)
		tape.inject_latest_name(speaker_name)
	tape.reel += world.time - tape.last_message_time
	tape.last_message_time = world.time
	tape.reel += /datum/cassette_opcode/next_is_audible_emote
	tape.reel += message
	tape.increment_messages()

/datum/cassette_tape_iterator/write/proc/tick(dt)
	tape.used_time += world.time - tape.last_recording_tick
	tape.last_recording_tick = world.time

/datum/cassette_tape_iterator/write/proc/mark_start()
	tape.last_message_time = world.time
	tape.last_recording_tick = world.time

/datum/cassette_tape_iterator/write/proc/mark_stop()
	if(!tape.reel.len)
		// bro we haven't written anything
		return
	if(tape.reel[tape.reel.len] == "Jumping to next recording segment...")
		return
	if(tape.last_language_id != LANGUAGE_ID_COMMON)
		tape.inject_latest_language(LANGUAGE_ID_COMMON)
	if(tape.last_speaker_name != "\[Recorder\]")
		tape.inject_latest_name("\[Recorder\]")
	tape.reel += world.time - tape.last_message_time
	tape.last_message_time = world.time
	tape.reel += /datum/cassette_opcode/next_is_direct_broadcast
	tape.reel += "Jumping to next recording segment..."
	tape.used_time += world.time - tape.last_recording_tick
	tape.last_recording_tick = world.time

/**
 * used to translate a tape
 */
/datum/cassette_tape_iterator/translator

/**
 * returns lines translated
 */
/datum/cassette_tape_iterator/translator/proc/translate(datum/translation_context/context)
	// ez
	. = 0
	var/list/reel = tape.reel
	var/list/metadata = tape.metadata
	var/static/common_str = "[CASSETTE_METADATA_LANGUAGE][LANGUAGE_ID_COMMON]"
	var/common_index = metadata.Find(common_str)
	var/translating = FALSE
	var/ignore_next = FALSE
	if(!common_index)
		metadata += common_str
		common_index = metadata.len
		tape.language_lookup["[LANGUAGE_ID_COMMON]"] = common_index
	for(var/i in 1 to reel.len)
		var/read = reel[i]
		if(isnum(read) && read > 0)
			var/mdstr = metadata[read]
			if(mdstr == common_str)
				translating = FALSE
				continue
			if(mdstr[1] == CASSETTE_METADATA_LANGUAGE)
				var/id = copytext(mdstr, 2)
				var/datum/language/L = SScharacters.resolve_language_id(id)
				if(context.can_translate(L, require_perfect = TRUE))
					reel[i] = common_index
					translating = TRUE
				else
					translating = FALSE
		else if(istext(read))
			if(ignore_next)
				ignore_next = FALSE
			else if(translating)
				++.
		else if(ispath(read, /datum/cassette_opcode))
			switch(read)
				if(/datum/cassette_opcode/next_is_audible_emote)
					ignore_next = TRUE
				if(/datum/cassette_opcode/next_is_direct_broadcast)
					ignore_next = TRUE

// todo: compactor
// todo: transformer/mapper
