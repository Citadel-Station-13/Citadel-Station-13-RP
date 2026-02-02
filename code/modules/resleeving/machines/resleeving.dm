/obj/machinery/resleeving
	name = "resleeving machinery"
	desc = "Some kind of machinery, likely part of the Vey-Med Transhuman Resleeving System."

	can_be_unanchored = TRUE

	var/obj/machinery/computer/resleeving/linked_console

/obj/machinery/resleeving/Destroy()
	unlink_console()
	return ..()

/obj/machinery/resleeving/proc/link_console(obj/machinery/computer/resleeving/console)
	SHOULD_NOT_SLEEP(TRUE)
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
	SHOULD_NOT_SLEEP(TRUE)
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
	visible_message("[icon2html(src, world)] flashes a message: [msg]")

/obj/machinery/resleeving/proc/send_audible_system_message(msg)
	atom_say("[msg]")

/obj/machinery/resleeving/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!machine_occupant_pod?.occupant)
		// no occupant: allow default actions
		if(default_deconstruction_screwdriver(clickchain.performer, using))
			return CLICKCHAIN_DID_SOMETHING
		if(default_deconstruction_crowbar(clickchain.performer, using))
			return CLICKCHAIN_DID_SOMETHING
		// TODO: implement on machinery base / rped
		if(default_part_replacement(clickchain.performer, using))
			return CLICKCHAIN_DID_SOMETHING

#warn impl unanchoring
