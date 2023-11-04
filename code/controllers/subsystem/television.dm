#define CHANSTATE_AD1 "ad1"
#define CHANSTATE_AD1AIR "ad1running"
#define CHANSTATE_AD2 "ad2"
#define CHANSTATE_AD2AIR "ad2running"
#define CHANSTATE_SHOW1 "show1"
#define CHANSTATE_SHOW1AIR "show1running"

SUBSYSTEM_DEF(television)
	name = "Television"
	wait = 27
	subsystem_flags = SS_NO_TICK_CHECK
	priority = FIRE_PRIORITY_TELEVISION
	init_order = INIT_ORDER_TELEVISION
	runlevels = RUNLEVEL_GAME

	var/list/channels = list()
	//channels but with the nasty punctuation trimmed out.
	var/list/readable_channels = list()
	//all_tvs will be updated by TVs and will be paired with the channel they are in.
	var/list/all_tvs = list()

	//current show or ad played in channel
	var/list/channel_current_shows = list()
	//current language played in channel line
	var/list/channel_current_language = list()
	//last show played in channel
	var/list/channel_previous_shows = list()
	//last ad played in channel
	var/list/channel_previous_ads = list()

	//which CHANSTATE the channel is in
	var/list/channel_current_state = list()
	//stores an integer, which line the channel is on
	var/list/channel_current_line = list()
	//How many lines total the current show or AD is
	var/list/channel_show_length = list()
	//Name of the current show in channel
	var/list/channel_show_name = list()
	//Default language of the current show in channel
	var/list/channel_default_language = list()

	//all possible shows for the channel
	var/list/possible_shows = list()
	//all possible ads for ANY channel
	var/list/possible_ads = list()

/datum/controller/subsystem/television/Initialize(timeofday)
	channels = flist("strings/television/shows/")
	possible_shows = channels
	readable_channels = channels
	//2d list pairing a list of shows to a channel name.
	for (var/c in channels)
		possible_shows[c] += flist("strings/television/shows/[c]")
		channel_current_line[c] = 1
		//process channels into readable_channels
		readable_channels[c] = copytext(c, 1, lentext(c) - 1)
	//all advertisments available
	possible_ads = flist("strings/television/ads/")

//Lohi code what he do
//Not exactly Lohi code anymore
/datum/controller/subsystem/television/fire(resumed = FALSE)
	for (var/channel in channels)
		switch (channel_current_state[channel])
			if (null)
				var/new_show
				do
					new_show = pick(possible_shows[channel])
				while (new_show == channel_previous_shows[channel] && length(possible_shows[channel]) > 1)
				channel_current_shows[channel] = new_show
				channel_current_state[channel] = CHANSTATE_SHOW1

			if (CHANSTATE_SHOW1)
				var/bin = (file2text("strings/television/shows/[channel][channel_current_shows[channel]]"))
				TO_WORLD(bin)
				prepare_show(channel, file2text("strings/television/shows/[channel][channel_current_shows[channel]]"))
				channel_current_state[channel] = CHANSTATE_SHOW1AIR

			if (CHANSTATE_SHOW1AIR, CHANSTATE_AD1AIR, CHANSTATE_AD2AIR)
				var/list/current_show = channel_current_shows[channel]
				var/i = channel_current_line[channel]
				broadcastLine(current_show[i], channel, channel_current_language[channel][i])
				if (channel_current_line[channel] == channel_show_length[channel])
					var/state = channel_current_state[channel]
					switch (state)
						if (CHANSTATE_SHOW1AIR)
							reset_channel(channel)
							channel_current_state[channel] = CHANSTATE_AD1
						if (CHANSTATE_AD1AIR)
							reset_channel(channel)
							channel_current_state[channel] = CHANSTATE_AD2
						if (CHANSTATE_AD2AIR)
							reset_channel(channel)
							channel_current_state[channel] = null
				else
					channel_current_line[channel] += 1

			if (CHANSTATE_AD1, CHANSTATE_AD2)
				//pick an ad, load the ad, grab length,
				//ads play faster than shows because fuck you capitalism
				var/new_ad
				do
					new_ad = pick(possible_ads)
				while (new_ad == channel_previous_ads[channel] && length(possible_ads) > 1)
				channel_current_shows[channel] = new_ad
				prepare_show(channel, file2text("strings/television/ads/[channel_current_shows[channel]]"))
				switch(channel_current_state[channel])
					if (CHANSTATE_AD1)
						channel_current_state[channel] = CHANSTATE_AD1AIR
					if (CHANSTATE_AD2)
						channel_current_state[channel] = CHANSTATE_AD2AIR

///Takes a string and a channel, calls receiveLines on all TVs in that channel with that line.
/datum/controller/subsystem/television/proc/broadcastLine(line, channel, language)
	for (var/obj/machinery/television/tv in all_tvs)
		if (all_tvs[tv] == channel)
			tv.receiveLines(line, language)

//Sets previous show/ads to current show/ad and resets linecount, language, and show lines.
/datum/controller/subsystem/television/proc/reset_channel(channel)
	switch (channel_current_state[channel])
		if (CHANSTATE_SHOW1AIR)
			channel_previous_shows[channel] = channel_current_shows[channel]
			channel_current_shows[channel] = null
			channel_current_language[channel] = null
		else
			channel_previous_ads[channel] = channel_current_shows[channel]
			channel_current_shows[channel] = null
			channel_current_language[channel] = null
	channel_current_line[channel] = 1

//Takes a channel and the filepath to a script. Processes the script to a list of strings.
/datum/controller/subsystem/television/proc/prepare_show(channel, prepared_text)
	//Decode prepared_text filepath to something byond can read
	var/list/decoded_show = json_decode(prepared_text)
	//The language the interpreter will write this if no "language" json is found.
	var/default_language = "COMMON"
	//Temp holder for script language
	var/current_language = ""
	//Set the name of the show for the channel
	channel_show_name[channel] = decoded_show["name"]
	//If the script uses an alternate default_language set it now. This can only be set once at the start.
	default_language = decoded_show["default_language"]
	//Line counter
	var/lines_total = 0
	//This variable is where the finished lines will be put.
	var/prepared_script_text = list()
	//This variable is where the language for each line will go.
	var/prepared_script_language = list()

	//Go through the decoded json line by line and make two lists of strings. One of show lines and one of the language key for that line.
	//Also counts the total lines for the show and sets that.
	for (var/list/line in decoded_show["lines"])
		current_language = line["language"]
		for (var/line_text in line["text"])
			if (current_language != null)
				prepared_script_text += "[line_text]"
				prepared_script_language += decodeTVLanguageKey(current_language)
			else
				prepared_script_text += "[line_text]"
				prepared_script_language += decodeTVLanguageKey(default_language)
			lines_total += 1
		current_language = ""
	//Total lines in the script
	channel_show_length[channel] = lines_total
	//List of script lines
	channel_current_shows[channel] = prepared_script_text
	//List of language keys
	channel_current_language[channel] = prepared_script_language

//Returns a list of all TV channels.
/datum/controller/subsystem/television/proc/getChannels()
	return readable_channels

//Call to decode language keys. Takes a string e.g COMMON and returns the relevant language datum path
/datum/controller/subsystem/television/proc/decodeTVLanguageKey(key)
	switch (key)
		if("ADHERANT")
			return /datum/language/adherent
		if("AKULA")
			return /datum/language/akula
		if("VERNAL")
			return /datum/language/vernal
		if("BIRDSONG")
			return /datum/language/birdsong
		if("DEMON")
			return /datum/language/demon
		if("ANGEL")
			return /datum/language/angel
		if("DIONA")
			return /datum/language/diona_local
		if("SOL_COMMON")
			return /datum/language/human
		if("SLAVIC")
			return /datum/language/slavic
		if("KEISANI")
			return /datum/language/species/keisani
		if("KRISITIK")
			return /datum/language/squeakish
		if("LUINIMMA")
			return /datum/language/species/moth
		if("NARAMADI")
			return /datum/language/sergal
		if("PHORONOID")
			return /datum/language/bones
		if("PROMETHEAN")
			return /datum/language/promethean
		if("SCORI")
			return /datum/language/scori
		if("SHADEKIN")
			return /datum/language/shadekin
		if("SKRELL")
			return /datum/language/skrell
		if("SKRELLFAR")
			return /datum/language/skrellfar
		if("AKHANI")
			return /datum/language/tajaran
		if("TAJARAN")
			return /datum/language/tajaranakhani
		if("TAJSIGN")
			return /datum/language/tajsign
		if("SCHECHI")
			return /datum/language/teshari
		if("UNATHI")
			return /datum/language/unathi
		if("VASILISSAN")
			return /datum/language/bug
		if("VOX")
			return /datum/language/vox
		if("VULPKANIN")
			return /datum/language/vulpkanin
		if("ZADDAT")
			return /datum/language/zaddat
		if("TERMINUS")
			return /datum/language/terminus
		if("GIBBERISH")
			return /datum/language/gibberish
		if("COMMON")
			return /datum/language/common
		if("MACHINE")
			return /datum/language/machine
		if("SIGN")
			return /datum/language/sign
		if("GUTTER")
			return /datum/language/gutter
	//You used a bad language key. mrrp mrrp mrow
	return /datum/language/cat

