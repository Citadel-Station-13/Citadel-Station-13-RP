/datum/bluespace_signal
	/// attached atom
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
	/// encryption string, if any
	var/encryption
	/// broadcasted name, if any
	var/identity
	/// absolute - ignore any jamming / disruption whatsoever, including admin level protections
	var/absolute = FALSE
	/// factor of power decrease if unauthorized, from 1 to 0
	var/obfuscation = 0.01
	/// key required to authorize
	var/encryption
	/// beacon tag
	var/label

	#warn impl

/datum/bluespace_signal/New(atom/anchoring)
	#warn impl

/datum/bluespace_signal/Destroy()
	#warn impl
	return ..()

/**
 * signal metadata
 */
/datum/bluespace_signal/proc/signal_data()
	return list(
		"label" = label,
	)

