//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Say Module
//! Contains all relevant core procs for displaying (transmitting) messages, visible or audible.

#warn impl all

/atom/proc/visible_action_dual(hard_range, soft_range, visible_hard, visible_soft, list/exclude_cache, visible_self)

/atom/proc/audible_action_dual(hard_range, soft_range, audible_hard, audible_soft, list/exclude_cache, audible_self)

/atom/proc/full_action_dual(hard_range, soft_range, visible_hard, audible_hard, visible_soft, audible_soft, list/exclude_cache, visible_self, audible_self)

/atom/proc/visible_action(range, message, list/exclude_cache, self)

/atom/proc/audible_action(range, message, list/exclude_cache, self)

/atom/proc/full_action(range, visible, audible, list/exclude_cache, self)
