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

#warn audit file
//* docking callback status

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

//* docking states

#define SHUTTLE_DOCKING_STATE_UNKNOWN 1
#define SHUTTLE_DOCKING_STATE_DOCKED 2
#define SHUTTLE_DOCKING_STATE_UNDOCKED 3
#define SHUTTLE_DOCKING_STATE_DOCKING 4
#define SHUTTLE_DOCKING_STATE_UNDOCKING 5
