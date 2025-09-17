//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

SUBSYSTEM_DEF(repository)
	name = "Repository System"
	init_order = INIT_ORDER_REPOSITORY
	init_stage = INIT_STAGE_BACKEND
	subsystem_flags = SS_NO_FIRE

/datum/controller/subsystem/repository/Initialize()
	__create_repositories()
	__init_repositories()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/repository/proc/get_all_repositories()
	return __get_all_repositories()
