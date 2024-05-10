//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* docking codes

/// max docking codes registered with a shuttle
#define SHUTTLE_DOCKING_CODES_BUFFER_MAXIMUM 10

//* docking authorization (codes, usually) check

/// codes valid
#define SHUTTLE_DOCKING_AUTHORIZATION_VALID 0
/// codes invalid, can't do a proper airlock docking / other stuff	var/list/translating_right_lookup

#define SHUTTLE_DOCKING_AUTHORIZATION_INVALID 1
/// completely disallow docking
#define SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED 2

//* docking bounding check

/// clear
#define SHUTTLE_DOCKING_BOUNDING_CLEAR 0
/// hard fault - there's another shuttle / something important in the way we can't overwrite
#define SHUTTLE_DOCKING_BOUNDING_HARD_FAULT 1
/// soft fault - we can trample it, but the shuttle requests that we shouldn't
#define SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT 2

//* docking overlap handlers

/// threshold from edge where we're considered able to be run into the side
#define SHUTTLE_OVERLAP_SIDE_THRESHOLD 2
/// threshold from front where we're rammed to the front anyways
#define SHUTTLE_OVERLAP_FRONT_THRESHOLD 2

/// overlap tile cache marker for 'no viable tile found in bounds'
#define SHUTTLE_OVERLAP_NO_FREE_SPACE "no-free-space"
