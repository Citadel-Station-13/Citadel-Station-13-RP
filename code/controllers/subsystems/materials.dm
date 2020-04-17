#define FIRST_MATERIAL_PROCESS_STAGE			1
#define MATERIAL_PROCESS_STAGE_RADIATION		1

// all of the code in this file is admittedly pretty bad so if anyone knows how to improve it, it'd be nice.

SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = INIT_ORDER_MATERIALS
	priority = FIRE_PRIORITY_MATERIALS
	wait = 10

	/// Master list of every material datum in the game, indexed by its id.
	var/list/materials_by_id

	var/current_stage = MATERIAL_PROCESS_STAGE_RADIATION
	var/fire_start_stage

	var/list/processing_list_radioactive = list()

	var/list/currentrun = list()


/datum/controller/subsystem/materials/Initialize()
	initialize_materials()
	return ..()

/datum/controller/subsystem/materials/proc/initialize_materials(clear)
	if(clear)
		materials_by_id = list()
	else
		LAZYINITLIST(materials_by_id)
	for(var/path in subtypesof(/datum/material))
		var/datum/material/M = path
		if(!initial(M.autoinit))
			continue
		if(initial(M.abstract_type) == path)
			continue
		M = new path
		if(materials_by_id[M.id])
			stack_trace("Material ID collision with [M] at ID [M.id].")
			continue
		materials_by_id[M.id] = M

/**
  * Gets a material by its unique ID or typepath.
  */
/datum/controller/subsystem/materials/proc/material_by_id(id)
	return materials_by_id["[id]"]		//important - if a path was specified, this turns it into a text id.

/**
  * Gets a material's display name by its unique ID or typepath.
  */
/datum/controller/subsystem/materials/proc/material_name_by_id(id)
	var/datum/material/M = material_by_id(id)
	return M?.display_name

/datum/controller/subsystem/materials/fire(resumed)
	fire_start_stage = current_stage
	process_chain()

/datum/controller/subsystem/materials/proc/process_chain()
	switch(current_stage)
		if(MATERIAL_PROCESS_STAGE_RADIATION)
			process_radioactive(resumed)

/datum/controller/subsystem/materials/proc/next_stage()
	switch(current_stage)
		if(MATERIAL_PROCESS_STAGE_RADIATION)
			current_stage = MATERIAL_PROCESS_STAGE_RADIATION		//obviously expand this as you go.
	if(current_stage != fire_start_stage)		//we didn't completely loop and the last time we did a process proc MC_TICK_CHECK didn't interrupt us
		fire(FALSE)			//proceed to next stage

/datum/controller/subsystem/materials/proc/add_radioactive_item(datum/D)
	processing_list_radioactive |= D
	if(stage == MATERIAL_PROCESS_STAGE_RADIATION)
		currentrun += D

/datum/controller/subsystem/materials/proc/process_radioactive(resumed)
	if(!resumed)
		currentrun = processing_list_radioactive.Copy()
	while(length(currentrun))
		var/datum/D = currentrun[1]
		currentrun.Cut(1, 2)
		if(D.standard_material_process_radioactive() == PROCESS_KILL)
			processing_list_radioactive -= D
		if(MC_TICK_CHECK)
			return
	// we're done, move to next stage
	next_stage()

/datum/proc/standard_material_process_radioactive()
	return PROCESS_KILL
