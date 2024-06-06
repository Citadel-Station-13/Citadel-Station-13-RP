//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic

/datum/ai_holder/dynamic/proc/communication_with_holder(datum/ai_holder/dynamic/other)
	return AI_DYNAMIC_COMMUNICATION_FULL

/datum/ai_holder/dyanmic/proc/communication_with_network(datum/ai_network/network)
	#warn impl ; what does this / should this even mean?
