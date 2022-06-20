//
// Holo-Minimaps Generation Subsystem handles initialization of the holo minimaps.
// Look in code/modules/holomap/generate_holomap.dm to find generateHoloMinimaps()
//
SUBSYSTEM_DEF(holomaps)
	name = "HoloMiniMaps"
	init_order = INIT_ORDER_HOLOMAPS
	subsystem_flags = SS_NO_FIRE
	var/static/holomaps_initialized = FALSE
	var/static/list/holoMiniMaps = list()
	var/static/list/extraMiniMaps = list()
	var/static/list/station_holomaps = list()

/datum/controller/subsystem/holomaps/Recover()
	subsystem_flags |= SS_NO_INIT // Make extra sure we don't initialize twice.

/datum/controller/subsystem/holomaps/Initialize(timeofday)
	generateHoloMinimaps()
	. = ..()
