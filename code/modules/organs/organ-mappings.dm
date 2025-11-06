//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_INIT(biology_organ_mappings, zz__init_biology_organ_mappings())

/**
 * Mappings for organs go here.
 *
 * ## Why?
 *
 * New organs are composition based, optimally. This means that biologies tick on them
 * instead of them having hard-coded tick procs.
 *
 * This has a downside; we are thus unable to implement things like say, organ actions for a specific default biology.
 * We can do that with subtypes, but then we need to manually override it in the species, and if the player
 * uses something like a biology injection (e.g. 'replace synthetic with protean') in their character entry,
 * we'd need the injection to specify replacement organs.
 *
 * Which we still can do. But to make the defaults easier, this page will store a list of biology-to-default's
 * for given organ keys. This means that if an organ defaults to a given biology, we will instead look up
 * from the list what type it should be with its organ key without actually specifying its type manually.
 */
/proc/zz__init_biology_organ_mappings()
	#warn impl
