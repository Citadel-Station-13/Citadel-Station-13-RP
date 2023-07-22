//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/atmospherics/component
	default_deconstruct = 4 SECONDS
	tool_deconstruct = TOOL_WRENCH
	default_unanchor = null
	tool_unanchor = null
	default_panel = null
	tool_panel = null

/obj/machinery/atmospherics/component/dynamic_tool_image(function, hint)
	. = ..()

/obj/machinery/atmospherics/component/dynamic_tool_functions(obj/item/I, mob/user)
	. = ..()

#warn impl all
