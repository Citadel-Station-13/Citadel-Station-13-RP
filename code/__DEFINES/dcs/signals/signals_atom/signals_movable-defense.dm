//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Proto-Kinetic Weapons *//

#define PROTO_KINETIC_DETONATION_DATA_CREATE list(FALSE, list())
#define PROTO_KINETIC_DETONATION_DATA_IDX_MARKED 1
#define PROTO_KINETIC_DETONATION_DATA_IDX_BLACKBOARD 2

/**
 * Used to query for detonation. Inject detonation data using this signal.
 * * Args: (list/detonation_data)
 * * Detonation data: list(stacks = 0, list/blackboard = list())
 */
#define COMSIG_MOVABLE_PROTO_KINETIC_SCAN "movable-kinetic_weapoon_invocation"
	/// This must be returned to signal something happened; it is undefined behavior
	/// to modify the input list without returning this!
	#define RAISE_PROTO_KINETIC_SCAN_HANDLED (1<<0)

/**
 * On successful kinetic weapon detonation.
 * * Args: (list/detonation_data)
 * * Detonation data: see [COMSIG_MOVABLE_PROTO_KINETIC_SCAN]
 */
#define COMSIG_MOVABLE_PROTO_KINETIC_DETONATION "movable-kinetic_weapon_detonation"
