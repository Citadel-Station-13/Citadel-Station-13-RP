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

	#warn impl
