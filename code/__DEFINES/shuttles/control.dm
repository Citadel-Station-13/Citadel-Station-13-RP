//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* authorization flags

/// has move, no dock = can only manually land
#define SHUTTLE_AUTHORIZATION_LAND (1<<0)
/// has dock, no move = can only dock without manual landing
#define SHUTTLE_AUTHORIZATION_DOCK (1<<1)
/// override normal hooks that are blocking the shuttle
#define SHUTTLE_AUTHORIZATION_FORCE (1<<2)
/// override hooks that are dangerously blocking the shuttle
#define SHUTTLE_AUTHORIZATION_DANGEROUSLY_FORCE (1<<3)
/// modify landing codes
/// todo: in overmaps update, this should be part of overmaps control systems.
#define SHUTTLE_AUTHORIZATION_CODES (1<<4)
