SUBSYSTEM_DEF(nanoui)
	name = "NanoUI"
	wait = 7
	var/list/currentrun = list()
	// a list of current open /nanoui UIs, grouped by src_object and ui_key
	var/list/open_uis = list()
	// a list of current open /nanoui UIs, not grouped, for use in processing
	var/list/processing_uis = list()

/datum/controller/subsystem/nanoui/Shutdown()
	for(var/datum/nanoui/UI in open_uis)
		UI.close()

/datum/controller/subsystem/nanoui/stat_entry()
	return ..("P:[processing_uis.len]")

/datum/controller/subsystem/nanoui/fire(resumed = FALSE)
	if (!resumed) //hihg speeds, ported from the TGUI department (we will takeover soon(TM))
		src.currentrun = processing_uis.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/nanoui/ui = currentrun[currentrun.len]
		currentrun.len--
		if(ui && ui.user && ui.src_object)
			ui.process()
		else
			processing_uis.Remove(ui)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/nanoui/Recover()
	if(SSnanoui.open_uis)
		open_uis |= SSnanoui.open_uis
