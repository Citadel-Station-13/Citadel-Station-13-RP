//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/stack_recipe/frame
	var/frame_id

/datum/stack_recipe/frame/New(frame_id)
	src.frame_id = frame_id
	..()

/datum/stack_recipe/frame/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir, list/created = list())
	for(var/i in 1 to min(amount, 10))
		created += new /obj/item/frame2(where, frame_id)
	return TRUE
