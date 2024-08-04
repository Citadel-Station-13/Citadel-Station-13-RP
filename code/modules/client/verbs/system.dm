//? Setup Panels

/client/verb/character_setup()
	set name = "Character Setup"
	set category = VERB_CATEGORY_SYSTEM

	prefs?.ShowChoices(usr)

/client/verb/preferences()
	set name = "Game Preferences"
	set category = VERB_CATEGORY_SYSTEM

	preferences.ui_interact(mob)

//? Sound Management

/client/verb/stop_client_sounds()
	set name = "Stop Sounds"
	set category = VERB_CATEGORY_SYSTEM
	set desc = "Stop Current Sounds"
	usr << sound(null)
	usr.client?.tgui_panel?.stop_music()

//? Ping System

/client/verb/update_ping(time as num)
	set instant = TRUE
	set name = ".update_ping"
	var/ping = pingfromtime(time)
	lastping = ping
	if (!avgping)
		avgping = ping
	else
		avgping = MC_AVERAGE_SLOW(avgping, ping)

/client/proc/pingfromtime(time)
	return ((world.time+world.tick_lag*TICK_USAGE_REAL/100)-time)*100

/client/verb/display_ping(time as num)
	set instant = TRUE
	set name = ".display_ping"
	to_chat(src, "<span class='notice'>Round trip ping took [round(pingfromtime(time),1)]ms (Avg: [round(avgping, 1)]ms])</span>")

/client/verb/ping()
	set name = "Ping"
	set category = VERB_CATEGORY_SYSTEM
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")
