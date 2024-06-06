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
#define SHUTTLE_DOKCING_STATUS_INVALID 6

//* docking states

#define SHUTTLE_DOCKING_STATE_IDLE 1
#define SHUTTLE_DOCKING_STATE_DOCKING 2
#define SHUTTLE_DOCKING_STATE_UNDOCKING 3

//* transit callback status

/// at destination
#define SHUTTLE_TRANSIT_STATUS_SUCCESS 1
/// destination was blocked on arrival
#define SHUTTLE_TRANSIT_STATUS_BLOCKED 2
/// aborted ; we're going somewhere else
#define SHUTTLE_TRANSIT_STATUS_ABORTED 3

//* transit stages

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
