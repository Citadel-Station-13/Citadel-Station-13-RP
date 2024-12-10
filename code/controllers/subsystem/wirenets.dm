SUBSYSTEM_DEF(wirenets)
	name = "Wirenets"
	init_order = INIT_ORDER_WIRENETS

	var/list/obj/structure/wire/rebuild_queued = list()
	var/rebuild_primed = FALSE
	var/rebuild_suspended = FALSE
	var/list/datum/wirenet/networks = list()

/datum/controller/subsystem/wirenets/Initialize()
	rebuild_wires()
	return ..()

/datum/controller/subsystem/wirenets/proc/queue_rebuild(obj/structure/wire/wire)
	if(!isnull(wire))
		rebuild_queued |= wire
	if(rebuild_primed)
		return
	rebuild_primed = TRUE
	// initialized check is here because initialization doesn't care if it's primed or not
	if(!initialized)
		return
	// ditto for rebuild suspends
	if(rebuild_suspended)
		return
	addtimer(CALLBACK(src, PROC_REF(rebuild_wires)), 0)

/datum/controller/subsystem/wirenets/proc/rebuild_wires()
	rebuild_primed = FALSE
	while(length(rebuild_queued))
		--rebuild_queued.len
		var/obj/structure/wire/W = rebuild_queued[length(rebuild_queued)]
		W.auto_rebuild()

/datum/controller/subsystem/wirenets/StartLoadingMap()
	. = ..()
	rebuild_suspended = TRUE

/datum/controller/subsystem/wirenets/StopLoadingMap()
	. = ..()
	rebuild_suspended = FALSE
	// todo: maybe this should be in init template bounds or whatever instead of here?
	rebuild_wires()

// todo: better mapload hook for initing
