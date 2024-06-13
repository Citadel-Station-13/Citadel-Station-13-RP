//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* safety states
/// no safeties are on this gun
#define GUN_NO_SAFETY				-1
/// safety off
#define GUN_SAFETY_OFF				0
/// safety on
#define GUN_SAFETY_ON				1

//* fire() returns
/// success
#define GUN_FIRE_SUCCESS 0
/// usually caused by null return from consume_next_projectile() for /projectile guns
#define GUN_FIRE_NO_AMMO 1
/// generic failure
#define GUN_FIRE_FAILURE 2

//* Gun attachment slots *//

/// attached to the barrel
#define GUN_ATTACHMENT_BARREL "barrel"
/// attached to / extends the stock
#define GUN_ATTACHMENT_STOCK "stock"
/// under the barrel
#define GUN_ATTACHMENT_UNDERBARREL "underbarrel"
/// side of barrel (currently should only be flashlights)
#define GUN_ATTACHMENT_SIDEBARREL "sidebarrel"
/// most rail attachments are this
#define GUN_ATTACHMENT_SIGHT "sight"
/// the only other kind of rail attachment right now, so it doesn't collide with scope
#define GUN_ATTACHMENT_HARNESS "harness"

//* Balancing - Accuracy, Instability, Recoil *//

/// * it is a good idea to change instability_recovery on guns as well as this
/// * this is because exponentials are Funny.
///
// for:
// * /obj/item/gun: recoil

#define GUN_RECOIL_NONE 0
#define GUN_RECOIL_SUBTLE 7.5
#define GUN_RECOIL_LIGHT 15
#define GUN_RECOIL_MODERATE 25
#define GUN_RECOIL_HEAVY 35
#define GUN_RECOIL_EXTREME 70

// for:
// * /obj/item/gun: recoil_wielded_multiplier

#define GUN_RECOIL_MITIGATION_NONE 1
#define GUN_RECOIL_MITIGATION_SUBTLE 0.8
#define GUN_RECOIL_MITIGATION_LIGHT 0.75
#define GUN_RECOIL_MITIGATION_MEDIUM 0.65
#define GUN_RECOIL_MITIGATION_HIGH 0.4
#define GUN_RECOIL_MITIGATION_EXTREME 0.2

// for:
// * /obj/item/gun: instability_motion

#define GUN_INSTABILITY_MOTION_NONE 0
#define GUN_INSTABILITY_MOTION_SUBTLE 1
#define GUN_INSTABILITY_MOTION_LIGHT 2
#define GUN_INSTABILITY_MOTION_MEDIUM 3
#define GUN_INSTABILITY_MOTION_HEAVY 4
#define GUN_INSTABILITY_MOTION_EXTREME 10

// for:
// * /obj/item/gun: instability_draw

#define GUN_INSTABILITY_DRAW_NONE 0
#define GUN_INSTABILITY_DRAW_SUBTLE 5
#define GUN_INSTABILITY_DRAW_LIGHT 10
#define GUN_INSTABILITY_DRAW_MEDIUM 20
#define GUN_INSTABILITY_DRAW_HEAVY 30
#define GUN_INSTABILITY_DRAW_EXTREME 50

// for:
// * /obj/item/gun: instability_wield

#define GUN_INSTABILITY_WIELD_NONE 0
#define GUN_INSTABILITY_WIELD_SUBTLE 5
#define GUN_INSTABILITY_WIELD_LIGHT 10
#define GUN_INSTABILITY_WIELD_MEDIUM 20
#define GUN_INSTABILITY_WIELD_HEAVY 30
#define GUN_INSTABILITY_WIELD_EXTREME 50

// instability = instability * (recovery ** seconds)
// for:
// * /obj/item/gun: instability_recovery

#define GUN_INSTABILITY_RECOVERY_NORMAL 0.4

// for:
// * any screenshake amount parameters

#define GUN_SCREENSHAKE_VERY_LIGHT 3
#define GUN_SCREENSHAKE_LIGHT 6
#define GUN_SCREENSHAKE_MEDIUM 12
#define GUN_SCREENSHAKE_STRONG 20
#define GUN_SCREENSHAKE_RIDICULOUS 32
