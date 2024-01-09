//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* authorization flags

#define SHUTTLE_AUTHORIZATION_MOVE (1<<0)
#define SHUTTLE_AUTHORIZATION_DOCK (1<<1)
#define SHUTTLE_AUTHORIZATION_FORCE (1<<2)
#define SHUTTLE_AUTHORIZATION_DANGEROUSLY_FORCE (1<<3)
#define SHUTTLE_AUTHORIZATION_CODES (1<<4)

//* docking codes

/// max docking codes registered with a shuttle
#define SHUTTLE_DOCKING_CODES_BUFFER_MAXIMUM 10

/// codes valid
#define SHUTTLE_DOCKING_AUTHORIZATION_VALID 0
/// codes invalid, can't do a proper airlock docking / other stuff
#define SHUTTLE_DOCKING_AUTHORIZATION_INVALID 1
/// completely disallow docking
#define SHUTTLE_DOCKING_AUTHORIZATION_BLOCKED 2
