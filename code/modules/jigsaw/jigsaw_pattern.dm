//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_pattern
	var/width
	var/height
	/**
	 * * index = (y - 1) * width + x, as a flat list.
	 * * this is as south-rotated. we iterate over this differently
	 *   if the thing accessing this wants a rotation.
	 */
	var/list/pattern

/datum/jigsaw_pattern/New(width, height)
	src.width = width
	src.height = height

	src.pattern = new /list(width * height)
