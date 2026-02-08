/obj/machinery/resleeving
	name = "resleeving machinery"
	desc = "Some kind of machinery, likely part of the Vey-Med Transhuman Resleeving System."

	can_be_unanchored = TRUE

	var/obj/machinery/computer/resleeving/linked_console

/obj/machinery/resleeving/Destroy()
	unlink_console()
	return ..()

/obj/machinery/resleeving/examine(mob/user, dist)
	. = ..()
	if(can_be_unanchored)
		. += SPAN_NOTICE("[src] can be unanchored with a <b>wrench</b>.")

/obj/machinery/resleeving/proc/link_console(obj/machinery/computer/resleeving/console)
	SHOULD_NOT_SLEEP(TRUE)
	if(linked_console)
		if(linked_console == console)
			return TRUE
		unlink_console()
		if(linked_console)
			return FALSE
	linked_console = console
	LAZYADD(linked_console.linked_resleeving_machinery, src)
	if(!console)
		return TRUE
	on_console_linked(console)
	return TRUE

/obj/machinery/resleeving/proc/unlink_console()
	SHOULD_NOT_SLEEP(TRUE)
	if(!linked_console)
		return TRUE
	var/old_linked_console = linked_console
	LAZYREMOVE(linked_console.linked_resleeving_machinery, src)
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

/obj/machinery/resleeving/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images)
	. = list()
	if(can_be_unanchored)
		if(anchored)
			.[TOOL_WRENCH] = list(
				"Unsecure" = dyntool_image_backward(TOOL_WRENCH),
			)
		else
			.[TOOL_WRENCH] = list(
				"Secure" = dyntool_image_forward(TOOL_WRENCH),
			)

	return merge_double_lazy_assoc_list(., ..())

/obj/machinery/resleeving/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	if(!can_be_unanchored)
		e_args.chat_feedback(
			SPAN_WARNING("[src] cannot be un/anchored."),
			target = src,
		)
		return TRUE
	var/was_anchored = anchored
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] starts to [was_anchored ? "unanchor" : "anchor"] [src]."),
	)
	if(!use_wrench(I, e_args, flags, 3 SECONDS, 1, TOOL_USAGE_BUILDING_FURNISHINGS | (was_anchored ? TOOL_USAGE_DECONSTRUCT : TOOL_USAGE_CONSTRUCT)))
		return TRUE
	if(was_anchored != anchored)
		return TRUE
	e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] [was_anchored ? "unanchors" : "anchors"] [src]."),
	)
	anchored = !was_anchored
	return TRUE
