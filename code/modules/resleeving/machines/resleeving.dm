/obj/machinery/resleeving
	name = "resleeving machinery"
	desc = "Some kind of machinery for the Vey-Med Trans-Human Resleeving System."
	#warn sprite

	var/obj/machinery/computer/resleeving/linked_console

/obj/machinery/resleeving/Destroy()
	unlink_console()
	return ..()

/obj/machinery/resleeving/proc/link_console(obj/machinery/computer/resleeving/console)
	if(linked_console)
		if(linked_console == console)
			return TRUE
		unlink_console()
		if(linked_console)
			return FALSE
	linked_console = console
	if(!console)
		return TRUE
	on_console_linked(console)
	return TRUE

/obj/machinery/resleeving/proc/unlink_console()
	if(!linked_console)
		return TRUE
	var/old_linked_console = linked_console
	linked_console = null
	on_console_unlinked(old_linked_console)
	return TRUE

/obj/machinery/resleeving/proc/on_console_linked(obj/machinery/computer/resleeving/console)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/resleeving/proc/on_console_unlinked(obj/machinery/computer/resleeving/console)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/resleeving/proc/send_system_message(msg)

/obj/machinery/resleeving/proc/send_audible_system_message(msg)

#warn impl all
