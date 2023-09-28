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
	//all_tvs will be updated by TVs and will be paired with the channel they are in.
	var/list/all_tvs = list()
	//current show or ad played in channel
	var/list/channel_current_shows = list()
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
	//all possible shows for the channel
	var/list/possible_shows = list()
	//all possible ads for ANY channel
	var/list/possible_ads = list()

/datum/controller/subsystem/television/Initialize(timeofday)
	channels = flist("strings/television/")
	possible_shows = channels
	//2d list pairing a list of shows to a channel name.
	for (var/c in channels)
		possible_shows[c] = flist("strings/television/[c]/shows/")
	//all advertisments available
	possible_ads = flist("string/television/ads/")

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
				//load show details, grab length, etc


				channel_current_state[channel] = CHANSTATE_SHOW1AIR

			if (CHANSTATE_SHOW1AIR, CHANSTATE_AD1AIR, CHANSTATE_AD2AIR)
				var/current_line = channel_current_line[channel]// index of line to show
				broadcastLine(current_line)
				if (current_line == channel_show_length[channel])
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
					channel_current_state[channel] += 1

			if (CHANSTATE_AD1, CHANSTATE_AD2)
				//pick an ad, load the ad, grab length,
				//ads play faster than shows because fuck you capitalism
				var/new_ad
				do
					new_ad = pick(possible_ads)
				while (new_ad == channel_previous_ads[channel] && length(possible_ads) > 1)
				//Tie new_ad to channel_current_show in some fashion either file link or custom decode

///To deliver lines to TVs.
/datum/controller/subsystem/television/proc/broadcastLine(line)
	var/language = "shut up VSC"
	//loop through global_TVs and send to tv procs.
	for (var/obj/machinery/computer/television/tv in all_tvs)
		tv.receiveLines(line, language)

/datum/controller/subsystem/television/proc/reset_channel(channel)
	switch (channel_current_state[channel])
		if (CHANSTATE_SHOW1AIR)
			channel_previous_shows[channel] = channel_current_shows[channel]
			channel_current_shows[channel] = null
		else
			channel_previous_ads[channel] = channel_current_shows[channel]
			channel_current_shows[channel] = null
	channel_current_line[channel] = 1

///For TV's to call on initialization.
/datum/controller/subsystem/television/proc/getChannels()
	return channels
