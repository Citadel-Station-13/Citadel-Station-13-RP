//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/structure/closet/admin_resolve_narrate()
	. = list()
	for(var/mob/target in .)
		. += target
