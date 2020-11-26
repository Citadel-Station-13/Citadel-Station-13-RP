SUBSYSTEM_DEF(nanoui)
	name = "NanoUI"
	wait = 7

	/// A list of UIs scheduled to process
	var/list/current_run = list()
	// a list of current open /nanoui UIs, grouped by src_object and ui_key
	var/list/open_uis = list()
	// a list of current open /nanoui UIs, not grouped, for use in processing
	var/list/processing_uis = list()

/datum/controller/subsystem/nanoui/stat_entry()
	return ..("P:[length(open_uis)]")

// Stolen from tgui. It's much faster!
/datum/controller/subsystem/nanoui/fire(resumed = FALSE)
	if(!resumed)
		src.current_run = open_uis.Copy()
	// Cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/nanoui/ui = current_run[current_run.len]
		current_run.len--
		// TODO: Move user/src_object check to process()
		if(ui && ui.user && ui.src_object)
			ui.process()
		else
			open_uis.Remove(ui)
		if(MC_TICK_CHECK)
			return
