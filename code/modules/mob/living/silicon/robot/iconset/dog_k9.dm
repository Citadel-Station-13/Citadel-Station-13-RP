//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/dog_k9
	display_name = "K9"
	abstract_type = /datum/prototype/robot_iconset/dog_k9

	auto_chassis = /datum/prototype/robot_chassis/quadruped/canine

	icon = 'icons/mob/robot/iconset/dog_k9.dmi'
	icon_state_cover = "panel"
	icon_dimension_x = 64
	variations = list(
		/datum/robot_iconset_variation/bellyup,
		/datum/robot_iconset_variation/resting,
		/datum/robot_iconset_variation/dead,
		/datum/robot_iconset_variation/sitting,
	)

/datum/prototype/robot_iconset/dog_k9/security
	icon_state = "security"
	icon_state_indicator = "security-indicator"

/datum/prototype/robot_iconset/dog_k9/medical
	icon_state = "medical"
	icon_state_indicator = "medical-indicator"

/datum/prototype/robot_iconset/dog_k9/pink
	icon_state = "pink"
	icon_state_indicator = "pink-indicator"

/datum/prototype/robot_iconset/dog_k9/red
	icon_state = "red"
	icon_state_indicator = "red-indicator"

/datum/prototype/robot_iconset/dog_k9/medical_dark
	display_name = /datum/prototype/robot_iconset/dog_k9::display_name + " (Dark)"
	icon_state = "medical_dark"
	icon_state_indicator = "medical_dark-indicator"

/datum/prototype/robot_iconset/dog_k9/science_dark
	display_name = /datum/prototype/robot_iconset/dog_k9::display_name + " (Dark)"
	icon_state = "science_dark"
	icon_state_indicator = "science_dark-indicator"

/datum/prototype/robot_iconset/dog_k9/science
	icon_state = "science"
	icon_state_indicator = "science-indicator"

/datum/prototype/robot_iconset/dog_k9/engineering_dark
	display_name = /datum/prototype/robot_iconset/dog_k9::display_name + " (Dark)"
	icon_state = "engineering_dark"
	icon_state_indicator = "engineering_dark-indicator"

/datum/prototype/robot_iconset/dog_k9/engineering
	icon_state = "engineering"
	icon_state_indicator = "engineering-indicator"

/datum/prototype/robot_iconset/dog_k9/logistics_dark
	display_name = /datum/prototype/robot_iconset/dog_k9::display_name + " (Dark)"
	icon_state = "logistics_dark"
	icon_state_indicator = "logistics_dark-indicator"

/datum/prototype/robot_iconset/dog_k9/logistics
	icon_state = "logistics"
	icon_state_indicator = "logistics-indicator"

/datum/prototype/robot_iconset/dog_k9/grey
	icon_state = "grey"
	icon_state_indicator = "grey-indicator"

/datum/prototype/robot_iconset/dog_k9/janitor
	icon_state = "janitor"
	icon_state_indicator = "janitor-indicator"

/datum/prototype/robot_iconset/dog_k9/blade
	icon_state = "blade"
	icon_state_indicator = "blade-indicator"
