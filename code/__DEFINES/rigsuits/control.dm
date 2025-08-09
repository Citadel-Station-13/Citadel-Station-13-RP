//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* rig_control_flags; do not edit these without editing TGUI side.

/// use basic movement controls (doesn't include modules like dashing)
/// * modules hooking movement count as this, this directly hooks mob's self movement
#define RIG_CONTROL_MOVEMENT (1<<0)
/// hands, emoting, using items, etc
#define RIG_CONTROL_HANDS (1<<1)
/// trigger hotbinds
/// * does not allow assigning hotbinds
#define RIG_CONTROL_USEBIND (1<<2)
/// assign hotbinds
/// * does not allow using binds
#define RIG_CONTROL_BINDING (1<<3)
/// activation control ergo locking/unlocking the suit around someone
/// * does not include userless deployment
/// * includes maintenance panel lock/unlock
#define RIG_CONTROL_ACTIVATION (1<<4)
/// piece deploy/seal/etc
/// * this is needed to use ui buttons for pieces too
/// * implies VIEW_PIECES
#define RIG_CONTROL_PIECES (1<<5)
/// access + use modules on rig panel
/// * not needed to trigger hotbinds
#define RIG_CONTROL_MODULES (1<<6)
/// view all visible modules on panel
/// * does not include control access
#define RIG_CONTROL_VIEW_MODULES (1<<7)
/// view all visible pieces on panel
/// * does not include control access
#define RIG_CONTROL_VIEW_PIECES (1<<8)
/// modify permissions
#define RIG_CONTROL_PERMISSIONS (1<<9)
/// use internal console
/// * pretty much admin access; console is by design not really permissions-strict
#define RIG_CONTROL_CONSOLE (1<<10)
/// deploy rig userless
/// * this is the flag that lets the AI go skynet mode
#define RIG_CONTROL_SELFDEPLOY (1<<11)

#define RIG_CONTROL_FLAGS_ALL ALL
#define RIG_CONTROL_FLAGS_WEARER ALL
#define RIG_CONTROL_FLAGS_MAINT_PANEL ALL
