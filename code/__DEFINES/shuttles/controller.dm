//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
///

#warn DEFINE_ENUM
