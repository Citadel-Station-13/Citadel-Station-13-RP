/**
 * icon_states() but doesn't leak memory out the ass
 *
 * warning: this is actually pretty slow on runtime loaded or created /file and /icon objects.
 * try not to use this on those.
 */
/proc/fast_icon_states(what)
	#define TEMPORARY_FILE "data/tmp/rustg_icon_states.dmi"
	if(isfile(what))
		var/into_path = "[what]"
		if(length(into_path))
			// compiled
			. = rustg_dmi_icon_states(into_path)
		else
			// runtime
			if(!fcopy(what, TEMPORARY_FILE))
				CRASH("failed to fcopy")
			. = rustg_dmi_icon_states(TEMPORARY_FILE)
			if(!fdel(TEMPORARY_FILE))
				CRASH("failed to fdel")
	else if(isicon(what))
		// always runtime
		if(!fcopy(what, TEMPORARY_FILE))
			CRASH("failed to fcopy")
		. = rustg_dmi_icon_states(TEMPORARY_FILE)
		if(!fdel(TEMPORARY_FILE))
			CRASH("failed to fdel")
	else if(istext(what))
		// assume path on server
		. = rustg_dmi_icon_states(what)
	if(!length(.))
		. = list()
		CRASH("failed to run icon states; please check the input / source.")
	. = json_decode(.)
	#undef TEMPORARY_FILE
