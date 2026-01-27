//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

ADMIN_VERB_DEF(view_gm_pings, R_ADMIN, "View GM Pings", "View GM pings created by players..", VERB_CATEGORY_GAME)
	invoking.holder.open_admin_panel(/datum/admin_panel/gm_pings)
