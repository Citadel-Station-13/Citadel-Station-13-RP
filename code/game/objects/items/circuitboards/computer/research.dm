#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(I.is_screwdriver())
		playsound(src, I.tool_sound, 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts the jumper on \the [src]'s access protocol pins."),
			SPAN_NOTICE("You adjust the jumper on the access protocol pins."),
			SPAN_HEAR("You hear a clicking sound.")
		)
		if(build_path == /obj/machinery/computer/rdconsole/core)
			name = T_BOARD("RD Console - Robotics")
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("Access protocols set to robotics."))
		else
			name = T_BOARD("RD Console")
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("Access protocols set to default."))
	return
