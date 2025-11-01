//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/is_throw_explicit_targetable(datum/thrownthing/throw_datum)
	// if dense always target
	if(density)
		return TRUE
	// else need a specific override
	return FALSE
