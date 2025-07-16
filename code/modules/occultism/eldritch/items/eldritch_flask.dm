//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/eldritch_flask
	/// reagent volume capacity
	var/flask_volume = 120

/obj/item/eldritch_flask/Initialize(mapload)
	create_reagents(flask_volume)
	return ..()

#warn impl

/obj/item/eldritch_flask/examine(mob/user, dist)
	. = ..()

/obj/item/eldritch_flask/throw_impact(atom/A, datum/thrownthing/TT)
	. = ..()
	if(. & (COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return
	#warn shatter, dump reagents on floor, react with jostled

/obj/item/eldritch_flask/proc/shatter(atom/where = drop_location())
