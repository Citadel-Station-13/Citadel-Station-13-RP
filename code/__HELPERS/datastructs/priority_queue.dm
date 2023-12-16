//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * An array-backed priority queue.
 * Higher value'd entries go first.
 *
 * The provided comparison function should return < 0, == 0, > 0, for a < b, a == b, and a > b respectively.
 */
/datum/priority_queue
	/// comparaison function
	var/procpath/comparison
	/// internal array
	var/list/array = list()

/datum/priority_queue/New(cmp)
	src.comparison = cmp
	array = list()

/datum/priority_queue/proc/is_empty()
	return length(array) == 0

/datum/priority_queue/proc/enqueue(entry)
	array += entry
	bubble_up(length(array))

/datum/priority_queue/proc/dequeue()
	if(length(array) == 0)
		return null
	. = array[1]
	array.Swap(1, length(array))
	--array.len
	bubble_down(1)

/datum/priority_queue/proc/peek()
	return length(array)? array[1] : null

// todo: define this
/datum/priority_queue/proc/bubble_up(index)
	while(index >= 2 && call(comparison)(array[index], array[index / 2]) > 0)
		array.Swap(index, index / 2)
		index /= 2

// todo: define this
/datum/priority_queue/proc/bubble_down(index)
	var/left
	var/right
	do
		left = array[index * 2]
		right = array[index * 2 + 1]
		if(call(comparison)(left, array[index]) > 0)
			if(call(comparison)(left, right) > 0)
				array.Swap(index, index * 2)
				index = index * 2
			else
				array.Swap(index, index * 2 + 1)
				index = index * 2 + 1
		else if(call(comparison)(right, array[index]) > 0)
			array.Swap(index, index * 2 + 1)
			index = index * 2 + 1
	while(TRUE)

/**
 * returns copy of list of entries in no particular order
 */
/datum/priority_queue/proc/flattened()
	return array.Copy()

/datum/priority_queue/proc/remove_index(index)
	var/length = length(array)
	if(!index || index > length)
		return
	if(index == length)
		. = array[index]
		--array.len
		return
	. = array[index]
	array.Swap(index, length)
	--array.len
	bubble_down(index)

/datum/priority_queue/proc/find(entry)
	return array.Find(entry)

/datum/priority_queue/proc/remove_entry(entry)
	return remove_index(array.Find(entry))

/datum/priority_queue/proc/size()
	return length(array)
