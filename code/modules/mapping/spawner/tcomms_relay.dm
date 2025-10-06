
/obj/spawner/tcomms_relay
	name = "Tcomms relay spawner"
	var/obj/machinery/telecomms/relay/preset/telecomms/created

/obj/spawner/tcomms_relay/Spawn()
	created = new /obj/machinery/telecomms/relay/preset/telecomms(loc)

/obj/spawner/tcomms_relay/autoconnect
	late = TRUE

/obj/spawner/tcomms_relay/autoconnect/Spawn()
	..()
	var/obj/machinery/telecomms/hub/preset/station_hub
	station_hub = locate(/obj/machinery/telecomms/hub/preset) in world
	if(!station_hub)
		log_and_message_admins("[src] failed to locate telecoms hub, no autoconnection possible.")
	else
		LAZYDISTINCTADD(station_hub.links, created)
