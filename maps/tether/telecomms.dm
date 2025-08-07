/obj/machinery/telecomms/relay/preset/tether
	id = "Tether Relay"
	autolinkers = list("tether_relay")

/obj/machinery/telecomms/hub/preset/tether
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"tether_relay", "c_relay", "m_relay", "r_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/tether
	freq_listening = list(FREQ_AI_PRIVATE, FREQ_SCIENCE, FREQ_MEDICAL, FREQ_SUPPLY, FREQ_SERVICE, FREQ_COMMAND, FREQ_ENGINEERING, FREQ_SECURITY, FREQ_ENTERTAINMENT, FREQ_EXPLORER)

/obj/machinery/telecomms/broadcaster/preset_right/tether

/obj/machinery/telecomms/bus/preset_two/tether
	freq_listening = list(FREQ_SUPPLY, FREQ_SERVICE, FREQ_EXPLORER)

/obj/machinery/telecomms/server/presets/service/tether
	freq_listening = list(FREQ_SERVICE, FREQ_EXPLORER)
	autolinkers = list("service", "explorer")

/obj/item/multitool/tether_buffered
	name = "pre-linked multitool (tether hub)"
	desc = "This multitool has already been linked to the Tether telecomms hub and can be used to configure one (1) relay."

/obj/item/multitool/tether_buffered/Initialize(mapload)
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/tether)
