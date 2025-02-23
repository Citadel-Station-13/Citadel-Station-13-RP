//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Describes stuff you can get for points in a point redemption vendor.
 * * Does not store info about the type of points, at time of writing.
 *
 * todo: category system
 */
/datum/point_redemption_item
	var/name = "Unknown Item"
	/**
	 * Description.
	 * * Inferred from path if unspecified.
	 */
	var/desc = "Some kind of item."
	var/path = /obj/item/bananapeel
	var/cost = 1

/datum/point_redemption_item/New(name, path, cost, desc)
	if(name)
		src.name = name
	if(path)
		src.path = path
	if(cost)
		src.cost = cost
	if(desc)
		src.desc = desc

	if(!ispath(src.path, /atom/movable))
		CRASH("invalid path '[src.path]'.")

	if(desc == initial(desc))
		var/atom/movable/casted = src.path
		desc = initial(casted.desc)

/**
 * @return list of entities created
 */
/datum/point_redemption_item/proc/instantiate(atom/where, amount = 1) as /list
	RETURN_TYPE(/list)
	. = list()
	var/safety = 50
	for(var/i in 1 to amount)
		if(!--safety)
			CRASH("safety limit hit")
		var/atom/movable/created = new path(where)
		. += created
