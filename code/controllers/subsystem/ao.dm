SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	wait = 0
	init_order = INIT_ORDER_MISC_LATE
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	subsystem_flags = SS_HIBERNATE | SS_NO_INIT

	var/idex = 1
	var/list/turf/queue = list()
	var/list/image_cache = list()

/datum/controller/subsystem/ao/PreInit()
	. = ..()
	hibernate_checks = list(
		NAMEOF(src, queue),
	)

/datum/controller/subsystem/ao/stat_entry(msg)
	msg += "P:[length(queue)]"
	return ..()

/datum/controller/subsystem/ao/Initialize(start_timeofday)
	fire(FALSE, TRUE)
	..()

/datum/controller/subsystem/ao/fire(resumed = 0, no_mc_tick = FALSE)
	if (!resumed)
		idex = 1

	var/list/curr = queue
	while (idex <= curr.len)
		var/turf/target = curr[idex]
		idex += 1

		if (!QDELETED(target))
			if (target.ao_queued == AO_UPDATE_REBUILD)
				var/old_n = target.ao_junction
				var/old_z = target.ao_junction_mimic
				target.calculate_ao_junction()
				if (old_n != target.ao_junction || old_z != target.ao_junction_mimic)
					target.update_ao()
			else
				target.update_ao()
			target.ao_queued = AO_UPDATE_NONE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (idex > 1)
		curr.Cut(1, idex)
		idex = 1

/datum/controller/subsystem/ao/StartLoadingMap()
	can_fire = FALSE
	return ..()

/datum/controller/subsystem/ao/StopLoadingMap()
	can_fire = TRUE
	return ..()
