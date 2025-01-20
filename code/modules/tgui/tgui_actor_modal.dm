//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/proc/open_tgui_actor_modal(modal_type, datum/event_args/actor/actor, modal_timeout, datum/modal_target)

/**
 * generalized tgui modals with procs for checking things like activity
 * and validity
 *
 * * not to be confused with `/datum/admin_modal`; these have a specific
 *   user and target, usually
 */
/datum/tgui_actor_modal

#warn impl
