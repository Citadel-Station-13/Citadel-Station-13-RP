//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Research Network Operator Levels *//
//* Lower --> can edit & kick higher *//
//* Minimum level is 0.              *//
//* Maximum level is OPLVL_DEFAULT.  *//

/// only research mainframe should have this
#define RESEARCH_NETWORK_OPLVL_ROOT 0
/// rd's console should have this
#define RESEARCH_NETWORK_OPLVL_DIRECTOR 25
/// bridge's console should have this
/// * UNUSED. I decided that bridge / command shouldn't be trusted with this.
#define RESEARCH_NETWORK_OPLVL_BRIDGE 50
/// preset department consoles should have this
#define RESEARCH_NETWORK_OPLVL_DEPARTMENT 75
/// default joining consoles should have this
#define RESEARCH_NETWORK_OPLVL_DEFAULT 100

/**
 * * edit connection of lower operator levels
 * * edit join passkey & default oplvl (must be lower than ownx`)
 * * approve join requests
 * * must have a flag to edit other's flag
 * * implicitly allows full design access as the system doesn't check for design tag whitelist/blacklist of
 *   the managing connection.
 */
#define RESEARCH_NETWORK_CAPABILITY_ADMIN (1<<0)
/**
 * * pull tech into local store / into disks
 */
#define RESEARCH_NETWORK_CAPABILITY_PULL_KNOWLEDGE (1<<3)
/**
 * * pull designs for printing / into local store / into disks
 */
#define RESEARCH_NETWORK_CAPABILITY_PULL_DESIGN (1<<4)
