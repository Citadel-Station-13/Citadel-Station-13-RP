//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/game/movement
	abstract_type = /datum/toml_config_entry/game/movement
	category = "game.movement"

/datum/toml_config_entry/game/movement/walk_speed
	key = "walk_speed"
	desc = {"
		Walk speed, in tiles per second.
		Walk speed works by slowing the mob down to that speed
		if it was above that speed.
		Walking will never speed your mob up.
	"}
	default = 2

// TODO: base_speed_multplier table with tags for each given category of
//       mob / species / whatever
