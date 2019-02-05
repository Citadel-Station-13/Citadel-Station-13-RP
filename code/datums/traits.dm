/datum/proc/add_trait(trait, list/sources)
	if(!length(sources))
		return
	LAZYINITLIST(status_traits)
	LAZYOR(status_traits[trait], sources)

/datum/proc/remove_trait(trait, list/sources, force)
	if(!LAZYACCESS(status_traits, trait))
		return //nothing to remove

	if(!length(sources))		//works for text or lists.
		var/list/remaining = force? null : SANITIZE_TO_LIST((status_traits[trait] & TRAIT_SOURCES_FORCE_REMOVE))
		status_traits[trait] = remaining
		if(!length(status_traits[trait]))
			status_traits -= trait
		return

	status_traits[trait] -= sources
	if(!length(status_traits[trait]))
		status_traits -= trait

/datum/proc/has_trait(trait, list/sources)
	if(!status_traits || !status_traits[trait])
		return FALSE //well of course it doesn't have the trait
	if(!length(sources))
		return TRUE
	if(!islist(sources))
		var/list/L = status_traits[trait]
		return (sources in L)
	else
		return length(status_traits[trait] & sources)

//Hyperoptimized for no reason.
/datum/proc/clear_traits(list/blacklist_sources = TRAIT_CLEAR_DEFAULT_SOURCE_BLACKLIST, list/blacklist_traits = TRAIT_CLEAR_DEFAULT_TRAIT_BLACKLIST)
	if(!status_traits)
		return
	var/BS = length(blacklist_sources)
	var/BT = length(blacklist_traits)
	if(BS)
		BS = SANITIZE_TO_LIST(BS)
	if(BT)
		BT = SANITIZE_TO_LIST(BT)
	if(!BS && !BT)
		status_traits = null
		return
	else if(BS && BT)
		for(var/trait in status_traits)
			if(BT && (trait in blacklist_traits))
				continue
			var/list/sources = status_traits[trait]
			for(var/source in sources)
				if(source in BS)
					continue
				sources -= source
			if(!sources.len)
				status_traits -= trait
	else if(BS && !BT)
		for(var/trait in status_traits)
			var/list/sources = status_traits[trait]
			for(var/source in sources)
				if(source in BS)
					continue
				sources -= source
			if(!sources.len)
				status_traits -= trait
	else if(BT && !BS)
		for(var/trait in status_traits)
			if(trait in blacklist_traits)
				continue
			status_traits -= trait
	stack_trace("Someone screwed up the code in datum/clear_traits, as an impossible solution has occured on line [__LINE__].")
