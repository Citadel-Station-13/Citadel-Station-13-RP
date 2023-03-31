/**
 * delayed procedure call, equivalent to addtimer 0
 */
SUBSYSTEM_DEF(dpc)
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// are we queued?
	var/primed = FALSE
	/// targets - we do not check for qdels!
	var/list/targets = list()

/datum/controller/subsystem/dpc/proc/queue_invoke(datum/target, procpath/callpath, ...)
	targets[++targets.len] = args.Copy()
	if(!primed)
		prime()

/datum/controller/subsystem/dpc/proc/prime()
	ASSERT(!primed)
	primed = TRUE
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/dpc, invoke_calls)), 0)

/datum/controller/subsystem/dpc/proc/invoke_calls()
	primed = FALSE
	for(var/list/targlist as anything in targets)
		call(targlist[1], targlist[2])(arglist(targlist.Copy(3)))
	targets.len = 0
