// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/tether
	id = "Tether Relay"
	autolinkers = list("tether_relay")

// #### Hub ####
/obj/machinery/telecomms/hub/preset/tether
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"tether_relay", "c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/tether
//	id = "tether_rx"
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/broadcaster/preset_right/tether
//	id = "tether_tx"

/obj/machinery/telecomms/bus/preset_two/tether
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/tether
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "explorer")

// Telecommunications Satellite
/area/tether/surfacebase/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg')

/area/tether/surfacebase/tcomms/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/tether/surfacebase/tcomms/foyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"

/area/tether/surfacebase/tcomms/storage
	name = "\improper Telecomms Storage"
	icon_state = "tcomsatwest"

/area/tether/surfacebase/tcomms/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/tether/surfacebase/tcomms/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"

/area/maintenance/substation/tcomms
	name = "\improper Telecomms Substation"

/area/maintenance/station/tcomms
	name = "\improper Telecoms Maintenance"

/datum/map/tether/default_internal_channels()
	return list(
		num2text(PUB_FREQ) = list(),
		num2text(AI_FREQ)  = list(ACCESS_SPECIAL_SILICONS),
		num2text(ENT_FREQ) = list(),
		num2text(ERT_FREQ) = list(ACCESS_CENTCOM_ERT),
		num2text(COMM_FREQ)= list(ACCESS_COMMAND_BRIDGE),
		num2text(ENG_FREQ) = list(ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_ATMOS),
		num2text(MED_FREQ) = list(ACCESS_MEDICAL_EQUIPMENT),
		num2text(MED_I_FREQ)=list(ACCESS_MEDICAL_EQUIPMENT),
		num2text(SEC_FREQ) = list(ACCESS_SECURITY_EQUIPMENT),
		num2text(SEC_I_FREQ)=list(ACCESS_SECURITY_EQUIPMENT),
		num2text(SCI_FREQ) = list(ACCESS_SCIENCE_FABRICATION,ACCESS_SCIENCE_ROBOTICS,ACCESS_SCIENCE_XENOBIO),
		num2text(SUP_FREQ) = list(ACCESS_SUPPLY_BAY),
		num2text(SRV_FREQ) = list(ACCESS_GENERAL_JANITOR, ACCESS_GENERAL_BOTANY),
		num2text(EXP_FREQ) = list(ACCESS_GENERAL_EXPLORER)
	)

/obj/item/multitool/tether_buffered
	name = "pre-linked multitool (tether hub)"
	desc = "This multitool has already been linked to the Tether telecomms hub and can be used to configure one (1) relay."

/obj/item/multitool/tether_buffered/Initialize(mapload)
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/tether)
