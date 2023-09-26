SUBSYSTEM_DEF(television)
	name = "Television"
	priority = FIRE_PRIORITY_TELEVISION
	init_order = INIT_ORDER_TELEVISION
	subsystem_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/running = TRUE
	var/list/channels = list()
	var/list/all_tvs = list()

///Gets all folders in strings/television as channels, launches a show master loop for each channel.
/datum/controller/subsystem/television/Initialize(timeofday)\
	channels = flist("strings/television/")
	for(var/c in channels)
		Show_Master(c)

///Primary function for running a TV channel, runs on a while loop so long as var/running is TRUE.
///Runs 1 show then 2 ads then repeats.
/datum/controller/subsystem/television/proc/Show_Master(channel)
	var/lastad
	var/lastshow
	var/list/channel_shows = flist("string/television/[channel]/shows"/)
	var/list/channel_ads = flist("string/television/[channel]/ads/")
	var/i = 1
	var/default_delay = 27

	while(running)
		var/showname = ""
		var/language = ""
		var/default_language = "common"
		if(i == 1)
			//pick a random show but not the same as the last
			var/randomshow = pick(channel_shows)
			while(randomshow == lastshow)
				randomshow = pick(channel_shows)
				//add a break condition here in case this runs forever :cat:
			lastshow = randomshow

			//decode picked show and set basics
			var/list/current_show_decoded = json_decode(lastshow)
			for(var/name in current_show_decoded["name"])
				showname = name
			for(var/dlang in current_show_decoded["default_language"])
				default_language = dlang

			//start looping through each lines block, pull laguage if it exists, then read and send lines
			for (var/list/line in current_show_decoded["lines"])
				for (var/nlang in line["language"])
					language = nlang
				for (var/line_text in line["text"])
					if(language != "")
						broadcastLine(channel, line_text, language)
					else
						broadcastLine(channel, line_test, default_language)
			i++
			continue
		else if(i == 2 || i == 3)
			//Copy above but targetting ads instead. Functionize this?
			i++
			continue
		else if(i == 4)
			i = 1
			continue
	return

///For TV's to call on initialization.
/datum/controller/subsystem/television/proc/getChannels()
	return channels

///For Show_Master to deliver lines to TVs.
/datum/controller/subsystem/television/proc/broadcastLine(channel, line, language)
	//loop through global_TVs and send to tv procs.
	//TV side with receiveLine(line)?
	//for (var/path/to/tv/tv in all_tvs)
    //tv.tvize_idk()
	return
