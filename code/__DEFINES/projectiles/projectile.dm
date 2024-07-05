//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* DESC WIP *//
#warn desc

/// normal hit; hit and apply on-hit effects and probably delete ourselves
#define PROJECTILE_HIT_NORMAL "normal"
/// pierce through
#define PROJECTILE_HIT_PIERCE "pierce"
/// phase through, no effects
#define PROJECTILE_HIT_PHASE "phase"
/// we were reflected; basically [PROJECTILE_HIT_PHASE], only separate for semantics
#define PROJECTILE_HIT_REDIRECT "redirect"

#warn impl
