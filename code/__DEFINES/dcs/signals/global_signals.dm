//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Use SEND_GLOBAL_SIGNAL to send, and
 * RegisterGlobalSignal to receive.
 */

/// when a mob is in /Initialize(): (mob/creating)
#define COMSIG_GLOBAL_MOB_NEW "!global-mob-new"
/// when a mob is in /Destroy(): (mob/destroying)
#define COMSIG_GLOBAL_MOB_DEL "!global-mob-del"
