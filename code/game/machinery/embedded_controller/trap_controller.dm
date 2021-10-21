//a docking port that uses a single door
/obj/machinery/embedded_controller/radio/trap_controller
	name = "strange mechanism controller"
	radio_filter = RADIO_TRAP
	program = /datum/computer/file/embedded_program/trap
	var/tag_trap
	var/tag_trigger
	valid_actions = list("trip")

/obj/machinery/embedded_controller/radio/trap/Destroy()
	return ..()

//THe controller program for traps? I hope?
/datum/computer/file/embedded_program/trap
	var/tag_trap

/datum/computer/file/embedded_program/trap/New(var/obj/machinery/embedded_controller/M)
	..(M)
	memory["trap_status"] = list(state = "set")

	if (istype(M, /obj/machinery/embedded_controller/radio/trap_controller))
		var/obj/machinery/embedded_controller/radio/trap_controller/controller = M

		tag_trap = controller.tag_trap? controller.tag_trap : "[id_tag]_trap"

		spawn(10)
			signal_trap("update")


/datum/computer/file/embedded_program/trap/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]

	if(!receive_tag) return

	if(receive_tag==tag_trap)
		memory["trap_status"]["state"] = signal.data["trap_status"]

	..(signal, receive_method, receive_param)

/datum/computer/file/embedded_program/trap/proc/signal_trap(var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = tag_trap
	signal.data["command"] = command
	post_signal(signal)

/datum/computer/file/embedded_program/trap/proc/open_door()
	if(memory["trap_status"]["state"] == "set")
		signal_trap("trip")
	else if(memory["door_status"]["state"] == "tripped")
		return
