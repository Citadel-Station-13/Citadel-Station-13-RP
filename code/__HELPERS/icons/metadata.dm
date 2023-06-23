/**
 * icon_states() but faster and better, basically
 */
/proc/fast_icon_states(what)
	if(isicon(what) || isfile(what))
		// uh oh
		// gotta fcopy
		if(!fcopy(what, "data/tmp/rustg_icon_states.dmi"))
			. = list()
			CRASH("failed to fcopy a passed in icon/file to scratch destination for rustg invoke")
		// invoke
		. = rustg_dmi_icon_states("data/tmp/rustg_icon_states.dmi")
		if(!fdel("data/tmp/rustg_icon_states.dmi"))
			CRASH("failed to fdel temporary scratch file")
	else if(istext(what))
		// can invoke directly
		. = rustg_dmi_icon_states(what)
	if(!length(.))
		. = list()
		CRASH("failed to run icon states; please check the input / source.")
	. = json_decode(.)
