//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset/baseline_toiletbot
	abstract_type = /datum/prototype/robot_iconset/baseline_toiletbot
	chassis = /datum/prototype/robot_chassis/baseline
	icon = 'icons/mob/robot/iconset/baseline_toiletbot.dmi'
	icon_state_cover = "panel"
	icon_state_indicator = "indicator-lighting-utility"

/datum/prototype/robot_iconset/baseline_toiletbot/standard
	icon_state = "standard"

/datum/prototype/robot_iconset/baseline_toiletbot/logistics
	icon_state = "logistics"
	icon_state_indicator = "indicator-lighting-industrial"

/datum/prototype/robot_iconset/baseline_toiletbot/medical
	icon_state = "medical"
	icon_state_indicator = "indicator-lighting-medical"

/datum/prototype/robot_iconset/baseline_toiletbot/surgeon
	icon_state = "surgeon"
	icon_state_indicator = "indicator-lighting-medical"

/datum/prototype/robot_iconset/baseline_toiletbot/security
	icon_state = "security"

/datum/prototype/robot_iconset/baseline_toiletbot/engineering
	icon_state = "engineering"
	icon_state_indicator = "indicator-lighting-industrial"

/datum/prototype/robot_iconset/baseline_toiletbot/janitor
	icon_state = "janitor"

/datum/prototype/robot_iconset/baseline_toiletbot/antag
	icon_state = "antag"
	icon_state_indicator = "indicator-lighting-antag"
