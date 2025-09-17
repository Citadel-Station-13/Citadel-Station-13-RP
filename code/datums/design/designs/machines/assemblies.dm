/datum/prototype/design/machine_assembly
	abstract_type = /datum/prototype/design/machine_assembly
	work = 7.5 SECONDS
	category = "General"

/datum/prototype/design/machine_assembly/cell_chargers
	id = "MachineAssemblyCellCharger"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/cell_charger_kit

/datum/prototype/design/machine_assembly/camera
	id = "MachineAssemblyCamera"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/camera_assembly
