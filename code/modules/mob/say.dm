//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn impl all - they should be clones of /atom level but with recognition hooked

/mob/visible_action_dual(hard_range, soft_range, visible_hard, visible_soft, list/exclude_cache, visible_self)

/mob/audible_action_dual(hard_range, soft_range, audible_hard, audible_soft, list/exclude_cache, audible_self)

/mob/full_action_dual(hard_range, soft_range, visible_hard, audible_hard, visible_soft, audible_soft, list/exclude_cache, visible_self, audible_self)

/mob/visible_action(range, message, list/exclude_cache, self)

/mob/audible_action(range, message, list/exclude_cache, self)

/mob/full_action(range, visible, audible, list/exclude_cache, self)
