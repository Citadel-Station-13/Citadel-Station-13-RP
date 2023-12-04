SUBSYSTEM_DEF(telesci)
	name = "Telescience"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// bluespace signals by level
	var/list/signal_lookup = list()
	/// bluespace jamming by level
	var/list/jamming_lookup = list()
	/// bluespace wakes by zlevel
	var/list/wake_lookup = list()
	/// bluespace wake images by zlevel
	var/list/wake_image_lookup = list()
	/// bluespace scanner by zlevel
	var/list/scanner_lookup = list()

/datum/controller/subsystem/telesci/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	signal_lookup.len = new_z_count
	jamming_lookup.len = new_z_count
	wake_lookup.len = new_z_count
	wake_image_lookup.len = new_z_count
	scanner_lookup.len = new_z_count

/datum/controller/subsystem/telesci/proc/register_bluespace_wake(datum/bluespace_wake/wake)
	var/source_z = get_z(wake.source)
	var/dest_z = get_z(wake.destination)

/datum/controller/subsystem/telesci/proc/unregister_bluespace_wake(datum/bluespace_wake/wake)

/datum/controller/subsystem/telesci/proc/z_change_bluespace_wake(datum/bluespace_wake/wake, old_z, new_z)

#warn impl - bidirectional registration

/datum/controller/subsystem/telesci/proc/register_bluespace_signal(datum/bluespace_signal/sig)
	if(isnull(sig.z_index))
		return
	signal_lookup[sig.z_index] += sig

/datum/controller/subsystem/telesci/proc/unregister_bluespace_signal(datum/bluespace_signal/sig)
	if(isnull(sig.z_index))
		return
	signal_lookup[sig.z_index] -= sig

/datum/controller/subsystem/telesci/proc/z_change_bluespace_signal(datum/bluespace_signal/sig, old_z, new_z)
	if(!isnull(old_z))
		signal_lookup[old_z] -= sig
	if(!isnull(new_z))
		signal_lookup[new_z] += sig

/datum/controller/subsystem/telesci/proc/register_bluespace_jamming(datum/bluespace_jamming/jam)
	if(isnull(jam.z_index))
		return
	jamming_lookup[jam.z_index] += jam

/datum/controller/subsystem/telesci/proc/unregister_bluespace_jamming(datum/bluespace_jamming/jam)
	if(isnull(jam.z_index))
		return
	jamming_lookup[jam.z_index] -= jam

/datum/controller/subsystem/telesci/proc/z_change_bluespace_jamming(datum/bluespace_jamming/jam, old_z, new_z)
	if(!isnull(old_z))
		jamming_lookup[old_z] -= jam
	if(!isnull(new_z))
		jamming_lookup[new_z] += jam

/datum/controller/subsystem/telesci/proc/register_bluespace_scanner(obj/machinery/teleporter/bluespace_scanner/scanner)
	var/z = get_z(scanner)
	if(!isnull(z))
		scanner_lookup[z] += scanner

/datum/controller/subsystem/telesci/proc/unregister_bluespace_scanner(obj/machinery/teleporter/bluespace_scanner/scanner)
	var/z = get_z(scanner)
	if(!isnull(z))
		scanner_lookup[z] -= scanner

/datum/controller/subsystem/telesci/proc/z_change_bluespace_scanner(obj/machinery/teleporter/bluespace_scanner/scanner, old_z, new_z)
	if(!isnull(old_z))
		scanner_lookup[old_z] -= scanner
	if(!isnull(new_z))
		scanner_lookup[new_z] += scanner
