//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * auto-loads sheets into sheet silos
 */
/obj/machinery/sheet_silo_loader
	name = "materials silo loader"
	desc = "An autoloader for a materials silo."
	icon = 'icons/modules/mining/machinery/sheet_silo_loader.dmi'
	icon_state = "loader"
	anchored = TRUE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/sheet_silo_loader/process(delta_time)
	// todo: lazy-ticking
	var/list/obj/item/stack/material/stacks = list()
	for(var/obj/item/stack/material/matstack in loc)
		stacks += matstack
	if(!length(stacks))
		return
	var/obj/machinery/sheet_silo/silo = locate() in get_step(src, dir)
	if(isnull(silo))
		return
	for(var/obj/item/stack/material/matstack as anything in stacks)
		silo.take_sheets(matstack)
