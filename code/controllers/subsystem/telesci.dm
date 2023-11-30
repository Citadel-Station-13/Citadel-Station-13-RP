SUBSYSTEM_DEF(telesci)
	name = "Telescience"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// bluespace signals by level
	var/list/signal_lookup
	#warn hook
	/// bluespace jamming by level
	var/list/jamming_lookup
	#warn hook
	/// bluespace wakes by zlevel
	var/list/wake_lookup
	#warn hook
	/// bluespace wake images by zlevel
	var/list/wake_image_lookup
	#warn hook
	/// bluespace scanner by zlevel
	var/list/scanner_lookup
	#warn hook

/datum/controller/subsystem/telesci/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	#warn lists

/datum/controller/subsystem/telesci/proc/register_bluespace_wake(datum/bluespace_wake/wake)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_wake(datum/bluespace_wake/wake)

/datum/controller/subsystem/telesci/proc/z_change_bluespace_wake(datum/bluespace_wake/wake, old_z, new_z)

#warn impl

/datum/controller/subsystem/telesci/proc/register_bluespace_signal(datum/bluespace_signal/sig)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_signal(datum/bluespace_signal/sig)

/datum/controller/subsystem/telesci/proc/z_change_bluespace_signal(datum/bluespace_signal/sig, old_z, new_z)

#warn impl

/datum/controller/subsystem/telesci/proc/register_bluespace_jamming(datum/bluespace_jamming/jam)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_jamming(datum/bluespace_jamming/jam)

/datum/controller/subsystem/telesci/proc/z_change_bluespace_jamming(datum/bluespace_jamming/jam, old_z, new_z)

#warn impl

/datum/controller/subsystem/telesci/proc/register_bluespace_scanner(obj/machinery/teleporter/bluespace_scanner/scanner)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_scanner(obj/machinery/teleporter/bluespace_scanner/scanner)

/datum/controller/subsystem/telesci/proc/z_change_bluespace_scanner(obj/machinery/teleporter/bluespace_scanner/scanner, old_z, new_z)

#warn impl
