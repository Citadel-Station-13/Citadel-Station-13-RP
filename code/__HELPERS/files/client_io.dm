/**
 * For FTP requests. (i.e. downloading runtime logs.)
 *
 * However it'd be ok to use for accessing attack logs and such too, which are even laggier.
 */
GLOBAL_VAR_INIT(fileaccess_timer, 0)

/client/proc/browse_files(root_type=BROWSE_ROOT_ALL_LOGS, max_iterations=10, list/valid_extensions=list("txt","log","htm","html","md","json"))
	// wow why was this ever a parameter
	var/root = "data/logs/"
	switch(root_type)
		if(BROWSE_ROOT_ALL_LOGS)
			root = "data/logs/"
		if(BROWSE_ROOT_CURRENT_LOGS)
			root = "[GLOB.log_directory]/"
	var/path = root

	for(var/i in 1 to max_iterations)
		var/list/choices = flist(path)
		if(path != root)
			choices.Insert(1,"/")

		var/choice = input(src,"Choose a file to access:","Download",null) as null|anything in sort_list(choices)
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue
		path += choice

		if(copytext_char(path, -1) != "/") //didn't choose a directory, no need to iterate again
			break
	var/extensions
	for(var/i in valid_extensions)
		if(extensions)
			extensions += "|"
		extensions += "[i]"
	var/regex/valid_ext = new("\\.([extensions])$", "i")
	if( !fexists(path) || !(valid_ext.Find(path)) )
		to_chat(src, "<font color='red'>Error: browse_files(): File not found/Invalid file([path]).</font>")
		return

	return path

// 50 tick delay to discourage spam
#define FTPDELAY 50
// Admins get to spam files faster since we "trust" them!
#define ADMIN_FTPDELAY_MODIFIER 0.5
/**
 * This proc is a failsafe to prevent spamming of file requests.
 * It is just a timer that only permits a download every [FTPDELAY] ticks.
 * This can be changed by modifying FTPDELAY's value above.
 *
 *! PLEASE USE RESPONSIBLY, Some log files can reach sizes of 4MB!
 */
/client/proc/file_spam_check()
	var/time_to_wait = GLOB.fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, SPAN_RED("Error: file_spam_check(): Spam. Please wait [DisplayTimeText(time_to_wait)]."))
		return TRUE
	var/delay = FTPDELAY
	if(holder)
		delay *= ADMIN_FTPDELAY_MODIFIER
	GLOB.fileaccess_timer = world.time + delay
	return FALSE
#undef FTPDELAY
#undef ADMIN_FTPDELAY_MODIFIER
