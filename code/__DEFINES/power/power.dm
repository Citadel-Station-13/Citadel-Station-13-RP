//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? Power channels for areas - Make sure these are in sync.
//* Any updates to this should be reflected in [tgui/packages/tgui/constants/power.ts] *//

#define POWER_CHANNEL_EQUIP 1
#define POWER_CHANNEL_LIGHT 2
#define POWER_CHANNEL_ENVIR 3

#define POWER_CHANNEL_COUNT 3

#define POWER_BIT_EQUIP (1<<0)
#define POWER_BIT_LIGHT (1<<1)
#define POWER_BIT_ENVIR (1<<2)

#define POWER_BITS_ALL (POWER_CHANNEL_EQUIP | POWER_CHANNEL_LIGHT | POWER_CHANNEL_ENVIR)

/// length must equal POWER_CHANNEL_COUNT
GLOBAL_REAL_LIST(power_channel_names) = list(
	"Equipment",
	"Lighting",
	"Environmental",
)

/// length must equal POWER_CHANNEL_COUNT
GLOBAL_REAL_LIST(power_channel_bits) = list(
	POWER_BIT_EQUIP,
	POWER_BIT_LIGHT,
	POWER_BIT_ENVIR,
)

/// length must equal POWER_CHANNEL_COUNT
#define EMPTY_POWER_CHANNEL_LIST list(0, 0, 0)

//? Powernet - Load Balancing - lower number is higher priority, lower priorities only get power if higher priority is satisfied.
//* Any updates to this should be reflected in [tgui/packages/tgui/constants/power.ts] *//

#define POWER_BALANCING_TIER_LOW 3
#define POWER_BALANCING_TIER_MEDIUM 2
#define POWER_BALANCING_TIER_HIGH 1

#define POWER_BALANCING_TIER_TOTAL 3


/// length must equal POWER_BALANCING_TIER_TOTAL
GLOBAL_REAL_LIST(power_balancing_tier_names) = list(
	"Low Priority",
	"Medium Priority",
	"High Priority",
)

/// length must equal POWER_BALANCING_TIER_TOTAL
#define EMPTY_POWER_BALANCING_LIST list(0, 0, 0)

//? APCs - this is in here because it depends on power channel amount

/// length must equal POWER_BALANCING_TIER_TOTAL
#define APC_CHANNEL_THRESHOLDS_DEFAULT list(0, 0.1, 0.3)
