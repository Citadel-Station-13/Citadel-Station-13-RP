//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

#warn impl; rename to SHUTTLE_BOUNDING_* for docking_bounding

//* docking bounding check

/// clear
#define SHUTTLE_DOCKING_BOUNDING_CLEAR 0
/// we can dock here but we'll trample something that might cause damage to our shuttle
#define SHUTTLE_DOCKING_BOUNDING_ADVISORY_FAULT 1
/// soft fault - we can trample it, but the shuttle requests that we shouldn't
/// * this is ignorable by admin tooling and protected docks
#define SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT 2
/// hard fault - there's another shuttle / something important in the way that we can't overwrite
/// * this is not ignorable, even with admin tooling. ignoring this **breaks the game**.
#define SHUTTLE_DOCKING_BOUNDING_HARD_FAULT 3

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
