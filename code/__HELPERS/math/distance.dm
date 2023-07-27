/**
 * checks distance from one thing to another but automatically resolving for turf / nesting
 */
/proc/in_range_of(atom/A, atom/B, dist = 1)
	return game_range_to(A, B) <= dist

/**
 * gets real dist from A to B, including resolving for turf. if not the same Z, returns infinity.
 */
/proc/game_range_to(atom/A, atom/B)
	A = get_turf(A)
	B = get_turf(B)
	return A.z == B.z? get_dist(A, B) : INFINITY
