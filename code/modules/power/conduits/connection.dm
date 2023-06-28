/**
 * tracks a single device's connection to the plasma network
 */
/datum/wirenet_connection/plasma
	/// connected network
	var/datum/wirenet/plasma



#warn impl; lmao

/datum/wirenet_connection/plasma/is_connected()
	return !isnull(plasma)
