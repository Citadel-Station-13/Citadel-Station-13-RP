/obj/machinery/television
	name = "television"
	desc = "Used for watching galactic public broadcast media."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	base_icon_state = "frame"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/television
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 20

	var/list/current_channel = 1
	var/list/channels = list()

//NEED LOCAL CHANNEL VAR PULLED FROM SS. RETURN CURRENT CHANNEL TO SUBSYSTEM
/obj/machinery/television/Initialize(mapload)
	. = ..()

	channels = SStelevision.getChannels()
	//Temporary assignment we only have one channel.
	//current_channel = "Nanotrasen_Public_Network/"
	SStelevision.all_tvs += src
	SStelevision.all_tvs[src] = channels[current_channel]

/obj/machinery/television/Destroy()
	SStelevision.all_tvs -= src
	return ..()

/obj/machinery/television/proc/receiveLines(line, language)
	if(!machine_stat)
		atom_say(line, SScharacters.resolve_language_path(language))

/obj/machinery/television/proc/updateChannel()
	SStelevision.all_tvs[src] = channels[current_channel]

/obj/machinery/television/attackby(obj/item/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_unfasten_wrench(user, W, 40))
		return

/obj/machinery/television/attack_hand(mob/user, list/params)
	interact(user)

/obj/machinery/television/interact(mob/user)
	if(inoperable())
		to_chat(usr, "\The [src] doesn't appear to function.")
		return
	ui_interact(user)

/obj/machinery/television/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "Television", "SpaceCo - Television")
    ui.open()

/obj/machinery/television/ui_data(mob/user)
  var/list/data = list()
  data["channel"] = current_channel

  return data

/obj/machinery/television/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action == "next_channel")
		current_channel += 1
		if(current_channel > channels.len)
			current_channel = 1
	if(action == "previous_channel")
		current_channel -= 1
		if(current_channel < 1)
			current_channel = channels.len
	updateChannel()
	. = TRUE
