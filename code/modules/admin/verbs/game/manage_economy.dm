//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

ADMIN_VERB_DEF(manage_economy, R_ADMIN, "Manage Economy", "Manage the economy.", VERB_CATEGORY_GAME)
	invoking.holder.open_admin_panel(/datum/admin_panel/economy_manager)
