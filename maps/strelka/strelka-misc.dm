/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door/strelka
	icon = 'icons/obj/stationobjs.dmi'
	name = "Blockade Runner mode button"
	desc = "Makes the ship enter a mode that closes all external windows of the shuttles. Can add a small level of protection."

/obj/machinery/button/remote/blast_door/strelka/trigger()
	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					command_announcement.Announce("Vessel is now entering Blockade Runner Mode. Closing ship shutters.", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					return
			else
				spawn(0)
					M.close()
					command_announcement.Announce("Vessel is now exiting Blockade Runner Mode. Opening ship shutters.", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					return

/obj/machinery/button/remote/blast_door/strelka/balista
	icon = 'icons/obj/stationobjs.dmi'
	name = "Balista activation button"
	desc = "Opens the Ballista blastdoors."

/obj/machinery/button/remote/blast_door/strelka/balista/trigger()
	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					command_announcement.Announce("The Obstruction removal Ballista is now online. Openning barrel blastdoors", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					return
			else
				spawn(0)
					M.close()
					command_announcement.Announce("The Obstruction removal Ballista is now offline. Openning barrel blastdoors", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					return
