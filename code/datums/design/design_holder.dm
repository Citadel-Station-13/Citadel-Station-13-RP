/datum/design_holder
	/// any ids to specifically include
	var/list/design_ids
	/// owner datum - this can even be null, this is just so lathes don't delete "shared" holders.
	var/datum/owner

/datum/design_holder/New(datum/owner)
	src.owner = owner

/datum/design_holder/Destroy()
	owner = null
	return ..()

/datum/design_holder/proc/available_ids()
	RETURN_TYPE(/list)
	return design_ids || list()

/datum/design_holder/proc/available_designs()
	RETURN_TYPE(/list)
	return SSresearch.fetch_designs(available_ids())

/datum/design_holder/proc/has_id(id)
	return id in available_ids()
