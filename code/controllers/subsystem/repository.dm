//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

SUBSYSTEM_DEF(repository)
	name = "Repository System"
	init_order = INIT_ORDER_REPOSITORY
	subsystem_flags = SS_NO_FIRE

/datum/controller/subsystem/repository/Initialize()
	__init_repositories()
	return ..()
