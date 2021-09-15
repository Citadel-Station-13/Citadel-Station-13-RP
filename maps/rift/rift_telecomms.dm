// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/rift/under_shallow
	id = "Underground Relay 1"
	listening_level = Z_LEVEL_UNDERGROUND
	autolinkers = list("rus_relay")

/obj/machinery/telecomms/relay/preset/rift/under_deep
	id = "Underground Relay 2"
	listening_level = Z_LEVEL_UNDERGROUND_DEEP
	autolinkers = list("rud_relay")

/obj/machinery/telecomms/relay/preset/rift/base_low
	id = "Base Relay 1"
	listening_level = Z_LEVEL_SURFACE_LOW
	autolinkers = list("rbl_relay")

/obj/machinery/telecomms/relay/preset/rift/base_mid
	id = "Base Relay 2"
	listening_level = Z_LEVEL_SURFACE_MID
	autolinkers = list("rbm_relay")
/*
/obj/machinery/telecomms/relay/preset/tether/sci_outpost
	id = "Science Outpost Relay"
	listening_level = Z_LEVEL_SOLARS
	autolinkers = list("sci_o_relay")

/obj/machinery/telecomms/relay/preset/underdark
	id = "Mining Underground Relay"
	listening_level = Z_LEVEL_UNDERDARK
	autolinkers = list("ud_relay")
*/
// #### Hub ####
/obj/machinery/telecomms/hub/preset/rift
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"rbl_relay", "rbm_relay",
		"c_relay", "m_relay", "r_relay", "sci_o_relay", "ud_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/rift
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/bus/preset_two/rift
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/rift
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
	flags = BLUE_SHIELDED

/area/maintenance/substation/tcomms
	name = "\improper Telecomms Substation"

/area/maintenance/station/tcomms
	name = "\improper Telecoms Maintenance"

/datum/map/tether/default_internal_channels()
	return list(
		num2text(PUB_FREQ) = list(),
		num2text(AI_FREQ)  = list(access_synth),
		num2text(ENT_FREQ) = list(),
		num2text(ERT_FREQ) = list(access_cent_specops),
		num2text(COMM_FREQ)= list(access_heads),
		num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ) = list(access_medical_equip),
		num2text(MED_I_FREQ)=list(access_medical_equip),
		num2text(SEC_FREQ) = list(access_security),
		num2text(SEC_I_FREQ)=list(access_security),
		num2text(SCI_FREQ) = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ) = list(access_cargo),
		num2text(SRV_FREQ) = list(access_janitor, access_hydroponics),
		num2text(EXP_FREQ) = list(access_explorer)
	)

/obj/item/device/multitool/rift_buffered
	name = "pre-linked multitool (rift hub)"
	desc = "This multitool has already been linked to the Atlas telecomms hub and can be used to link multiple machines to the hub, including relays." //cit edit - it's not one use

/obj/item/multitool/tether_buffered/Initialize()
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/rift)
