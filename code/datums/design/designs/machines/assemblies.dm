/datum/design/machine_assembly
	abstract_type = /datum/design/machine_assembly
	work = 7.5 SECONDS

/datum/design/machine_assembly/cell_chargers
	identifier = "MachineAssemblyCellCharger"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/cell_charger_kit

/datum/design/machine_assembly/camera
	identifier = "MachineAssemblyCamera"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/camera_assembly
