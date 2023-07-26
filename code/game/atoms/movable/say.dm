//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Say Module
//! Contains all relevant core procs for displaying (transmitting) messages, visible or audible.

/**
 * Says something audible
 *
 * @params
 * * message - message
 * * params - params
 * * voice_ident - identity
 * * lang - language
 */
/atom/movable/proc/say(message, list/params, voice_ident, datum/language/lang)

/**
 * Does something visible
 *
 * @params
 * * message - message
 * * params - params
 * * face_ident - identity
 * * lang - language
 */
/atom/movable/proc/emote(message, list/params, face_ident)


#warn impl all
