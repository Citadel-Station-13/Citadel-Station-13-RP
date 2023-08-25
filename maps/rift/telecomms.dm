// ### Preset machines  ###

// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/rift/under_shallow
	id = "Underground Relay 1"
	autolinkers = list("rus_relay")

/obj/machinery/telecomms/relay/preset/centcom/rift/under_shallow

/obj/machinery/telecomms/relay/preset/rift/under_deep
	id = "Underground Relay 2"
	autolinkers = list("rud_relay")

/obj/machinery/telecomms/relay/preset/centcom/rift/under_deep

/obj/machinery/telecomms/relay/preset/rift/base_low
	id = "Base Relay 1"
	autolinkers = list("rbl_relay")

/obj/machinery/telecomms/relay/preset/centcom/rift/base_low

/obj/machinery/telecomms/relay/preset/rift/base_mid
	id = "Base Relay 2"
	autolinkers = list("rbm_relay")

/obj/machinery/telecomms/relay/preset/centcom/rift/base_mid

/obj/machinery/telecomms/relay/preset/rift/base_high
	id = "Base Relay 3"
	autolinkers = list("rbh_relay")

/obj/machinery/telecomms/relay/preset/centcom/rift/base_high

/obj/machinery/telecomms/hub/preset/rift
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"rus_relay", "rud_relay", "rbl_relay", "rbm_relay", "rbh_relay",
		"c_relay", "m_relay", "r_relay", "sci_o_relay", "ud_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/rift
//	id = "rift_rx"
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/broadcaster/preset_right/rift
//	id = "rift_tx"

/obj/machinery/telecomms/bus/preset_two/rift
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/rift
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "explorer")

// Telecommunications Satellite

/obj/item/multitool/rift_buffered
	name = "pre-linked multitool (rift hub)"
	desc = "This multitool has already been linked to the Atlas telecomms hub and can be used to configure one (1) relay."

/obj/item/multitool/rift_buffered/Initialize()
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/rift)
