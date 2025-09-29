//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

ADMIN_VERB_DEF_PANEL_ONLY(narrate, R_ADMIN, "Narrate", "Perform narration.", VERB_CATEGORY_GAME, atom/target as turf|mob|obj|null)
	caller.holder.open_admin_modal(/datum/admin_modal/admin_narrate, target)
