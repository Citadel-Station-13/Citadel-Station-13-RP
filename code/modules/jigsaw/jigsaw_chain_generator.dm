//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Runs multiple generator cycles on a buffer.
 */
/datum/jigsaw_chain_generator
	var/prepared = FALSE
	var/list/datum/jigsaw_generator_config/run_generator_configs = list()


/datum/jigsaw_chain_generator/proc/prepare()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(prepared)
		CRASH("double-prepare; not all chain-generators are idempotent for prepare_impl().")
	prepared = TRUE
	#warn impl

/datum/jigsaw_chain_generator/proc/prepare_impl()
	PROTECTED_PROC(TRUE)


#warn impl
