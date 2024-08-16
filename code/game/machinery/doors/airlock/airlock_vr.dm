/obj/machinery/door/airlock/glass_external/public
	req_one_access = list()

/obj/machinery/door/airlock/alien/blue
	name = "hybrid airlock"
	desc = "You're fairly sure this is a door."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock)
	icon = 'icons/obj/doors/alien/door_blue.dmi'
	bolts_file = 'icons/obj/doors/alien/lights_bolts_blue.dmi'
	lights_file = 'icons/obj/doors/alien/lights_green_blue.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	hackProof = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_alien
	req_one_access = list()

/obj/machinery/door/airlock/alien/blue/locked
	locked = TRUE

/obj/machinery/door/airlock/alien/blue/public // Entry to UFO.
	req_one_access = list()
	normalspeed = FALSE // So it closes faster and hopefully keeps the warm air inside.
	hackProof = TRUE // No borgs

/obj/machinery/door/airlock/glass/security/polarized
	name = "Electrochromic Security Airlock"

/obj/machinery/door/airlock/glass/medical/polarized
	name = "Electrochromic Medical Airlock"

/obj/machinery/door/airlock/glass/command/polarized
	name = "Electrochormic Command Airlock"
