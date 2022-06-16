

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

/obj/machinery/fossilrevive/attackby(obj/item/I, mob/user)
	if(reviving)
		to_chat(user, SPAN_NOTICE("The machine is processing!"))
		return ..()
	if(!istype(I, /obj/item/fossil))
		to_chat(user, SPAN_WARNING("That's not accepted by this machine."))
		return ..()
	var/obj/item/fossil/mosquito = I
	if(mosquito.processable == "seed")
		addtimer(CALLBACK(src, .proc/findsaway, "seed"), 100)
		reviving = TRUE
		mosquito.processable = FALSE
	else
		to_chat(user, SPAN_WARNING("That fossil has either already been processed, or does not contain valid genetic material."))

/obj/machinery/fossilrevive/proc/findsaway(generatetype)
	var/droploc = get_turf(src)
	if(generatetype == "seed")
		flick("pod_g", src)
		new /obj/item/seeds/random(droploc)
		visible_message( \
			SPAN_NOTICE("The [src] shudders and spits out a seed!"), \
			SPAN_NOTICE("You hear a whirr."))
		reviving = FALSE
