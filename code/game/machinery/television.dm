/obj/machinery/television
	name = "television"
	desc = "Used for watching galactic public broadcast media."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	base_icon_state = "frame"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/television
	use_power = USE_POWER_OFF
	idle_power_usage = 40

//NEED LOCAL CHANNEL VAR PULLED FROM SS. RETURN CURRENT CHANNEL TO SUBSYSTEM
/obj/machinery/television/Initialize(mapload)
	. = ..()

	var/list/channels = SStelevision.getChannels()
	var/current_channel = "Nanotrasen_Public_Network/"
	SStelevision.all_tvs += src
	SStelevision.all_tvs[src] = current_channel

/obj/machinery/television/Destroy()
	SStelevision.all_tvs -= src
	return ..()

/obj/machinery/television/proc/receiveLines(line, language)
	atom_say(line, SScharacters.resolve_language_path(language))

/obj/machinery/television/attackby(obj/item/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_unfasten_wrench(user, W, 40))
		return
