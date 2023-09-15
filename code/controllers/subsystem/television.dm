SUBSYSTEM_DEF(television)
	name = "Television"
	priority = FIRE_PRIORITY_TELEVISION
	init_order = INIT_ORDER_TELEVISION
	subsystem_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/list/tv_shows = list()
	var/show_name = ""

///datum/controller/subsystem/television/Initialize(timeofday)
//	tv_shows = json_decode(file2text("./strings/television/tv_shows.json"))
//Defunct this: Shows will be contained in individual json files. Use a function call for ads or shows

/datum/controller/subsystem/television/fire(resumed = 0)
	while(i < 4)
		if(i = 3)
			i = 0
		if(i = 0)
			//call get_show()
			//for (var/list/line in tv_shows["lines"])
			//for (var/line_text in line["text"])
				//TO_WORLD(line_text)
				//sleep(27)
			i++
		else
			//call get_ad()
			//for (var/list/line in tv_shows["lines"])
			//for (var/line_text in line["text"])
				//TO_WORLD(line_text)
				//sleep(27)
			i++

//This should pick a random show and start playing, then play 1-2 ads between shows, then play shows again.
//May need to run for multiple channels at once, MVP one channel only

//Once a show is picked it should broadcast the lines out to all active TV's to say into the world.
//A timer should start after each line is played delaying the next line
//When lines run out it should play 1-2 ads (based on length?) then start a new show
//Remove played shows from list OR weight shows to only play once every other show is played to account for low options early on.

/datum/controller/subsystem/television/get_show()
/*
    Returns a list of all files (as file objects) in the directory path provided, as well as all files in any subdirectories, recursively!
    The list returned is flat, so all items can be accessed with a simple loop.
    This is designed to work with browse_rsc(), which doesn't currently support subdirectories in the browser cache.
*/
    set background = 1
    . = list()
    for(var/f in flist(./strings/television/tv_shows/))
        if(copytext("[f]", -1) == "/")
        else
            . += file("[./strings/television/tv_shows/][f]")
///datum/controller/subsystem/television/get_ad()
//Clone of get_show() but it targets ads instead
