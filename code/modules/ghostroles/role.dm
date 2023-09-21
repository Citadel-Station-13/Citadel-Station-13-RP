GLOBAL_LIST_INIT(ghostroles, init_ghostroles())

/proc/init_ghostroles()
	. = list()
	for(var/path in subtypesof(/datum/role/ghostrole))
		var/datum/role/ghostrole/G = path
		if(initial(G.abstract_type) == path)
			continue
		if(initial(G.lazy_init))
			continue
		.[path] = new path

/**
 * This intentionally supports strings for badmin purposes.
 */
/proc/get_ghostrole_datum(path)
	if(GLOB.ghostroles[path])
		return GLOB.ghostroles[path]
	var/is_this_a_path = ispath(path)? path : text2path(path)
	if(ispath(is_this_a_path, /datum/role/ghostrole))
		GLOB.ghostroles[is_this_a_path] = new is_this_a_path
		return GLOB.ghostroles[is_this_a_path]

/**
 * Ghostrole datums
 */
/datum/role/ghostrole
	/// Abstract type.
	abstract_type = /datum/role/ghostrole

	/// name
	var/name = "Unnamed Role"
	/// **short** description - use spawntext for long one.
	var/desc = "Wow, a coder fucked up."
	/// init on server load or only when needed
	var/lazy_init = TRUE
	/// allow selecting the spawner, or random? **If the spawner gets clicked by a player, they can still spawn from it!**
	var/allow_pick_spawner = FALSE
	/// /datum/ghostrole_instantiator - handles mob creation, equip, and transfer. DOES NOT greet the ghostrole with role information.
	var/datum/ghostrole_instantiator/instantiator
	/// spawn count
	var/spawns = 0
	/// max spawns
	var/slots = INFINITY
	/// default message to show on greet(), also shows in spawners menu.
	var/spawntext
	/// important rules/policy info
	var/important_info
	/// should we show the standard ghostrole greeting?
	var/show_standard_greeting = TRUE
	/// spawnerless - advanced users only. This isn't for "load in spawners in PreInstantiate()", this is for true spawnpoint-less ghostroles.
	var/spawnerless = FALSE
	/// assigned role. defaults to name.
	var/assigned_role
	/// jobban name/id, if any
	var/jobban_role
	/// Automatically give them an objective and custom antag datum
	var/automatic_objective
	/// inject params during spawning
	var/list/inject_params

/datum/role/ghostrole/New(_id)
	if(ispath(instantiator, /datum/ghostrole_instantiator))
		instantiator = new instantiator
	id = _id || type

/datum/role/ghostrole/proc/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	if(show_standard_greeting)
		to_chat(created, "<blockquote class='info'>You have spawned as a ghostrole. These roles should be taken seriously. Be sure to follow the directives in your spawntext (if any), as well as the server rules. Beyond that, roleplay your character however you see fit! Spawntext as follows;</blockquote>")
	if(spawntext)
		to_chat(created, "<blockquote class='info'>[spawntext]</blockquote>")
	if(spawnpoint.spawntext)
		to_chat(created, "<blockquote class='info'>[spawntext]</blockquote>")

/datum/role/ghostrole/proc/ImportantInfo(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	if(important_info)
		to_chat(created, "<blockquote class='info'>[important_info]</blockquote>")

/**
 * Master proc for spawning someone as this role.
 *
 * Return TRUe on success, or a string of why it failed.
 */
/datum/role/ghostrole/proc/AttemptSpawn(client/C, datum/component/ghostrole_spawnpoint/chosen_spawnpoint)
	if(C.persistent.ligma)
		log_shadowban("[key_name(C)] ghostrole join as [id] ([type]) blocked.")
		return "BUG: No instantiator for [src][(id !=type) && ":[id]"] ([type])"
	if(BanCheck(C))
		return "You can't spawn as [src] due to an active job-ban."
	if(!AllowSpawn(C))
		return "You can't spawn as this role; Try refreshing the ghostrole/join menu."
	if(!PreInstantiate(C))
		return "PreInstantiate() failed."
	var/datum/component/ghostrole_spawnpoint/spawnpoint = spawnerless? null : (chosen_spawnpoint || GetSpawnpoint(C))
	var/list/params = islist(spawnpoint?.params)? spawnpoint.params.Copy() : list()		// clone/new, because procs CAN MODIFY THIS.
	if(inject_params)
		params |= inject_params
	if(!AllowSpawn(C, params))		// check again with params
		return "The spawnpoint refused to let you spawn."
	var/atom/location = GetSpawnLoc(C, spawnpoint)
	if(!location)
		return "Couldn't get a spawn location."
	if(!instantiator)
		return "BUG: No instantiator for [src][(id !=type) && ":[id]"] ([type])"
	var/mob/created = Instantiate(C, location, params)
	if(!created)
		return "Mob instantiation failed."
	if(!Transfer(C, created))
		qdel(created)
		return "Mob transfer failed."
	PostInstantiate(created, spawnpoint, params)
	// GLOB.join_menu.queue_update()
	GLOB.ghostrole_menu.queue_update()
	return TRUE

/datum/role/ghostrole/proc/Instantiate(client/C, atom/loc, list/params)
	var/mob/living/L = instantiator.Run(C, loc, params)
	. = istype(L) && L
	if(.)
		L.mind?.assigned_role = assigned_role || name

/datum/role/ghostrole/proc/Transfer(client/C, mob/created)
	if(!isnewplayer(C.mob))
		C.mob.ghostize(TRUE, TRUE)
	created.ckey = C.ckey
	return TRUE

/**
 * Ran before anything else is at AttemptSpawn()
 */
/datum/role/ghostrole/proc/PreInstantiate(client/C)
	return TRUE

/**
 * Checks if the client is a valid user mob and if we can allow a spawn from them
 */
/datum/role/ghostrole/proc/AllowSpawn(client/C, list/params)
	if(!isobserver(C.mob) && !isnewplayer(C.mob))
		return FALSE
	if(SpawnsLeft(C) <= 0)
		return FALSE
	return TRUE

/datum/role/ghostrole/proc/SpawnsLeft(client/C)
	if(spawnerless)
		return max(0, slots - spawns)
	return min(max(0, slots - spawns), TallySpawnpointSlots(C))

/datum/role/ghostrole/proc/TallySpawnpointSlots(client/C)
	var/list/datum/component/ghostrole_spawnpoint/spawnpoints = GLOB.ghostrole_spawnpoints[id]
	. = 0
	for(var/datum/component/ghostrole_spawnpoint/S as anything in spawnpoints)
		. += S.SpawnsLeft(C)

/**
 * Gets a spawnpoint for a client
 *
 * For spawnerless ghostroles, return null.
 */
/datum/role/ghostrole/proc/GetSpawnpoint(client/C)
	if(!allow_pick_spawner)
		return SAFEPICK(GLOB.ghostrole_spawnpoints[id])
	var/list/datum/component/ghostrole_spawnpoint/spawnpoints = GLOB.ghostrole_spawnpoints[id]
	var/list/inputlist = list()
	for(var/datum/component/ghostrole_spawnpoint/spawnpoint as anything in spawnpoints)
		var/atom/A = spawnpoint.Atom()
		inputlist["[A] - [get_area(A)]"] = spawnpoint
	var/picked = tgui_input_list(C.mob, "Spawner Selection", inputlist)
	return inputlist[picked]

/**
 * Gets a spawn location for a client.
 *
 * spawnpoint can be null for spawnerless ghostroles.
 */
/datum/role/ghostrole/proc/GetSpawnLoc(client/C, datum/component/ghostrole_spawnpoint/spawnpoint)
	return spawnpoint?.Turf()

/**
 * Spawnpoint can be null here, if we're not using a spawnpoint
 */
/datum/role/ghostrole/proc/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	Greet(created, spawnpoint, params)
	ImportantInfo(created, spawnpoint, params)
	if(automatic_objective)
		GiveCustomObjective(created, automatic_objective)
	spawns++
	spawnpoint?.OnSpawn(created, src)
	instantiator.AfterSpawn(created, params)

/**
 * Ban check.
 */
/datum/role/ghostrole/proc/BanCheck(client/C)
	if(!jobban_role)
		return FALSE
	return jobban_isbanned(C.mob, jobban_role)

/datum/role/ghostrole/proc/GiveCustomObjective(mob/created, objective)
	created.GhostroleGiveCustomObjective(src, objective)

/mob/proc/GhostroleGiveCustomObjective(datum/role/ghostrole/R, objective)
	if(!mind)
		mind_initialize()
	if(!mind)
		CRASH("No mind.")

	store_memory("OBJECTIVE: [objective]", TRUE)
	to_chat(src, SPAN_DANGER("An objective has been added to you by your ghostrole spawner. Remember that roleplay comes first - these are often freeform. Said objective is in your MEMORIES, due to the codebase lacking datum antagonists."))

	// TODO: DATUM ANTAGS
	// var/datum/antagonist/custom/A = mind.has_antag_datum(/datum/antagonist/custom) || mind.add_antag_datum(/datum/antagonist/custom)
	// if(!A)
	// 	CRASH("Failed to locate/make custom antagonist datum.")
	// var/datum/objective/O = new(objective)
	// O.owner = mind
	// A.objectives += O

//to hold "existing" ghostroles, roles that allow ghosts to take control of mobs already existing
/datum/role/ghostrole/existing
	name = "Playable Mob"
	desc = "Some badmin or coder is fucking with procs, probably. A mob's controllable if you want it though."
	instantiator = /datum/ghostrole_instantiator/existing

/datum/role/ghostrole/existing/Instantiate(client/C, atom/loc, list/params)
	if(!istype(instantiator,/datum/ghostrole_instantiator/existing))
		CRASH("ghostrole/existing must have an /existing instantiator")
	if(params["mob"])
		var/datum/ghostrole_instantiator/existing/E = instantiator
		E.existing_mob = params["mob"]
	else
		CRASH("mob parameter must exist")

	return ..()
