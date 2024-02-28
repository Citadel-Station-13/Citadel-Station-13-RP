//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * data about a melee attack with a weapon
 */
/datum/event_args/melee_attack
  var/damage_multiplier = 1
  var/intent = INTENT_HARM
  var/target_zone
  var/obj/item/weapon
  // future use, slash / stab / smash enum
  // var/style
  // future use, swing data
  // var/datum/event_args/melee_swing/swing
