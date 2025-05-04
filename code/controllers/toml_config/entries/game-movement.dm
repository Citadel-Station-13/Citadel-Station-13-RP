//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/game/movement
	abstract_type = /datum/toml_config_entry/game/movement
	category = "game.movement"

/datum/toml_config_entry/game/movement/base_speed
	key = "base_speed"
	desc = {"
		Base speed configuration.
		Things are applied via overwrite on the last (most specific) tag.
		As an example, a simple mob bear would be 'simple' -> 'bear'.
		Measured in tiles per second.
	"}

/datum/toml_config_entry/game/movement/walk_speed
	key = "walk_speed"
	desc = {"
		Walk speed, in tiles per second.
	"}

#warn sigh
