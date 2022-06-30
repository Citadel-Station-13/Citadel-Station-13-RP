// -- Objs -- //

/obj/effect/step_trigger/teleporter/tradeport_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z
