

/obj/machinery/fossilrevive
	name = "fossil DNA extraction system"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/dnarevive
	var/reviving = FALSE

/obj/machinery/fossilrevive/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!istype(using, /obj/item/fossil))
		return
	if(reviving)
		to_chat(clickchain.performer, SPAN_NOTICE("The machine is processing!"))
		return CLICKCHAIN_DID_SOMETHING
	var/obj/item/fossil/mosquito = using
	if(mosquito.processable == "seed")
		addtimer(CALLBACK(src, PROC_REF(findsaway), "seed"), 100)
		to_chat(clickchain.performer, SPAN_NOTICE("[src] begins processing [mosquito]."))
		reviving = TRUE
		mosquito.processable = FALSE
	else
		to_chat(clickchain.performer, SPAN_WARNING("That fossil has either already been processed, or does not contain valid genetic material."))
	return CLICKCHAIN_DID_SOMETHING

/obj/machinery/fossilrevive/proc/findsaway(generatetype)
	var/droploc = get_turf(src)
	if(generatetype == "seed")
		flick("pod_g", src)
		new /obj/item/seeds/random(droploc)
		visible_message( \
			SPAN_NOTICE("The [src] shudders and spits out a seed!"), \
			SPAN_NOTICE("You hear a whirr."))
		reviving = FALSE
