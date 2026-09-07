/obj/overmap/entity/visitable/sector/asteroid_field2
	name = "Asteroid field Delta"
	desc = "A mundane asteroid field perfect for mining."
	scanner_desc = @{"[b][i]Stellar Body[/b][/i]: Asteroid field Delta
[b]Class[/b]: Level 1 Asteroid Field
[b]Habitability[/b]: Impossible
[b]Population[/b]: N/A
[b]Controlling Goverment[/b]: N/A
[b]Relationship with NT[/b]: N/A
[b]Relevant Contacts[/b]: Standard carp bank located.
[b]Ores detection[/b]: Majority  of Plasma / Titanium / Uranium.
[b]Notes[/b]: May be used for low level mining."}
	icon_state = "debrisfield"
	color = "#daa922"
	known = FALSE
	in_space = 1


/obj/effect/step_trigger/teleporter/asteroid_field2_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/asteroid_field2_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/asteroid_field2_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/asteroid_field2_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z
