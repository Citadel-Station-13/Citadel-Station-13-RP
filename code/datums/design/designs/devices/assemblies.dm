/datum/prototype/design/assembly
	abstract_type = /datum/prototype/design/assembly
	work = 2.5 SECONDS
	category = "Assemblies"

/datum/prototype/design/assembly/igniter
	id = "AseemblyIgniter"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/igniter

/datum/prototype/design/assembly/igniter/autodetect()
	pass()
	return ..()

/datum/prototype/design/assembly/signaler
	id = "AseemblySignaler"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/signaler

/datum/prototype/design/assembly/infrared
	id = "AseemblyInfrared"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/infra

/datum/prototype/design/assembly/timer
	id = "AseemblyTimer"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/timer

/datum/prototype/design/assembly/proximity
	id = "AseemblyProximity"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/prox_sensor

/datum/prototype/design/assembly/mousetrap
	id = "AseemblyMousetrap"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/mousetrap

/datum/prototype/design/assembly/voice
	id = "AseemblyVoice"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/assembly/voice

/datum/prototype/design/assembly/electropack
	id = "AseemblyElectropack"
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	build_path = /obj/item/radio/electropack
