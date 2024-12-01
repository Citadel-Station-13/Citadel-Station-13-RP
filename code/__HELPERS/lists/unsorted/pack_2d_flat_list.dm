//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * puts something into the smallest inner list of a list of lists.
 *
 * three `list`'s in one sentence, yippee!
 *
 * * `inserting` can be a single element or a list of elements
 *
 * @return
 * * outer_list - outer list reference
 * * inserting - an element or a list of elements to insert
 * * put_at_end - pack into end, rather than start of list
 * * length_limit - max length to pack lists to
 * * out_packed - if exists, packed elements get put here
 * * out_leftovers - if exists, elements that couldn't go in due to length limit go in here
 */
/proc/pack_2d_flat_list(list/outer_list, list/inserting, put_at_end = TRUE, length_limit, list/out_packed, list/out_leftovers)
	// todo: optimize algorithm
	inserting = islist(inserting) ? inserting.Copy() : list(inserting)
	for(var/i in 1 to length(inserting))
		var/elem = inserting[i]
		var/list/smallest
		var/smallest_length = INFINITY
		for(var/j in 1 to length(outer_list))
			var/their_length = length(outer_list[j])
			if(their_length < smallest_length && their_length < length_limit)
				smallest = outer_list[j]
		if(!smallest)
			out_leftovers?.Add(inserting.Copy(i))
			out_packed?.Add(inserting.Copy(1, i))
			return
		if(put_at_end)
			smallest.Add(elem)
		else
			smallest.Insert(1, elem)
	out_packed?.Add(inserting)
