//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_ai_group
	var/id
	var/assigned_name
	var/list/datum/ai_holder/holders

/datum/buildmode_ai_group/proc/order_to_location(turf/where_to, stay_duration = 30 SECONDS, stay_there_forever)
		if(9) // Control mobs with ai_holders.
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button on AI mob            = Select/Deselect mob</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button + alt on AI mob      = Toggle hostility on mob</span>")
			to_chat(usr, "<span class='notice'>Left Mouse Button + ctrl on AI mob     = Reset target/following/movement</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on enemy mob        = Command selected mobs to attack mob</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on allied mob       = Command selected mobs to follow mob</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button + shift on any mob  = Command selected mobs to follow mob regardless of faction</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button on tile             = Command selected mobs to move to tile (will cancel if enemies are seen)</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button + shift on tile     = Command selected mobs to reposition to tile (will not be inturrupted by enemies)</span>")
			to_chat(usr, "<span class='notice'>Right Mouse Button + alt on obj/turfs  = Command selected mobs to attack obj/turf</span>")
			to_chat(usr, "<span class='notice'>***********************************************************</span>")
	return 1
