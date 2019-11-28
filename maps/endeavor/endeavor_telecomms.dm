/obj/machinery/telecomms/relay/preset/endeavor/one
	id = "Endeavor Deck 1 Relay"
	listening_level = Z_LEVEL_ENDEAVOR_ONE
	autolinkers = list("end_1_relay")

/obj/machinery/telecomms/relay/preset/endeavor/two
	id = "Endeavor Deck 2 Relay"
	listening_level = Z_LEVEL_ENDEAVOR_TWO
	autolinkers = list("end_2_relay")

/obj/machinery/telecomms/relay/preset/endeavor/three
	id = "Endeavor Deck 3 Relay"
	listening_level = Z_LEVEL_ENDEAVOR_THREE
	autolinkers = list("end_3_relay")

/obj/machinery/telecomms/relay/preset/endeavor/four
	id = "Endeavor Deck 4 Relay"
	listening_level = Z_LEVEL_ENDEAVOR_FOUR
	autolinkers = list("end_4_relay")

/obj/machinery/telecomms/relay/preset/endeavor/five
	id = "Endeavor Deck 5 Relay"
	listening_level = Z_LEVEL_ENDEAVOR_FIVE
	autolinkers = list("end_5_relay")

/obj/machinery/telecomms/relay/preset/endeavor/mining_high
	id = "Asteroid Surface Relay"
	listening_level = Z_LEVEL_MINING_HIGH
	autolinkers = list("mining_high")
//Might not use this one, i dunno
/obj/machinery/telecomms/relay/preset/endeavor/mining_low
	id = "Asteroid Interior Relay"
	listening_level = Z_LEVEL_MINING_HIGH
	autolinkers = list("mining_low")

/obj/machinery/telecomms/hub/preset/endeavor
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"end_1_relay", "end_2_relay", "end_3_relay", "end_4_relay", "end_5_relay", "mining_high", "mining_low",
		"c_relay", "m_relay", "r_relay", "sci_o_relay", "ud_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/endeavor
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/bus/preset_two/endeavor
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/endeavor
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "explorer")

/datum/map/endeavor/default_internal_channels()
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

/obj/item/device/multitool/endeavor_buffered
	name = "pre-linked multitool (Endeavor hub)"
	desc = "This multitool has already been linked to the Endeavor telecomms hub and can be used to configure one (1) relay."

/obj/item/device/multitool/endeavor_buffered/Initialize()
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/endeavor)
