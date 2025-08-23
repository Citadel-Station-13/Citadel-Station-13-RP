//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon

#warn impl all


/**
 * * User argument provided for easy handling. Please emit feedback via clickchain.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_ctrl_shift_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)

/**
 * * User argument provided for easy handling. Please emit feedback via clickchain.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_shift_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)

/**
 * * User argument provided for easy handling. Please emit feedback via clickchain.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)

/**
 * * User argument provided for easy handling. Please emit feedback via clickchain.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)

/**
 * * Please do not put important functions on this. For accessibility reasons, we cannot assume the middle button exists for all users.
 * * User argument provided for easy handling. Please emit feedback via clickchain.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_middle_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
