/**
 * Picks a random element from a list based on a weighting system.
 * For example, given the following list:
 * A = 6, B = 3, C = 1, D = 0
 * A would have a 60% chance of being picked,
 * B would have a 30% chance of being picked,
 * C would have a 10% chance of being picked,
 * and D would have a 0% chance of being picked.
 * You should only pass integers in.
 */
/proc/pickweight(list/list_to_pick)
	if(length(list_to_pick) == 0)
		return null

	var/total = 0
	for(var/item in list_to_pick)
		if(!list_to_pick[item])
			list_to_pick[item] = 0
		total += list_to_pick[item]

	total = rand(1, total)
	for(var/item in list_to_pick)
		var/item_weight = list_to_pick[item]
		if(item_weight == 0)
			continue

		total -= item_weight
		if(total <= 0)
			return item

	return null

/**
 * Pick2Weight but sets the key to 1 if unset
 */
/proc/pickweight_one_default(list/list_to_pick)
	for(var/item in list_to_pick)
		if(!list_to_pick[item])
			list_to_pick[item] = 1
	return pickweight(list_to_pick)

/**
 * Pick a random element from the list and remove it from the list.
 */
/proc/pick_n_take(list/L)
	RETURN_TYPE(L[_].type)
	if(L.len)
		var/picked = rand(1,L.len)
		. = L[picked]
		// Cut is far more efficient that Remove()
		L.Cut(picked,picked+1)

/**
 * choose n from list non-inplace
 */
/proc/pick_n_from_list(list/L, n)
	. = list()
	// IMPORTANT - this makes it not modify original list
	L = L.Copy()
	n = min(n, length(L))
	for(var/i in 1 to n)
		var/index = rand(1, length(L))
		. += L[index]
		L.Cut(index, index + 1)
