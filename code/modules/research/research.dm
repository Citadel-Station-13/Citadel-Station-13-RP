/*
General Explination:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to manipulate it. It has four variables and seven procs:

Variables:
- possible_tech is a list of all the /datum/tech that can potentially be researched by the player. The RefreshResearch() proc
(explained later) only goes through those when refreshing what you know. Generally, possible_tech contains ALL of the existing tech
but it is possible to add tech to the game that DON'T start in it (example: Xeno tech). Generally speaking, you don't want to mess
with these since they should be the default version of the datums. They're actually stored in a list rather then using typesof to
refer to them since it makes it a bit easier to search through them for specific information.
- know_tech is the companion list to possible_tech. It's the tech you can actually research and improve. Until it's added to this
list, it can't be improved. All the tech in this list are visible to the player.
- possible_designs is functionally identical to possbile_tech except it's for /datum/prototype/design.
- known_designs is functionally identical to known_tech except it's for /datum/prototype/design

Procs:
- TechHasReqs: Used by other procs (specifically RefreshResearch) to see whether all of a tech's requirements are currently in
known_tech and at a high enough level.
- DesignHasReqs: Same as TechHasReqs but for /datum/prototype/design and known_design.
- AddTech2Known: Adds a /datum/tech to known_tech. It checks to see whether it already has that tech (if so, it just replaces it). If
it doesn't have it, it adds it. Note: It does NOT check possible_tech at all. So if you want to add something strange to it (like
a player made tech?) you can.
- AddDesign2Known: Same as AddTech2Known except for /datum/prototype/design and known_designs.
- RefreshResearch: This is the workhorse of the R&D system. It updates the /datum/research holder and adds any unlocked tech paths
and designs you have reached the requirements for. It only checks through possible_tech and possible_designs, however, so it won't
accidentally add "secret" tech to it.
- UpdateTech is used as part of the actual researching process. It takes an ID and finds techs with that same ID in known_tech. When
it finds it, it checks to see whether it can improve it at all. If the known_tech's level is less then or equal to
the inputted level, it increases the known tech's level to the inputted level -1 or know tech's level +1 (whichever is higher).

The tech datums are the actual "tech trees" that you improve through researching. Each one has five variables:
- Name:		Pretty obvious. This is often viewable to the players.
- Desc:		Pretty obvious. Also player viewable.
- ID:		This is the unique ID of the tech that is used by the various procs to find and/or maniuplate it.
- Level:	This is the current level of the tech. All techs start at 1 and have a max of 20. Devices and some techs require a certain
level in specific techs before you can produce them.
- Req_tech:	This is a list of the techs required to unlock this tech path. If left blank, it'll automatically be loaded into the
research holder datum.

*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/

///Holder for all the existing, archived, and known tech. Individual to console.
/datum/research
	///List of locally known tech. Datum/tech go here.
	var/list/known_tech = list()

	/// do we bother populating designs?
	var/stores_designs = TRUE
	/// list of known design IDs
	var/list/known_design_ids

/datum/research/New() //Insert techs into possible_tech here. Known_tech automatically updated.
	if(stores_designs)
		known_design_ids = list()
	for(var/T in typesof(/datum/tech) - /datum/tech)
		known_tech += new T(src)
	RefreshResearch()

/datum/research/Destroy()
	known_design_ids = null
	known_tech = null
	return ..()

/datum/research/proc/debug_max_out()
	for(var/datum/tech/tech in known_tech)
		tech.level = 40
	RefreshResearch()

/datum/research/techonly
	stores_designs = FALSE


/datum/research/proc/legacy_all_design_datums()
	return RSdesigns.fetch_multi(known_design_ids)

///Checks to see if design has all the required pre-reqs.
///Input: datum/prototype/design; Output: 0/1 (false/true)
/datum/research/proc/DesignHasReqs(var/datum/prototype/design/D)
	if(!(D.design_unlock & DESIGN_UNLOCK_TECHLEVEL))
		return FALSE
	if(!LAZYLEN(D.req_tech))
		return TRUE

	var/list/k_tech = list()
	for(var/datum/tech/known in known_tech)
		k_tech[known.id] = known.level

	for(var/req in D.req_tech)
		if(isnull(k_tech[req]) || (k_tech[req] < D.req_tech[req]))
			return FALSE
	return TRUE

///Adds a tech to known_tech list. Checks to make sure there aren't duplicates and updates existing tech's levels if needed.
///Input: datum/tech; Output: Null
/datum/research/proc/AddTech2Known(var/datum/tech/T)
	for(var/datum/tech/known in known_tech)
		if(T.id == known.id)
			if(T.level > known.level)
				known.level = T.level

/datum/research/proc/AddDesign2Known(var/datum/prototype/design/D)
	if(!stores_designs)
		return
	known_design_ids |= D.id

///Refreshes known_tech and known_designs list
///Input/Output: n/a
/datum/research/proc/RefreshResearch()
	if(stores_designs)
		for(var/datum/prototype/design/PD in RSdesigns.fetch_subtypes_immutable(/datum/prototype/design))
			if(DesignHasReqs(PD))
				AddDesign2Known(PD)
	for(var/datum/tech/T in known_tech)
		T.level = clamp( T.level, 0,  20)

///Refreshes the levels of a given tech.
///Input: Tech's ID and Level; Output: null
/datum/research/proc/UpdateTech(var/ID, var/level)
	for(var/datum/tech/KT in known_tech)
		if(KT.id == ID && KT.level <= level)
			KT.level = max(KT.level + 1, level - 1)

///A simple helper proc to find the name of a tech with a given ID.
/proc/CallTechName(var/ID)
	for(var/T in subtypesof(/datum/tech))
		var/datum/tech/check_tech = T
		if(initial(check_tech.id) == ID)
			return initial(check_tech.name)
