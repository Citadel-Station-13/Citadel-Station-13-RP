/mob
	/// What receives our keyboard inputs, defaulting to src.
	var/datum/focus

/mob/proc/set_focus(datum/new_focus)
	if(focus == new_focus)
		return
	focus = new_focus
