//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Runs multiple generator cycles on a buffer.
 */
/datum/jigsaw_chain_generator
	var/datum/jigsaw_chain_generator_config/config

/datum/jigsaw_chain_generator/New(datum/jigsaw_chain_generator_config/config)
	src.config = config

/datum/jigsaw_chain_generator/proc/prepare()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(prepared)
		CRASH("double-prepare; not all chain-generators are idempotent for prepare_impl().")
	prepared = TRUE
	#warn impl

/datum/jigsaw_chain_generator/proc/prepare_impl()
	PROTECTED_PROC(TRUE)


#warn impl
