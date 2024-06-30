//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* authorization flags

/// can do literally anything; admin panels have this. if you manually vet an input you can have this too.
///
/// * do not under any circumstances allow passing raw input to a shuttle_controller's ui_act() with this flagged!
#define SHUTTLE_AUTHORIZATION_SUPERUSER (1<<0)
/// has move, no dock = can only manually land
#define SHUTTLE_AUTHORIZATION_LAND (1<<1)
/// has dock, no move = can only dock without manual landing
#define SHUTTLE_AUTHORIZATION_DOCK (1<<2)
/// override normal hooks that are blocking the shuttle
#define SHUTTLE_AUTHORIZATION_FORCE (1<<3)
/// override hooks that are dangerously blocking the shuttle
#define SHUTTLE_AUTHORIZATION_DANGEROUSLY_FORCE (1<<4)
/// modify landing codes
/// todo: in overmaps update, this should maybe (?) be part of overmaps control systems.
#define SHUTTLE_AUTHORIZATION_CODES (1<<5)

//* returns from [/datum/shuttle_controller/proc/check_auth_force_launch)

/// force non-dangerous hooks
#define SHUTTLE_AUTHORIZED_TO_SOFT_FORCE (1<<0)
/// dangerously force
#define SHUTTLE_AUTHORIZED_TO_HARD_FORCE (1<<1)

//* returns from [/datum/shuttle_controller/proc/check_auth_manual_landing)

/// we can access at all
#define SHUTTLE_AUTHORIZED_TO_DESIGNATE_MANUAL_LANDING (1<<0)
/// we can land at that location
#define SHUTTLE_AUTHORIZED_TO_MANUAL_LAND_THERE (1<<1)
