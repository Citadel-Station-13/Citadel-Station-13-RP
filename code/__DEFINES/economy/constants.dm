//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* /datum/economy_account security_level *//

/**
 * Requires only a linked card / token, auto-login
 * * number / pin still works
 */
#define ECONOMY_SECURITY_LEVEL_RELAXED "relaxed"
/**
 * Requires number and pin
 */
#define ECONOMY_SECURITY_LEVEL_PASSWORD "password"
/**
 * Requires number, pin, and a linked card or token
 */
#define ECONOMY_SECURITY_LEVEL_MULTIFACTOR "multifactor"

//* Currency Name *//

/// currency name singular
#define CURRENCY_NAME_SINGULAR				"thaler"
/// currency name singular capitalized
#define CURRENCY_NAME_SINGULAR_PROPER		"Thaler"
/// currency name plural
#define CURRENCY_NAME_PLURAL				"thalers"
/// currency name plural capitalized
#define CURRENCY_NAME_PLURAL_PROPER		"Thalers"

//* Terminals *//

/**
 * Generates a random ephemeral terminal ID.
 *
 * * Ephemeral terminals are always prefixed with 'PROV'
 * * This is not automatically prefixed with '#'.
 */
#define ECONOMY_GENERATE_EPHEMERAL_TERMINAL_ID "PROV-[rand(1111, 9999)]-[rand(1111, 9999)]"

/**
 * orion fiduciary network automated clearing house network nodes
 * * basically, fluff for 'external wire transfers' that aren't specifically explained
 * * these are ephemeral; they're randomly generated every call.
 */
#define ECONOMY_GENERATE_EPHEMERAL_SYSTEM_TERMINAL "OFN ACH Node #[ECONOMY_GENERATE_EPHEMERAL_TERMINAL_ID]"
