//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* op flags for /atom/proc/worth *//

/// consider intrinsic value
#define GET_WORTH_INTRINSIC (1<<0)
/// consider raw materials value of the item itself
#define GET_WORTH_MATERIALS (1<<1)
/// consider value of what's inside the item
#define GET_WORTH_CONTAINING (1<<2)
/// currently using get worth to detect entity buy price for something like supply
#define GET_WORTH_DETECTING_PRICE (1<<3)

/// default flags for /atom/proc/get_worth
#define GET_WORTH_FLAGS_DEFAULT (GET_WORTH_INTRINSIC | GET_WORTH_CONTAINING)
/// flags for get worth for supply detection
#define GET_WORTH_FLAGS_SUPPLY_DETECTION (GET_WORTH_INTRINSIC | GET_WORTH_CONTAINING | GET_WORTH_DETECTING_PRICE)

//* elasticities for worth_elasticity - arbitrary multipliers *//

/// default 1x elasticitiy
#define WORTH_ELASTICITY_DEFAULT 1
