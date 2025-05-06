/obj/overmap/entity/visitable/sector/osiris_field
	name = "Osiris Debris Field"
	desc = "Space junk galore, but tragic."
	scanner_desc = @{"[i]Information[/i]: 2568-08-17 :
	The BNV 'HELL-WALKER', a military vessel, hijacked by its Rogue AI OSIRIS, Exploded.
	The shockwave of the explosion destroyed every ship that wasn't shielded enough.
	A lot of factions lost souls : Civilians, Military, Corporate, Pirate...
	Worst of all : The casulty list is still incomplete.

	2568-04-29 :
	The Hadii's Folly Governement, with the help of the Crew of the NSV Von Braun, finaly completed
	Memorial Station, a effort to remember the incident.
	Legal right to explore and scavenge newly made Debris field has also been granted by the SDF and the Governement."}
	icon_state = "debrisfield"
	color = "#765400"
	known = FALSE
	in_space = 1


/obj/effect/step_trigger/teleporter/osiris_field_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/osiris_field_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/osiris_field_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/osiris_field_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z
