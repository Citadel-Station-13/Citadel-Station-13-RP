//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/observer/dead/hear_say_new(datum/saycode_packet/packet)
	if(!client)
		return ..()
	// reject non-players that are offscreen
	if(!(packet.saycode_packet_flags & SAYCODE_PACKET_CONSIDERED_PLAYER) && packet.context_origin_turf && get_dist(packet.context_origin_turf, src) > max(client.current_viewport_height, client.current_viewport_width))
		return FALSE
	return ..()
