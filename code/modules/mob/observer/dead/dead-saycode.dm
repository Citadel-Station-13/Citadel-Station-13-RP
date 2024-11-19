//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/observer/dead/hear(datum/saycode_packet/packet)
	if(!client)
		// we don't care; if this changes in the future, change it i guess
		return FALSE
	if(packet.context_origin_turf && get_dist(packet.context_origin_turf, src) > max(client.current_viewport_height, client.current_viewport_width))
		return FALSE
	return ..()

