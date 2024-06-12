//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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

//* transit callback status

/// at destination
///
/// * this is purely a 'we are at destination'. we do not need a successful docking
/// * as an example, if we land on a dock, but don't have codes, this is still successful!
/// * again, this is only the transit status, not the docking status!
#define SHUTTLE_TRANSIT_STATUS_SUCCESS 1
/// aborted; destination was blocked on arrival
#define SHUTTLE_TRANSIT_STATUS_BLOCKED 2
/// aborted ; we got cancelled
#define SHUTTLE_TRANSIT_STATUS_CANCELLED 3
/// aborted ; we're going somewhere else
#define SHUTTLE_TRANSIT_STATUS_REDIRECTED 4
/// aborted ; unknown abort
#define SHUTTLE_TRANSIT_STATUS_FAILED 5

//* transit stages

/// not doing anything right now
#define SHUTTLE_TRANSIT_STAGE_IDLE 0
/// undocking
#define SHUTTLE_TRANSIT_STAGE_UNDOCK 1
/// taking off
#define SHUTTLE_TRANSIT_STAGE_TAKEOFF 2
/// in transit
#define SHUTTLE_TRANSIT_STAGE_FLIGHT 3
/// landing
#define SHUTTLE_TRANSIT_STAGE_LANDING 4
/// docking
#define SHUTTLE_TRANSIT_STAGE_DOCK 5

#warn DEFINE_ENUM

//* transit flags

/// should not interrupt
///
/// * without FORCE_UNDOCK / DOCK / TAKEOFF / LANDING, the transit can still be aborted by a timeout.
#define SHUTTLE_TRANSIT_FLAG_NO_ABORT (1<<0)
/// do not allow users to abort mid-transit
#define SHUTTLE_TRANSIT_FLAG_NO_TRANSIT_ABORT (1<<1)
/// do not obtain exclusive lock on dock
///
/// * not doing this is very silly of you.
#define SHUTTLE_TRANSIT_FLAG_NO_DOCK_MUTEX (1<<2)

#warn DEFINE_BITFIELD

//* traversal flags

/// immediate force
///
/// * doesn't wait, just slam through checks
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL (1<<0)
/// immediate force
///
/// * doesn't wait, just slam through checks
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING (1<<1)
/// force if something fails, not just times out
///
/// * implies FORCE_ON_TIMEOUT
/// * does wait for all other checks to either fail or time out
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL_ON_FAIL (1<<2)
/// force if something fails, not just times out
///
/// * implies FORCE_ON_TIMEOUT
/// * does wait for all other checks to either fail or time out
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_FAIL (1<<3)
/// force if something times out, but not if it fails
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL_ON_TIMEOUT (1<<4)
/// force if something times out, but not if it fails
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_TIMEOUT (1<<5)
/// prevents negative effects from takeoff / landing
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL_SAFETY (1<<6)
/// prevents negative effects from dock / undock step
#define SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_SAFETY (1<<7)

#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_IMMEDIATE ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL \
)
#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_SAFETY ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_SAFETY | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL_SAFETY \
)
#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_FAIL ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_FAIL | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL_ON_FAIL \
)
#define SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_TIMEOUT ( \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_DOCKING_ON_TIMEOUT | \
	SHUTTLE_TRAVERSAL_FLAG_FORCE_TRAVERSAL_ON_TIMEOUT \
)

#warn DEFINE_BITFIELD
