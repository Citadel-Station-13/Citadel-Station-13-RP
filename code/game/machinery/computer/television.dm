/obj/machinery/computer/television/
	name = "television"
	desc = "Used for watching galactic public broadcast media"
	icon = 'icons/obj/status_display.dmi'
	icon_screen = "entertainment"
	light_color = "#FFEEDB"
	light_range_on = 2
	//circuit = /obj/item/circuitboard/security/telescreen/entertainment //Need to make a new circuit outide camera monitors


//NEED LOCAL CHANNEL VAR PULLED FROM SS. RETURN CURRENT CHANNEL TO SUBSYSTEM
/obj/machinery/computer/television/Initialize(mapload)
	. = ..()
	var/channel = "Nanotrasen_Public_Network/"
	SStelevision.all_tvs += src
	SStelevision.all_tvs[src] = channel

/obj/machinery/computer/television/Destroy()
	SStelevision.all_tvs -= src
	return ..()

/obj/machinery/computer/television/proc/receiveLines(line)
	//magic code that plays runetext and talks in chat I guess
	TO_WORLD(line)

//lines = default_language + "--" + line_text
