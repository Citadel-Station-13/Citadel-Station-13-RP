//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/toml_config_entry/backend/repository
	abstract_type = /datum/toml_config_entry/backend/repository
	category = "backend.repository"

/datum/toml_config_entry/backend/repository/persistence
	key = "persistence"
	desc = {"
		Enable repository persistence. This requires the database to be available. Without this, most persistence
		features will not function.
	"}
	default = TRUE
