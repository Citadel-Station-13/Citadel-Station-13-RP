/**
 * faction data for supply system (and only supply system)
 *
 * at most, we might hook trade pads (tbd) into this, but, keep "regular" faction stuff
 * out of this if at all possible.
 *
 * remember, composition is better than overriding everything everywhere.
 */
/datum/supply_faction
	/// registered?
	var/registered = FALSE
	/// name
	var/name
	/// destination
	var/tmp/assigned_destination

/datum/supply_faction/Destroy()
	if(registered)
		unregister()
	return ..()

/datum/supply_faction/proc/register()
	assigned_destination = SSsupply.request_destination()
	registered = TRUE
	return TRUE

/datum/supply_faction/proc/unregister()
	SSsupply.clear_destination(assigned_destination, src)
	registered = FALSE
	return TRUE
