//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

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

//*                Current docking state (dock)                         *//
//* Docking state is stored on the shuttle controller, not the shuttle. *//

/// Set if an unknown error happened.
#define SHUTTLE_DOCKING_STATE_UNKNOWN 0
/// Currently not at a dock, or at a dock and undocked.
#define SHUTTLE_DOCKING_STATE_UNDOCKED 1
/// Currently at a dock, and docking.
#define SHUTTLE_DOCKING_STATE_DOCKING 2
/// Currently at a dock, and undocking.
#define SHUTTLE_DOCKING_STATE_UNDOCKING 3
/// Currently at a dock, and docked.
#define SHUTTLE_DOCKING_STATE_DOCKED 4

#warn audit file
//* docking codes

/// max docking codes registered with a shuttle
#define SHUTTLE_DOCKING_CODES_BUFFER_MAXIMUM 10

//* docking authorization (codes, usually) check

/// codes valid
#define SHUTTLE_DOCKING_AUTHORIZATION_VALID 0
/// codes invalid, can't do a proper airlock docking / other stuff
#define SHUTTLE_DOCKING_AUTHORIZATION_INVALID 1
/// completely disallow docking
#define SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED 2

//* docking seal check

/// no airtight seal
#define SHUTTLE_DOCKING_SEAL_FAULT 0
/// 'messy' seal (walls obstructing, etc)
#define SHUTTLE_DOCKING_SEAL_INCONVENIENT 1
/// perfect seal
#define SHUTTLE_DOCKING_SEAL_NOMINAL 2


//* docking overlap handlers

/// threshold from edge where we're considered able to be run into the side
#define SHUTTLE_OVERLAP_SIDE_THRESHOLD 2
/// threshold from front where we're rammed to the front anyways
#define SHUTTLE_OVERLAP_FRONT_THRESHOLD 2
/// threshold from side where we're able to be rammed to the side instead of annihilated
/// if front has no room
#define SHUTTLE_OVERLAP_SIDE_FORGIVENESS 2
/// how far to look when performing front lookups
#define SHUTTLE_OVERLAP_FRONT_DEFLECTION 1
/// how far forwards to look when performing side lookups
#define SHUTTLE_OVERLAP_SIDE_FORWARDS_DEFLECTION INFINITY
/// how far backwards to look when performing side lookups
#define SHUTTLE_OVERLAP_SIDE_BACKWARDS_DEFLECTION 1

/// overlap tile cache marker for 'no viable tile found in bounds'
#define SHUTTLE_OVERLAP_NO_FREE_SPACE "no-free-space"
