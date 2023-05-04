/datum/faction
	abstract_type = /datum/faction
	/// unique id
	var/identifier
	/// faction name
	var/name
	/// faction desc
	var/desc
	/// registered with game?
	var/registered = FALSE
	/// supply faction - set to path to init on new
	var/datum/supply_faction/supply

/datum/faction/New()
	if(ispath(supply))
		supply = new supply

/datum/faction/Destroy()
	if(registered)
		unregister()
	QDEL_NULL(supply)
	return ..()

/datum/faction/proc/register()
	if(SSfactions.factions[identifier])
		. = FALSE
		CRASH("found existing faction [SSfactions.factions[identifier]]")
	SSfactions.factions[identifier] = src
	supply.register()
	registered = TRUE
	return TRUE

/datum/faction/proc/unregister()
	if(SSfactions.factions[identifier] == src)
		SSfactions.factions -= identifier
	supply.unregister()
	registered = FALSE
	return TRUE
