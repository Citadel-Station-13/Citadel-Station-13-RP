//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Abstract control provider. Used for remote control modules.
 * * Pretty much is just here to provide a user ongoing UI / control flags
 *   to the rig and have a priority system for conflicts.
 * * Subtypes should insert special behavior.
 */
/obj/item/rig_module/control_binder

#warn impl

/**
 * Control provider injected by a rig subcore organ.
 */
/obj/item/rig_module/control_binder/rig_subcore
