//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * So this serves as the overall documentation for telescience, since it's, at its core, based on signals.
 *
 * Few concepts:
 *
 * ## Power
 *
 * Signal power. Effective power determines our accuracy, power usage, etc.
 * Telescience machinery can boost this power to an extent by basically boosting with their own power.
 *
 * Boost power
 *
 * ## Encryption
 *
 * A string. If a device does not have this string in their decryption strings, we multiply our broadcast power
 * by the obfuscation
 *
 * ## Inaccuracy
 *
 * A signal's inaccuracy determines how well you can teleport to the spot you wanted to teleport.
 * This inherently falls off based on the distance you are trying to offset,
 * but signals and jamming sources can affect this.
 *
 * ## Instability
 *
 * A signal's instability determines how well you can keep a keep a single teleport operation - including
 * a portal - open to the same location. If it's high, even the same teleport operation can be broken
 * apart and 'shotgunned'.
 *
 * ## Misc concepts
 *
 * * Signals set to 'shielded' cannot be jammed (or boosted, from reverse-jammers).
 * * Signals set to 'isolated' cannot be boosted by the locking pad.
 * * Signal labels can be set and pads can see them. This defaults to a random string.
 * * Signal labels can be set to only be broadcasted to those who know the encryption
 * * Signals can be set to broadcast coordinates, as well as only broadcast if someone knows the encryption.
 */
/datum/bluespace_signal
	//* locality
	/// attached atom, if any
	var/atom/attached
	/// projecting atom - allows things like jaunters to track what they're locked to
	var/atom/projector
	/// for quick access: our level
	var/z_index
	/// our anchored overmap object
	/// if this is null, we are considered an orphaned/standalone signal and use special calculations
	//  todo: see [code/modules/telescience/machinery/teleporter/_teleporter_system.dm] for what this means.
	var/obj/overmap/entity/overmap_anchor

	/// signal power - 0 for passive signals.
	var/power = 0
	/// signal boost - power, but not.. power. useful for things like telescience beacons to be a little resistant to jamming.
	var/boost = 0
	/// inherent inaccuracy, in tiles. negative values are allowed.
	var/inaccuracy = 0
	/// inherent instability, in tiles. negative values are allowed.
	var/instability = 0

	/// broadcasted name, if any
	var/label
	/// broadcasted name only when encryption is resolved
	var/label_encrypted = FALSE

	/// isolated - ignore pad boosts / positive interference
	var/ioslated = FALSE
	/// shielded - ignore jamming / negative interference
	var/shielded= FALSE

	/// GPS-capable at all
	var/location_rough = TRUE
	/// GPS-capable down to coordinates
	var/location_precise = TRUE
	/// GPS precise only when encryption is resolved
	var/location_precise_secure = TRUE

	/// encryption string sha1 hash, if any
	var/encryption_hash
	/// factor of power decrease if unauthorized, from 1 to 0
	var/encryption_obfuscation = 0.99

	/// dirty ; our host moved / a jamming source moved / we otherwise need a recalculation
	var/locality_dirty = FALSE
	/// we are being affected by these jamming sources
	var/list/datum/bluespace_jamming/locality_jamming
	/// the % of our signal we are at our locality (with the jamming sources in question affecting us)
	var/locality_degradation

/datum/bluespace_signal/New(atom/anchoring, atom/projector)
	register(anchoring)
	src.projector = projector || anchoring
	#warn impl

/datum/bluespace_signal/Destroy()
	for(var/datum/bluespace_jamming/jamming as anything in locality_jamming)
		jamming.locality_signals -= src
	#warn impl
	return ..()

/datum/bluespace_signal/proc/set_host(atom/what)
	if(!isnull(host))
		unregister(host)
	host = what
	if(!isnull(host))
		register(host)

#warn implement the comsig hooks needed to keep track of movements, even when we're inside something

/datum/bluespace_signal/proc/register(atom/host)
	RegisterSignal(host, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(z_changed))
	z_index = get_z(host)
	SStelesci.register_bluespace_signal(src)

/datum/bluespace_signal/proc/unregister(atom/host)
	UnregisterSignal(host, COMSIG_MOVABLE_Z_CHANGED)
	SStelesci.unregister_bluespace_signal(src)
	z_index = null

/datum/bluespace_signal/proc/z_changed(datum/source, old_z, new_z)
	z_index = new_z
	SStelesci.z_change_bluespace_signal(src, old_z, new_z)

/**
 * rebuild everything; call this after modifying *any* variables.
 */
/datum/bluespace_signal/proc/rebuild()
	return
