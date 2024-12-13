//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//? HUD screen_loc's are in code/__DEFINES/screen.dm ?//

//* inventory_hud_anchor *//

/// anchor to the main inventory drawer
///
/// * main axis runs towards the middle of screen on Y axis
/// * cross axis runs towards the middle of screen on X axis
/// * both main and cross cannot be 0, as that is where the drawer button is
///
/// * valid main-axis indices: >= 0, cross-axis != 0 if 0
/// * valid cross-axis indices: >= 0, main-axis != 0 if 0
#define INVENTORY_HUD_ANCHOR_TO_DRAWER "drawer"
/// anchor to next to hands panel
///
/// * main axis runs left/right of hands if negative/positive
/// * cross axis runs away from edge of screen of hands
///
/// * valid main-axis indices: != 0
/// * valid cross-axis indices: >= 0
#define INVENTORY_HUD_ANCHOR_TO_HANDS "hands"
/// automatic - shove it in anywhere we can
///
/// * axis cannot be specified for this
#define INVENTORY_HUD_ANCHOR_AUTOMATIC "automatic"

//* inventory_hud_class *//

/// always visible
#define INVENTORY_HUD_CLASS_ALWAYS "always"
/// only when drawer is open
#define INVENTORY_HUD_CLASS_DRAWER "drawer"

//* inventory_hud hide sources *//

/// from f12 / zoom toggle
#define INVENTORY_HUD_HIDE_SOURCE_F12 "F12"
/// from drawer toggle
#define INVENTORY_HUD_HIDE_SOURCE_DRAWER "drawer"

//* inventory slot remappings for species *//

/// inventory_hud_main_axis
#define INVENTORY_SLOT_REMAP_MAIN_AXIS "main-axis"
/// inventory_hud_cross_axis
#define INVENTORY_SLOT_REMAP_CROSS_AXIS "cross-axis"
/// name
#define INVENTORY_SLOT_REMAP_NAME "name"
/// inventory_hud_class
#define INVENTORY_SLOT_REMAP_CLASS "class"
/// inventory_hud_anchor
#define INVENTORY_SLOT_REMAP_ANCHOR "anchor"
