//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * simple 2d bounds
 */
/datum/bounds2
	var/x_low
	var/y_low
	var/x_high
	var/y_high

/datum/bounds2/New(xl, yl, xh, yh)
	x_low = xl
	y_low = yl
	x_high = xh
	y_high = yh

/datum/bounds2/proc/overlaps(datum/bounds2/enemy)
	return !( \
		enemy.x_low > x_high || \
		enemy.x_high < x_low || \
		enemy.y_low > y_high || \
		enemy.y_high < y_low \
	)

/datum/bounds2/proc/contains_xy(x, y)
	return (x >= x_low && x <= x_high) && (y >= y_low && y <= y_high)

/datum/bounds2/proc/to_text()
	return "([x_low], [y_low]) to ([x_high], [y_high])"
