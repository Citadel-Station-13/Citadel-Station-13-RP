//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// Target zone macros
// These must match with BP_ for now, as
// the normal human external organ tags are the
// same tags we use for targeting

// In the future those might diverse, so start using these.

#define BODY_ZONE_HEAD "head"
#define BODY_ZONE_TORSO "torso"
#define BODY_ZONE_GROIN "groin"
#define BODY_ZONE_L_ARM  "l_arm"
#define BODY_ZONE_L_FOOT "l_foot"
#define BODY_ZONE_L_HAND "l_hand"
#define BODY_ZONE_L_LEG  "l_leg"
#define BODY_ZONE_R_ARM  "r_arm"
#define BODY_ZONE_R_FOOT "r_foot"
#define BODY_ZONE_R_HAND "r_hand"
#define BODY_ZONE_R_LEG  "r_leg"

#define BODY_ZONE_MOUTH "mouth"
#define BODY_ZONE_EYES "eyes"

/**
 * Simplify a target body zone to a more course one.
 *
 * * Hands become their arm zones
 * * Feet become their leg zones
 * * Groin is redirected to torso
 * * Eyes, mouth, are redirected to head
 */
/proc/SIMPLIFY_BODY_ZONE(zone)
	var/static/list/lookup = list(
		BODY_ZONE_GROIN = BODY_ZONE_TORSO,
		BODY_ZONE_L_HAND = BODY_ZONE_L_ARM,
		BODY_ZONE_R_HAND = BODY_ZONE_R_ARM,
		BODY_ZONE_L_FOOT = BODY_ZONE_L_LEG,
		BODY_ZONE_R_FOOT = BODY_ZONE_R_LEG,
		BODY_ZONE_MOUTH = BODY_ZONE_HEAD,
		BODY_ZONE_EYES = BODY_ZONE_HEAD,
	)
	return lookup[zone] || zone
