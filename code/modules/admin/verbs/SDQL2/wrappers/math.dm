//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// * Math Functions * //

/proc/sdql_sin(n)
	return sin(n)

/proc/sdql_cos(n)
	return cos(n)

/proc/sdql_tan(n)
	return tan(n)

/proc/sdql_arctan(a, b)
	return arctan(a, b)

/proc/sdql_max(...)
	return max(arglist(args))

/proc/sdql_min(...)
	return min(arglist(args))

/proc/sdql_clamp(a, b, c)
	return clamp(a, b, c)

/proc/sdql_turn(dir, angle)
	return turn(dir, angle)

/proc/sdql_round(A, B)
	return round(A, B)

/proc/sdql_floor(A, B = 1)
	return FLOOR(A, B)

/proc/sdql_ceil(A, B = 1)
	return CEILING(A, B)
