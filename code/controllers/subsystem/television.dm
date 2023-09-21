SUBSYSTEM_DEF(television)
	name = "Television"
	priority = FIRE_PRIORITY_TELEVISION
	init_order = INIT_ORDER_TELEVISION
	subsystem_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/running = TRUE
	var/list/channels = list()
	var/list/global_TVs = list()

///Gets all folders in strings/television as channels, launches a show master loop for each channel.
/datum/controller/subsystem/television/Initialize(timeofday)\
	channels = flist(strings/television/)
	for(var/c in channels)
		Show_Master(c)

///Primary function for running a TV channel, runs an while loop so long as var/running is TRUE.
///Runs 1 show then 2 ads and repeats forever.
/datum/controller/subsystem/television/proc/Show_Master(channel)
	var/lastad, var/lastshow
	var/list/channel_shows = flist(string/television/[channel]/shows/)
	var/list/channel_ads = flist(string/television/[channel]/ads/)
	var/i = 1

	while(running)
		if(i == 1)
			var/randomshow = pick(channel_shows)
			while(randomshow == lastshow)
				randomshow = pick(channel_shows)
			lastshow = randomshow

			//figure out how to get default language and name and stuff
			var/list/current_show_decoded = json_decode(lastshow)
			for (var/list/line in current_show_decoded["lines"])
			for (var/line_text in line["text"])
			//broadcastLine(line_text)
			i++
			continue
		else if(i == 2||3)
			//pick ad that is not lastad, set as last ad
			//decode ad
			//read lines
			//broadcast to all TV's in channel
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
/datum/controller/subsystem/television/proc/broadcastLine(line)
	//loop through global_TVs and send to tv procs.
	//TV side with receiveLine(line)?
