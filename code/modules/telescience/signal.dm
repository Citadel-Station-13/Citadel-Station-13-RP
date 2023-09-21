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
	/// attached atom, if any
	var/atom/attached
	/// for quick access: our level
	var/z_index

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
	var/secure_label = FALSE
	/// random GUID always shown
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
	var/obfuscation = 0.01

/datum/bluespace_signal/New(atom/anchoring)
	#warn impl

/datum/bluespace_signal/Destroy()
	#warn impl
	return ..()

/datum/bluespace_signal/proc/set_host(atom/what)
	unregister(host)
	host = what
	if(isnull(host))
		return
	register(host)

/datum/bluespace_signal/proc/register(atom/host)
	#warn impl

/datum/bluespace_signal/proc/unregister(atom/host)
	#warn impl

/datum/bluespace_signal/proc/z_changed(datum/source, old_z, new_z)
	#warn impl


