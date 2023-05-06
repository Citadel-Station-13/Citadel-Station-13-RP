/datum/faction
	abstract_type = /datum/faction
	/// lazy? we only init on request if so
	var/lazy = TRUE
	/// unique id
	var/identifier
	/// faction name
	var/name = "NAME UNSET"
	/// faction desc
	var/desc = "DESC UNSET"
	/// registered with game?
	var/registered = FALSE
	/// supply faction - set to path to init on new
	var/datum/supply_faction/supply
	/// economy faction - set to path to init on new
	var/datum/economy_faction/economy

/datum/faction/New()
	if(ispath(supply))
		supply = new supply
	if(ispath(economy))
		economy = new economy

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
