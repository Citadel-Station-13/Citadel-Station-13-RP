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
