//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* /datum/component/rig_piece rig_piece_flags *//

/// apply rig zone's armor to the piece
/// * make absolute sure you don't double up the piece coverage, or the player may get doubled effective armor!
#define RIG_PIECE_APPLY_ARMOR (1<<0)
/// apply rig zone's environmental shielding to the piece
/// * same as 'apply armor' but less serious; environmental protection is generally a max() instead of a multiply,
///   so doubling up often does nothing
#define RIG_PIECE_APPLY_ENVIRONMENTALS (1<<1)

//* /datum/component/rig_piece sealed *//

#define RIG_PIECE_UNSEALED 0
#define RIG_PIECE_SEALING 1
#define RIG_PIECE_UNSEALING 2
#define RIG_PIECE_SEALED 3
