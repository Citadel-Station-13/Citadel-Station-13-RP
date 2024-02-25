//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * base supertype of stream projection devices
 *
 * e.g. mediguns
 */
/obj/item/stream_projector

	/// locked targets
	var/list/atom/active_targets

/obj/item/stream_projector/proc/valid_target(atom/entity)

/obj/item/stream_projector/proc/can_target(atom/entity)

#warn impl all



