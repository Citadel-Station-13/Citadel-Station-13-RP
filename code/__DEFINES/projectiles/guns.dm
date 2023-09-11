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
