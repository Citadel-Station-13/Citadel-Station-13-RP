/*
	The processor is a very simple machine that decompresses subspace signals and
	transfers them back to the original bus. It is essential in producing audible
	data.

	Link to servers if bus is not present
*/

/obj/machinery/telecomms/processor
	name = "Processor Unit"
	icon_state = "processor"
	desc = "This machine is used to process large quantities of information."
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	machinetype = 3
	delay = 5
	circuit = /obj/item/circuitboard/telecomms/processor
	var/process_mode = 1 // 1 = Uncompress Signals, 0 = Compress Signals

/obj/machinery/telecomms/processor/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/telecomms/processor/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	if(is_freq_listening(signal))

		if(process_mode)
			signal.data["compression"] = 0 // uncompress subspace signal
		else
			signal.data["compression"] = 100 // even more compressed signal

		if(istype(machine_from, /obj/machinery/telecomms/bus))
			relay_direct_information(signal, machine_from) // send the signal back to the machine
		else // no bus detected - send the signal to servers instead
			signal.data["slow"] += rand(5, 10) // slow the signal down
			relay_information(signal, "/obj/machinery/telecomms/server")
