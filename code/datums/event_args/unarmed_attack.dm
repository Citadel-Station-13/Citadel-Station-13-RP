//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * data about an unarmed attack
 */
/datum/event_args/unarmed_attack
  var/damage_multiplier = 1
  var/intent = INTENT_HARM
  var/target_zone
  // todo: get default style if not specified
  var/datum/unarmed_attack/style
  // future use, swing data
  // var/datum/event_args/melee_swing/swing
