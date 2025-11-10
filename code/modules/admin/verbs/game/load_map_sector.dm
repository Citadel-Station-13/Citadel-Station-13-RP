//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: sensical admin rights
// todo: better verb category
ADMIN_VERB_DEF(load_map_sector, R_ADMIN, "Load Map Sector", "Load a custom map sector.", VERB_CATEGORY_ADMIN)
	invoking.holder.open_admin_modal(/datum/admin_modal/load_map_sector)
