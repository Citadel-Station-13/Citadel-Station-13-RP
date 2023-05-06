/**
 * faction data for supply system (and only supply system)
 *
 * at most, we might hook trade pads (tbd) into this, but, keep "regular" faction stuff
 * out of this if at all possible.
 *
 * remember, composition is better than overriding everything everywhere.
 */
/datum/supply_faction
	/// id - unique, auto assign, non persistent, overridable
	var/id
	/// id next
	var/static/id_next = FIRST_ASCENDING_UID
	/// registered?
	var/registered = FALSE
	/// initialized?
	var/initalized = FALSE
	/// orderable? if not, we won't appear on supply consoles.
	var/orderable = TRUE
	/// name
	var/name = "Unknown Faction"
	/// destination
	var/tmp/assigned_destination
	/// normal singular-buy goodies: list(category = list(typepaths)). automatically translated into items.
	var/list/generate_normal_items
	/// contraband singular-buy goodies: list(category = list(typepaths)). automatically translated into items.
	var/list/generate_contraband_items
	/// supply_pack datums; list of typepaths, init'd on register.
	var/list/datum/supply_pack/packs = list()
	/// supply_item datums; list of typepaths, init'd on register.
	var/list/datum/supply_item/items = list()

/datum/supply_faction/New()
	STORE_AND_INCREMENT_ASCENDING_UID(id, id_next)

/datum/supply_faction/Destroy()
	if(registered)
		unregister()
	return ..()

/datum/supply_faction/proc/register()
	initialize()
	assigned_destination = SSsupply.request_destination()
	registered = TRUE
	return TRUE

/datum/supply_faction/proc/unregister()
	SSsupply.clear_destination(assigned_destination, src)
	registered = FALSE
	return TRUE

/datum/supply_faction/proc/initialize()
	initialized = TRUE
	var/list/packs = list()
	for(var/datum/supply_pack/thing as anything in src.packs)
		if(istype(thing))
			packs += thing
		else if(ispath(thing, /datum/supply_pack))
			packs += new thing
	src.packs = packs

	#warn init bounties
