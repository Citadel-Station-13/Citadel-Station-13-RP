/**
 * bounties
 *
 * generic system, can work on system and faction level.
 */
/datum/supply_bounty
	/// name - usually items and amount
	var/name
	/// desc - what it is
	var/desc
	/// assigned destination
	var/tmp/assigned_destination
	/// are we registered?
	var/registered = FALSE

/datum/supply_bounty/New()
	generate()

/datum/supply_bounty/Destroy()
	if(registered)
		unregister()
	return ..()

/datum/supply_bounty/proc/register()
	assigned_destination = SSsupply.request_destination(src)
	registered = TRUE
	return TRUE

/datum/supply_bounty/proc/unregister()
	SSsupply.clear_destination(assigned_destination, src)
	registered = FALSE
	return TRUE

/**
 * is this valid for a system to take
 */
/datum/supply_bounty/proc/is_offered_to(datum/supply_system/system)
	return TRUE

/**
 * generates name & desc
 */
/datum/supply_bounty/proc/generate()
	#warn impl
