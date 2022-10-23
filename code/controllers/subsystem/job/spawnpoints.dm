/datum/controller/subsystem/job
	/// All spawnpoints
	var/static/list/spawnpoints = list()
	/// Job spawnpoints keyed to job id/typepath
	var/static/list/job_spawnpoints = list()
	/// Generic latejoin spawnpoints, nested list faction = list()
	var/static/list/latejoin_spawnpoints = list()
	/// Generic overflow spawnpoints, nested list faction = list()
	var/static/list/overflow_spawnpoints = list()
	/// Custom spawnpoints, nested list key = list()
	var/static/list/custom_spawnpoints = list()

/**
 * Fully resets spawnpoints list and ensures validity
 */
/datum/controller/subsystem/job/proc/ReconstructSpawnpoints()
	spawnpoints = list()
	job_spawnpoints = list()
	latejoin_spawnpoints = list()
	overflow_spawnpoints = list()
	custom_spawnpoints = list()
	// O(2n) but sue me
	for(var/obj/landmark/spawnpoint/S in GLOB.landmarks_list)
		spawnpoints += S
	for(var/obj/landmark/spawnpoint/job/S in GLOB.landmarks_list)
		if(!S.job_path)
			continue
		LAZYDISTINCTADD(job_spawnpoints[S.job_path], S)
	for(var/obj/landmark/spawnpoint/latejoin/S in GLOB.landmarks_list)
		if(!S.faction)
			continue
		LAZYDISTINCTADD(latejoin_spawnpoints[S.faction], S)
	for(var/obj/landmark/spawnpoint/overflow/S in GLOB.landmarks_list)
		if(!S.faction)
			continue
		LAZYDISTINCTADD(latejoin_spawnpoints[S.faction], S)
	for(var/obj/landmark/spawnpoint/custom/S in GLOB.landmarks_list)
		if(!S.key)
			continue
		LAZYDISTINCTADD(custom_spawnpoints[S.key], S)

/**
 * Gets a valid spawnpoint to use for a roundstart spawn
 *
 * @params
 * - M - the mob being spawned
 * - C - (optional) the client of the player
 * - job_path - (optional) path to job
 * - faction - what faction the player is in terms of job factions
 * - random - deterministic first pick or random?
 * - harder - used when the first iteration failed, tells spawnpoints to skip certain checks
 *
 */
/datum/controller/subsystem/job/proc/GetRoundstartSpawnpoint(mob/M, client/C, job_path, faction, random = TRUE, harder = FALSE)
	RETURN_TYPE(/obj/landmark/spawnpoint)
	if(random)
		. = list()
	// Priority 1: Job specific spawnpoints
	if(job_path && length(job_spawnpoints[job_path]))
		for(var/obj/landmark/spawnpoint/job/J as anything in job_spawnpoints[job_path])
			if(!J.roundstart)
				continue
			if(!J.Available(M, C, harder))
				continue
			if(random)
				. += J
			else
				return J
	if(random && length(.))
		return pick(.)
	// Priority 2: Overflow spawnpoints as a last resort
	if(length(overflow_spawnpoints[faction]))
		for(var/obj/landmark/spawnpoint/overflow/S as anything in overflow_spawnpoints[faction])
			if(!S.Available(M, C, harder))
				continue
			if(random)
				. += S
			else
				return S
	if(random && length(.))
		return pick(.)
	if(!harder)
		subsystem_log("GetRoundstartSpawnpoint() failed to get a spawnpoint, trying against with harder = TRUE")
		return GetRoundstartSpawnpoint(M, C, job_path, faction, random, TRUE)
	else
		CRASH("GetRoundstartSpawnpoint() failed to get a spawnpoint.")

/**
 * Gets a spawnpoint to use for a latejoin spawn
 * Note that there's no mob argument, since latejoin won't make the mob until there's a free spawnpoint
 *
 * This is not a random pick, this is first priority-availability first server and fully deterministic.
 *
 * @params
 * - C - (optional) the client of the player
 * - job_path - (optional) path to job
 * - faction - what faction the player is in terms of job factions
 * - method - (optional) required method for the spawnpoint - this will make the proc return null instead of an overflow, if it can't find something for the method.
 * - random - deterministic first pick or random?
 * - harder - used when the first iteration failed, tells spawnpoints to skip certain checks
 */
/datum/controller/subsystem/job/proc/GetLatejoinSpawnpoint(client/C, job_path, faction = JOB_FACTION_STATION, method, random = TRUE, harder = FALSE)
	RETURN_TYPE(/obj/landmark/spawnpoint)
	if(random)
		. = list()	// Priority 1: Job specific spawnpoints
	if(job_path && length(job_spawnpoints[job_path]))
		for(var/obj/landmark/spawnpoint/job/J as anything in job_spawnpoints[job_path])
			if(!J.latejoin)
				continue
			if(!J.latejoin_override && method && (method != J.method))
				continue
			if(!J.Available(null, C, harder))
				continue
			if(random)
				. += J
			else
				return J
	if(random && length(.))
		return pick(.)
	// Priority 2: Latejoin spawnpoints, if latejoin
	if(length(latejoin_spawnpoints[faction]))
		for(var/obj/landmark/spawnpoint/latejoin/S as anything in latejoin_spawnpoints[faction])
			if(!S.Available(null, C, harder))
				continue
			if(method && (S.method != method))
				continue
			if(random)
				. += S
			else
				return S
	if(random && length(.))
		return pick(.)
	// Priority 3: Overflow spawnpoints as a last resort
	if(length(overflow_spawnpoints[faction]))
		for(var/obj/landmark/spawnpoint/overflow/S as anything in overflow_spawnpoints[faction])
			if(!S.Available(null, C, harder))
				continue
			if(random)
				. += S
			else
				return S
	if(random)
		if(length(.))
			return pick(.)
		else
			. = null
	if(!harder)
		subsystem_log("GetLatejoinSpawnpoint() failed to get a spawnpoint, trying against with harder = TRUE")
		return GetRoundstartSpawnpoint(C, job_path, faction, method, random, TRUE)
	else
		CRASH("GetLatejoinSpawnpoint() failed to get a spawnpoint.")

/**
 * Gets a list of possible join methods
 *
 * If latejoining and a job-specific spawnpoint has latejoin override, only that method will be returned
 *
 * The "harder" argument is automatically set to TRUE here, as we're checking for all possibilities.
 *
 * @params
 * - C - (optional) the client of the player
 * - job_path - (optional) path to job
 * - faction - what faction the player is in terms of job factions
 */
/datum/controller/subsystem/job/proc/PossibleLatejoinSpawnpoints(client/C, job_path, faction)
	. = list()
	// Get all job specific methods, and allow for override if needed
	if(job_path && length(job_spawnpoints[job_path]))
		for(var/obj/landmark/spawnpoint/job/J as anything in job_spawnpoints[job_path])
			if(!J.latejoin)
				continue
			if(J.latejoin_override)
				return list(J.method)
			if(J.Available(null, C, TRUE))
				continue
			. |= J.method
	// Get all standard latejoin methods
	if(length(latejoin_spawnpoints[faction]))
		for(var/obj/landmark/spawnpoint/latejoin/S as anything in latejoin_spawnpoints[faction])
			if(!S.Available(null, C, TRUE))
				continue
			. |= S.method
	// If there's none, add overflow method if overflow spawnpoints exist
	if(!length(.) && length(overflow_spawnpoints[faction]))
		for(var/obj/landmark/spawnpoint/overflow/S as anything in overflow_spawnpoints[faction])
			if(S.Available(null, C, TRUE))
				return list("Overflow")

/**
 * Gets a valid custom spawnpoint to use by key
 *
 * @params
 * - M - (optional) mob being spawned
 * - C - (optional) client of player
 * - key - spawnpoint key to look for
 */
/datum/controller/subsystem/job/proc/GetCustomSpawnpoint(mob/M, client/C, key)
	if(!length(custom_spawnpoints[key]))
		return
	for(var/obj/landmark/spawnpoint/S as anything in custom_spawnpoints[key])
		if(!S.Available(M, C))
			continue
		return S

/**
 * Get all spawnpoint landmarks
 */
/datum/controller/subsystem/job/proc/GetAllSpawnpoints()
	return spawnpoints
