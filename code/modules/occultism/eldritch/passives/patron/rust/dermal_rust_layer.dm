//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * gradually builds a dermal shield on you
 */
/datum/mansus_passive/patron/rust/dermal_rust_layer
    /// requires you to be around rust tiles
    var/requires_rust_tile_proximity = TRUE
    /// rust tiles needed for max strength
    var/requires_rust_tile_proximity_ratio = 0.5

#warn impl
