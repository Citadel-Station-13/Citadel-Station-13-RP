//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* transit callback status

/// at destination
#define SHUTTLE_TRANSIT_STATUS_SUCCESS 1
/// destination was blocked on arrival
#define SHUTTLE_TRANSIT_STATUS_BLOCKED 2
/// aborted ; we're going somewhere else
#define SHUTTLE_TRANSIT_STATUS_ABORTED 3
