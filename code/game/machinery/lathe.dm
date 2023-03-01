/obj/machinery/lathe
	abstract_type = /obj/machinery/lathe
	name = "lathe"
	#warn sprite including base_icon_state
	atom_flags = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000

	/// print speed - multiplier. affects power cost.
	var/speed_multiplier = 1
	/// power efficiency - multiplier. affects power cost.
	var/power_multiplier = 1
	/// material efficiency - multiplier.
	var/efficiency_multiplier = 1

	/// material holder datum
	var/datum/material_container/materials
	/// items held inside us, if any
	var/list/obj/item/items

	/// queued design ids
	var/list/queue
	/// processing queue?
	var/printing = FALSE
	/// progress in deciseconds on current design
	var/progress

/obj/machinery/lathe/Initialize(mapload)
	. = ..()
	create_storages()

/obj/machinery/lathe/Destroy()
	delete_storages()
	return ..()

/obj/machinery/lathe/proc/create_storages()
	#warn impl

/obj/machinery/lathe/proc/delete_storages()
	if(materials)
		QDEL_NULL(materials)
	if(reagents)
		QDEL_NULL(reagents)

/obj/machinery/lathe/proc/has_design(datum/design/id_or_instance)

/obj/machinery/lathe/proc/has_capabilities_for(datum/design/instance)

/obj/machinery/lathe/proc/has_resources_for(datum/design/instance)

/obj/machinery/lathe/proc/do_print(datum/design/instance)

#warn impl
