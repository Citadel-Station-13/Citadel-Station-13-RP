//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Enums

#define RIG_ZONE_CHEST "chest"
#define RIG_ZONE_HEAD "head"
#define RIG_ZONE_LEFT_ARM "left_arm"
#define RIG_ZONE_RIGHT_ARM "right_arm"
#define RIG_ZONE_LEFT_LEG "left_leg"
#define RIG_ZONE_RIGHT_LEG "right_leg"

#define RIG_ZONE_LEGS "legs"
#define RIG_ZONE_ARMS "arms"

#define RIG_ZONE_LIMBS "limbs"

#define RIG_ZONE_NONE "none"
#define RIG_ZONE_ALL "all"

DEFINE_ENUM(rig_zones, list(
	/obj/item/rig_module = list(
		"zone",
	),
), list(
	ENUM("Chest", RIG_ZONE_CHEST),
	ENUM("Head", RIG_ZONE_HEAD),
	ENUM("Both Arms", RIG_ZONE_ARMS),
	ENUM("Left Arm", RIG_ZONE_LEFT_ARM),
	ENUM("Right Arm", RIG_ZONE_RIGHT_ARM),
	ENUM("Both Legs", RIG_ZONE_LEGS),
	ENUM("Left Leg", RIG_ZONE_LEFT_LEG),
	ENUM("Right Leg", RIG_ZONE_RIGHT_LEG),
	ENUM("Zoneless", RIG_ZONE_NONE),
	ENUM("All Limbs", RIG_ZONE_LIMBS),
	ENUM("Full Body", RIG_ZONE_ALL),
))

#define ALL_RIG_ZONES list( \
	RIG_ZONE_CHEST, \
	RIG_ZONE_HEAD, \
	RIG_ZONE_LEFT_ARM, \
	RIG_ZONE_RIGHT_ARM, \
	RIG_ZONE_LEFT_LEG, \
	RIG_ZONE_RIGHT_LEG, \
)

#define ALL_RIG_ZONES_ASSOCIATED_TO_ZERO list( \
	RIG_ZONE_CHEST = 0, \
	RIG_ZONE_HEAD = 0, \
	RIG_ZONE_LEFT_ARM = 0, \
	RIG_ZONE_RIGHT_ARM = 0, \
	RIG_ZONE_LEFT_LEG = 0, \
	RIG_ZONE_RIGHT_LEG = 0, \
)

#define ALL_RIG_ZONES_ASSOCIATED_TO(X) list( \
	RIG_ZONE_CHEST = X, \
	RIG_ZONE_HEAD = X, \
	RIG_ZONE_LEFT_ARM = X, \
	RIG_ZONE_RIGHT_ARM = X, \
	RIG_ZONE_LEFT_LEG = X, \
	RIG_ZONE_RIGHT_LEG = X, \
)

//* Bits

#define RIG_ZONE_BIT_CHEST (1<<0)
#define RIG_ZONE_BIT_HEAD (1<<1)
#define RIG_ZONE_BIT_LEFT_ARM (1<<2)
#define RIG_ZONE_BIT_RIGHT_ARM (1<<3)
#define RIG_ZONE_BIT_LEFT_LEG (1<<4)
#define RIG_ZONE_BIT_RIGHT_LEG (1<<5)

#define RIG_ZONE_BIT_LEGS (RIG_ZONE_BIT_LEFT_LEG | RIG_ZONE_BIT_RIGHT_LEG)
#define RIG_ZONE_BIT_ARMS (RIG_ZONE_BIT_LEFT_ARM | RIG_ZONE_BIT_RIGHT_ARM)
#define RIG_ZONE_BIT_ALL (ALL)

GLOBAL_REAL_LIST(rig_zones) = ALL_RIG_ZONES
GLOBAL_REAL_LIST(rig_zone_to_bit) = list(
	RIG_ZONE_CHEST = RIG_ZONE_BIT_CHEST,
	RIG_ZONE_HEAD = RIG_ZONE_BIT_HEAD,
	RIG_ZONE_LEFT_ARM = RIG_ZONE_BIT_LEFT_ARM,
	RIG_ZONE_RIGHT_ARM = RIG_ZONE_BIT_RIGHT_ARM,
	RIG_ZONE_LEFT_LEG = RIG_ZONE_BIT_LEFT_LEG,
	RIG_ZONE_RIGHT_LEG = RIG_ZONE_BIT_RIGHT_LEG,
	RIG_ZONE_NONE = NONE,
	RIG_ZONE_ALL = RIG_ZONE_BIT_ALL,
	RIG_ZONE_LIMBS = RIG_ZONE_BIT_LEGS | RIG_ZONE_BIT_ARMS,
	RIG_ZONE_LEGS = RIG_ZONE_BIT_LEGS,
	RIG_ZONE_ARMS = RIG_ZONE_BIT_ARMS,
)
GLOBAL_REAL_LIST(rig_zone_bits) = list(
	RIG_ZONE_BIT_CHEST,
	RIG_ZONE_BIT_HEAD,
	RIG_ZONE_BIT_LEFT_ARM,
	RIG_ZONE_BIT_RIGHT_ARM,
	RIG_ZONE_BIT_LEFT_LEG,
	RIG_ZONE_BIT_RIGHT_LEG,
)

DEFINE_BITFIELD_NEW(rig_zone_flags, list(
	/datum/component/rig_piece = list(
		"rig_zone_bits",
	),
	/datum/rig_theme_piece = list(
		"rig_zone_bits",
	),
), list(
	BITFIELD_NEW("Chest", RIG_ZONE_BIT_CHEST),
	BITFIELD_NEW("Head", RIG_ZONE_BIT_HEAD),
	BITFIELD_NEW("Left Arm", RIG_ZONE_BIT_LEFT_ARM),
	BITFIELD_NEW("Right Arm", RIG_ZONE_BIT_RIGHT_ARM),
	BITFIELD_NEW("Left Leg", RIG_ZONE_BIT_LEFT_LEG),
	BITFIELD_NEW("Right Leg", RIG_ZONE_BIT_RIGHT_LEG),
))

/proc/rig_zone_bit_to_zone_enum(bit)
	switch(bit)
		if(RIG_ZONE_BIT_CHEST)
			return RIG_ZONE_CHEST
		if(RIG_ZONE_BIT_LEFT_ARM)
			return RIG_ZONE_LEFT_ARM
		if(RIG_ZONE_BIT_RIGHT_ARM)
			return RIG_ZONE_RIGHT_ARM
		if(RIG_ZONE_BIT_LEFT_LEG)
			return RIG_ZONE_LEFT_LEG
		if(RIG_ZONE_BIT_RIGHT_LEG)
			return RIG_ZONE_RIGHT_LEG
		if(RIG_ZONE_BIT_HEAD)
			return RIG_ZONE_HEAD

//* Handedness - returned from procs as enum

#define RIG_HANDEDNESS_LEFT "left"
#define RIG_HANDEDNESS_RIGHT "right"
#define RIG_HANDEDNESS_NONE "none"
