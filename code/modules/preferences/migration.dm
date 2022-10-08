//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefile_update()
	if(savefile_version < 8)	//lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in GLOB.preferences_datums)
			var/datum/preferences/D = GLOB.preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		addtimer(CALLBACK(src, .proc/force_reset_keybindings), 3 SECONDS)	//No mob available when this is run, timer allows user choice.
		return FALSE
	if(savefile_version < 13)		//TODO : PROPER MIGRATION SYSTEM - kevinz000
		savefile_version = 13
		addtimer(CALLBACK(src, .proc/force_reset_keybindings), 3 SECONDS)	//No mob available when this is run, timer allows user choice.

	return TRUE
