//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * personality data
 */
/datum/ai_personality
	/// how aggro we are to people who are not our friends
	/// + / - 100 is "twice as much"
	var/non_friendly_aggression = 0
	/// how aggro we are to teammates
	/// + / - 100 is "twice as much"
	var/friendly_aggression = 0
	/// how cowardly we are; determines when we run, etc
	/// + / - 100 is "twice as much"
	var/cowardice = 0
	/// how careful we are; determines if we take cover or rambo, etc
	/// + / - 100 is "twice as much"
	var/caution = 0
	/// how likely we are to respond to calls for help
	/// + / - 100 is "twice as much"
	var/cooperation = 0
	/// how likely we are to call for help vs do something ourselves
	/// + / - 100 is "twice as much"
	var/delegation = 0
