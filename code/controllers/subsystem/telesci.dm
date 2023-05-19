SUBSYSTEM_DEF(telesci)
	name = "Telescience"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// bluespace signals by level
	var/list/signal_lookup
	#warn hook
	/// bluespace jamming by level
	var/list/jamming_lookup
	#warn hook

/datum/controller/subsystem/telesci/proc/register_bluespace_signal(datum/bluespace_signal/sig)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_signal(datum/bluespace_signal/sig)

#warn impl

/datum/controller/subsystem/telesci/proc/register_bluespace_jamming(datum/bluespace_jamming/jam)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_jamming(datum/bluespace_jamming/jam)

#warn impl

/datum/controller/subsystem/telesci/proc/do_teleport()

/datum/controller/subsystem/telesci/proc/signal_query(turf/epicenter)
