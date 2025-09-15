/**
 * playtime tracking system
 *
 * yes, the code is messy and probably shouldn't be half-in-subsystem and half-elsewhere, buuut
 * whatever.
 *
 * todo: this can probably be optimized to be better at yielding instead of using dumb CHECK_TICKS.
 */
SUBSYSTEM_DEF(playtime)
	name = "Playtime"
	wait = 10 MINUTES
	subsystem_flags = SS_NO_TICK_CHECK | SS_NO_INIT

/datum/controller/subsystem/playtime/Shutdown()
	flush_playtimes()
	return ..()

/datum/controller/subsystem/playtime/fire(resumed)
	for(var/client/C in GLOB.clients)
		if(!C.initialized)
			continue
		queue_playtimes(C)
		CHECK_TICK
	flush_playtimes()

/datum/controller/subsystem/playtime/proc/flush_playtimes()
	if(!SSdbcore.Connect())
		return
	// admin proccall guard override - there's no volatile args here
	var/old_usr = usr
	usr = null
	. = flush_playtimes_impl()
	usr = old_usr

/datum/controller/subsystem/playtime/proc/flush_playtimes_impl()
	var/list/built = list()
	for(var/client/C in GLOB.clients)
		if(!C.initialized)
			continue
		var/playerid = C.player.player_id
		for(var/roleid in C.persistent.playtime_queued)
			var/minutes = C.persistent.playtime_queued[roleid]
			built[++built.len] = list(
				"roleid" = roleid,
				"minutes" = minutes,
				"player" = playerid
			)
			C.persistent.playtime[roleid] += minutes
		C.persistent.playtime_queued = list()
	SSdbcore.MassInsertLegacy(DB_PREFIX_TABLE_NAME("playtime"), built, duplicate_key = "ON DUPLICATE KEY UPDATE minutes = minutes + VALUES(minutes)")

/**
 * returns a list of playtime roles
 */
/datum/controller/subsystem/playtime/proc/playtime_for(mob/M)
	if(isobserver(M))
		var/mob/observer/dead/ghost = M
		return list(ghost.started_as_observer? PLAYER_PLAYTIME_OBSERVER : PLAYER_PLAYTIME_DEAD)
	else if(isnewplayer(M))
		return list(PLAYER_PLAYTIME_LOBBY)
	if(IS_DEAD(M))
		. = list(PLAYER_PLAYTIME_DEAD)
	else
		. = list(PLAYER_PLAYTIME_LIVING)
		var/best_effort_attempt_at_resolving_legacy_name_based_roles = M.mind?.assigned_role
		var/datum/role/job/J = SSjob.job_by_title(best_effort_attempt_at_resolving_legacy_name_based_roles)
		if(J)
			. += PLAYER_PLAYTIME_ROLE(J.id)

/datum/controller/subsystem/playtime/proc/queue_playtimes(client/C)
	set waitfor = FALSE
	queue_playtimes_sync(C)

/datum/controller/subsystem/playtime/proc/queue_playtimes_sync(client/C)
	if(isnull(C))
		return
	if(!C.initialized)
		CRASH("how was this called on an uninitialized client?")
	if(!SSdbcore.Connect())
		return
	var/list/playtimes = playtime_for(C.mob)
	var/now = REALTIMEOFDAY
	// deciseconds to minutes
	var/since_last = round((now - C.persistent.playtime_last) * (1 / 10) * (1 / 60))
	C.persistent.playtime_last = now
	if(since_last < 0)
		CRASH("how was since_last [since_last] < 0?")
	if(!length(playtimes))
		return
	LAZYINITLIST(C.persistent.playtime_queued)
	for(var/role in playtimes)
		C.persistent.playtime_queued[role] += since_last
