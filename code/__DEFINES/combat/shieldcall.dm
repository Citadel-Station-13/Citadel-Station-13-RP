//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* keys for list/additional in atom_shieldcall *//

// None yet

//* shieldcall "struct" - this *must* match up with /atom/proc/run/check_shieldcall! *//

/// damage amount
#define SHIELDCALL_ARG_DAMAGE 1
/// damage type
#define SHIELDCALL_ARG_DAMTYPE 2
/// damage tier
#define SHIELDCALL_ARG_TIER 3
/// armor flag
#define SHIELDCALL_ARG_FLAG 4
/// damage mode
#define SHIELDCALL_ARG_MODE 5
/// attack type
#define SHIELDCALL_ARG_TYPE 6
/// attacking weapon datum - same as used in armor
#define SHIELDCALL_ARG_WEAPON 7
/// list for additional data
#define SHIELDCALL_ARG_ADDITIONAL 8
/// flags returned
#define SHIELDCALL_ARG_RETVAL 9

//* shieldcall additional data keys *//

// none yet

//* shieldcall return enum *//

/// keep calling
#define SHIELDCALL_RETURN_NORMAL 0
/// terminate; either fully mitigated or we're done here
#define SHIELDCALL_RETURN_TERMINATE 1
