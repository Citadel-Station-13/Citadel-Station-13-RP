SUBSYSTEM_DEF(wirenets)
	name = "Wirenets"
	init_order = INIT_ORDER_WIRENETS

	var/list/obj/structure/wire/rebuild_queued = list()
	var/rebuild_primed = FALSE
	var/list/datum/wirenet/networks = list()

/datum/controller/subsystem/wirenets/Initialize()
	rebuild_wires()
	return ..()

/datum/controller/subsystem/wirenets/proc/queue_rebuild(obj/structure/wire/wire)
	if(!isnull(wire))
		rebuild_queued |= wire
	#warn don't fire during maploading or init
	if(rebuild_primed)
		return
	rebuild_primed = TRUE
	addtimer(CALLBACK(src, PROC_REF(rebuild_wires)), 0)

/datum/controller/subsystem/wirenets/proc/rebuild_wires()
	rebuild_primed = FALSE
	while(length(rebuild_queued))
		--rebuild_queued.len
		var/obj/structure/wire/W = rebuild_queued[length(rebuild_queued)]
		W.auto_rebuild()

// todo: better mapload hook for initing
