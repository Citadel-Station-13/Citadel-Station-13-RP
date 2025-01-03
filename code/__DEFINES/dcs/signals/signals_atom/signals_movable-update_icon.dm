//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Anything relating to update icon/rendering
 */

/// Called at the base of base_transform with the matrix that's being generated.
/// * Signature: (matrix/applying)
#define COMSIG_MOVABLE_BASE_TRANSFORM "movable-base_transform"
/// Called at the base of update_transform with the matrix that's being generated.
/// * Signature: (matrix/old_matrix, matrix/new_matrix)
#define COMSIG_MOVABLE_ON_UPDATE_TRANSFORM "movable-on_update_transform"
