//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* inventory_hud_anchor *//

/// anchor to the main inventory drawer
/// 
/// * main axis runs towards the middle of screen on Y axis
/// * cross axis runs towards the middle of screen on X axis
/// * both main and cross cannot be 0, as that is where the drawer button is
/// 
/// * valid main-axis indices: >= 0
/// * valid cross-axis indices: >= 0
#define INVENTORY_HUD_ANCHOR_TO_DRAWER "drawer"
/// anchor to next to hands panel
///
/// * main axis runs left/right of hands
/// * cross axis runs away from edge of screen of hands
/// 
/// * valid main-axis indices: != 0
/// * valid cross-axis indices: >= 0
#define INVENTORY_HUD_ANCHOR_TO_HANDS "hands"

#warn impl all
