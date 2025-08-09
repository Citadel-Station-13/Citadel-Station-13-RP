//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// Do **not** use on abstract themes.
#define DECLARE_RIG_THEME(PATH) \
/obj/item/rig/preset##PATH { theme_preset = /datum/rig_theme##PATH };
