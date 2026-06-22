//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/toml_config_entry/backend/shuttles
	abstract_type = /datum/toml_config_entry/backend/shuttles
	category = "backend.shuttles"

/datum/toml_config_entry/backend/shuttles/generate_all_previews_on_startup
	key = "generate_all_previews_on_startup"
	desc = "Whether to generate all shuttle previews on startup. This is a very expensive operation, \
	but ensures players have previews ready to go."
	default = FALSE
