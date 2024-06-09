//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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

/**
 * see [is_terminating_fraction()]
 *
 * forces d to make for a terminating decimal
 *
 * * this always rounds down. e.g. 10 / 41 fed through this would be 10 / 40, and so would 10 / 49.
 *
 * note: this is only valid if n, the numerator, is an integer. otherwise, it still might be repeating!
 */
/proc/force_terminating_denominator(d)
	ASSERT(d == floor(d))
	d = abs(d)

	var/factoring = d
	var/twos = 0
	var/fives = 0

	while(factoring != 1)
		if((factoring % 5))
			// not divisible by 5
			if((factoring % 2))
				// not divisible by 2
				break
			else
				// divisible by 2
				factoring = factoring / 2
				twos += 1
		else
			// divisible by 5
			factoring = factoring / 5
			fives += 1

	return max(1, floor(factoring)) * (2 ** twos) * (5 ** fives)
