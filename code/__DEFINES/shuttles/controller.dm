//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* /datum/shuttle_controller/ferry - ferry_get_docking_state() *//

/// not docking, in transit, etc
#define SHUTTLE_FERRY_DOCKING_STATE_NOT_AT_DOCK 0
/// we're at the dock, but not docked
#define SHUTTLE_FERRY_DOCKING_STATE_UNDOCKED 1
/// we're undocking
#define SHUTTLE_FERRY_DOCKING_STATE_UNDOCKING 2
/// we're docking
#define SHUTTLE_FERRY_DOCKING_STATE_DOCKING 3
/// we're docked
#define SHUTTLE_FERRY_DOCKING_STATE_DOCKED 4

//*                   Docking completion callback status            *//
//* Docking callbacks are fired by the controller, not the shuttle. *//

/// succeeded
#define SHUTTLE_DOCKING_STATUS_SUCCESS 1
/// cancelled; starting the opposite docking cycle counts as this.
#define SHUTTLE_DOCKING_STATUS_ABORTED 2
/// failed
#define SHUTTLE_DOCKING_STATUS_FAILED 3
/// timed out
#define SHUTTLE_DOCKING_STATUS_TIMEOUT 4
/// the op has already passed!
#define SHUTTLE_DOCKING_STATUS_EXPIRED 5
/// we're not at somewhere that we can dock to
#define SHUTTLE_DOCKING_STATUS_INVALID 6

//*                Current docking state (dock)                      *//
//* Docking state is stored on the shuttle controller, not the shuttle. *//

/// Set while not at a dock, or an unknown error happened.
#define SHUTTLE_DOCKING_STATE_UNKNOWN 1
/// Currently at a dock, and docked.
#define SHUTTLE_DOCKING_STATE_DOCKED 2
/// Currently not at a dock, or at a dock and undocked.
#define SHUTTLE_DOCKING_STATE_UNDOCKED 3
/// Currently at a dock, and docking.
#define SHUTTLE_DOCKING_STATE_DOCKING 4
/// Currently at a dock, and undocking.
#define SHUTTLE_DOCKING_STATE_UNDOCKING 5
