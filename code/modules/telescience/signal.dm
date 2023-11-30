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
	var/encrypt_label = FALSE
	/// secure hash; cannot be brute forced, but can be reset
	/// used to throw things like jaunters off our trail
	var/security_hash
	/// random GUID always shown; this should be static per projector, if possible.
	var/uid

	/// absolute - ignore pad boosts
	var/isolated = FALSE
	/// shielded - ignore jamming
	var/shielded = FALSE

	/// GPS-capable
	var/tracking = TRUE
	/// GPS only when encryption is resolved
	var/secure_tracking = TRUE

	/// encryption string, if any
	var/encryption
	/// factor of power decrease if unauthorized, from 1 to 0
	var/obfuscation = 0.99

	#warn figure out encryption/security hashing system

/datum/bluespace_signal/New(atom/anchoring, atom/projector)
	register(anchoring)
	src.projector = projector || anchoring
	#warn impl

/datum/bluespace_signal/Destroy()
	#warn impl
	return ..()

/datum/bluespace_signal/proc/set_host(atom/what)
	if(!isnull(host))
		unregister(host)
	host = what
	if(!isnull(host))
		register(host)

/datum/bluespace_signal/proc/register(atom/host)
	#warn impl

/datum/bluespace_signal/proc/unregister(atom/host)
	#warn impl

/datum/bluespace_signal/proc/z_changed(datum/source, old_z, new_z)
	#warn impl

/**
 * rebuild everything; call this after modifying *any* variables.
 */
/datum/bluespace_signal/proc/rebuild()
	return
