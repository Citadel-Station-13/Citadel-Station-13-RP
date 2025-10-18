//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * This file contains targeting zones for the zone selector doll.
 */

#define TARGET_ZONE_HEAD "head"
#define TARGET_ZONE_EYES "eyes"
#define TARGET_ZONE_MOUTH "mouth"
#define TARGET_ZONE_TORSO "torso"
#define TARGET_ZONE_LEFT_ARM "l_arm"
#define TARGET_ZONE_LEFT_HAND "l_hand"
#define TARGET_ZONE_RIGHT_ARM "r_arm"
#define TARGET_ZONE_RIGHT_HAND "r_hand"
#define TARGET_ZONE_GROIN "groin"
#define TARGET_ZONE_LEFT_LEG "l_leg"
#define TARGET_ZONE_LEFT_FOOT "l_foot"
#define TARGET_ZONE_RIGHT_LEG "r_leg"
#define TARGET_ZONE_RIGHT_FOOT "r_foot"

GLOBAL_REAL_LIST(all_target_zones) = list(
	TARGET_ZONE_HEAD,
	TARGET_ZONE_EYES,
	TARGET_ZONE_MOUTH,
	TARGET_ZONE_TORSO,
	TARGET_ZONE_LEFT_ARM,
	TARGET_ZONE_LEFT_HAND,
	TARGET_ZONE_RIGHT_ARM,
	TARGET_ZONE_RIGHT_HAND,
	TARGET_ZONE_GROIN,
	TARGET_ZONE_LEFT_LEG,
	TARGET_ZONE_LEFT_FOOT,
	TARGET_ZONE_RIGHT_LEG,
	TARGET_ZONE_RIGHT_FOOT,
)
