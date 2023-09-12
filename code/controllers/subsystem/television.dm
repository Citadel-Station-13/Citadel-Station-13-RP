SUBSYSTEM_DEF(television)
	name = "Television"
	priority = FIRE_PRIORITY_TELEVISION
	init_order = INIT_ORDER_TELEVISION
	subsystem_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/list/tv_shows = list()
	var/list/tv_ads = list()

/datum/controller/subsystem/television/Initialize(timeofday)
	tv_shows = json_decode(file2text("tv_shows.json"), JSON_STRICT)
	tv_ads = json_decode(file2text("tv_ads.json"), JSON_STRICT)

/datum/controller/subsystem/television/fire(resumed = 0)
//This should pick a random show and start playing, then play 1-2 ads between shows, then play shows again.
//May need to run for multiple channels at once, MVP one channel only

//Once a show is picked it should broadcast the lines out to all active TV's to say into the world.
//A timer should start after each line is played delaying the next line
//When lines run out it should play 1-2 ads (based on length?) then start a new show
//Remove played shows from list OR weight shows to only play once every other show is played to account for low options early on.

