//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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

//* docking bounding check

/// clear
#define SHUTTLE_DOCKING_BOUNDING_CLEAR 0
/// hard fault - there's another shuttle / something important in the way we can't overwrite
#define SHUTTLE_DOCKING_BOUNDING_HARD_FAULT 1
/// soft fault - we can trample it, but the shuttle requests that we shouldn't
#define SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT 2

//* docking seal check

/// no airtight seal
#define SHUTTLE_DOCKING_SEAL_FAULT 0
/// 'messy' seal (walls obstructing, etc)
#define SHUTTLE_DOCKING_SEAL_INCONVENIENT 1
/// perfect seal
#define SHUTTLE_DOCKING_SEAL_NOMINAL 2

//* flags for bounds checks

/// manual landing is involved at all
#define SHUTTLE_BOUNDS_CHECKING_FOR_MANUAL_LANDING (1<<0)
/// currently previewing manual landing
#define SHUTTLE_BOUNDS_CHECKING_FOR_MANUAL_LANDING_PREVIEW (1<<1)
/// currently performing an aligned / bound-box docking where trample bounding box is true
#define SHTUTLE_BOUNDS_CHECKING_FOR_PRIVILEGED_DOCKING (1<<2)
/// currently moving as part of roundstart
#define SHUTTLE_BOUNDS_CHECKING_FOR_ROUNDSTART (1<<3)
/// admin movement
#define SHUTTLE_BOUNDS_CHECKING_FOR_ADMIN (1<<4)
#warn hook these

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
