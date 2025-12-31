//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * checks if n / d is a terminating decimal
 *
 * * n must be an integer
 * * d must be an integer
 *
 * @return TRUE if terminating, FALSE if repeating
 */
/proc/is_terminating_fraction(n, d)
	ASSERT(n == floor(n) && d == floor(d))

	// N doesn't actually matter.
	// What we are checking for is "d"'s factors are only 2 and 5.

	d = abs(d)
	var/factoring = d

	// this is pretty simple, we're not even doing gcd or something mildly involved

	while(factoring != 1)
		if((factoring % 5))
			// not divisible by 5
			if((factoring % 2))
				// not divisible by 2
				break
			else
				// divisible by 2
				factoring = factoring / 2
		else
			// divisible by 5
			factoring = factoring / 5

	return factoring == 1
