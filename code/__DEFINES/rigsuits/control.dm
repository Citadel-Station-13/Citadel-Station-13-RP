//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* rig_control_flags; do not edit these without editing TGUI side.

/// use internal console
/// * pretty much admin access; console is by design not really permissions-strict
#define RIG_CONTROL_CONSOLE (1<<0)
/// modify permissions
#define RIG_CONTROL_PERMISSIONS (1<<1)
/// deploy rig userless
/// * this is the flag that lets the AI go skynet mode
#define RIG_CONTROL_SELFDEPLOY (1<<2)

/// use basic movement controls (doesn't include modules like dashing)
/// * modules hooking movement count as this, this directly hooks mob's self movement
#define RIG_CONTROL_MOVEMENT (1<<3)
/// hands, emoting, using items, etc
#define RIG_CONTROL_HANDS (1<<4)
/// activation control ergo locking/unlocking the suit around someone
/// * does not include userless deployment
/// * includes maintenance panel lock/unlock
#define RIG_CONTROL_ACTIVATION (1<<5)
/// piece deploy/seal/etc
/// * this is needed to see & use ui buttons for pieces too
/// * implies VIEW_PIECES
#define RIG_CONTROL_PIECES (1<<6)
/// access + use modules on rig panel
/// * not needed to trigger hotbinds
#define RIG_CONTROL_MODULES (1<<7)
/// view all visible modules on panel
/// * does not include control access
#define RIG_CONTROL_VIEW_MODULES (1<<8)
/// view all visible pieces on panel
/// * does not include control access
#define RIG_CONTROL_VIEW_PIECES (1<<8)

#define RIG_CONTROL_FLAGS_ALL ALL
#define RIG_CONTROL_FLAGS_WEARER ALL
#define RIG_CONTROL_FLAGS_MAINT_PANEL ALL
