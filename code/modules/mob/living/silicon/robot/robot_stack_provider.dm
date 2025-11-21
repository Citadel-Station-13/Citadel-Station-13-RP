//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/stack_provider/robot_stack_provider
	/// our id, if any. this is used to find us when binding things to the robot's synths.
	/// * null will use typepath
	/// * change this from default and things that look for path won't be able to
	///   find the default. this can be done intentionally for some use cases.
	var/id
	/// what this is called in-ui
	var/display_name = "material store"

	/// our backing store
	var/datum/robot_resource_store/store

/datum/stack_provider/robot_stack_provider/New(datum/robot_resource_store/store)
	..()
	src.store = store

/datum/stack_provider/robot_stack_provider/Destroy()
	if(store?.stack_provider == src)
		store.stack_provider = null
	store = null
	return ..()
