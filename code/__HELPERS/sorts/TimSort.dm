
/**
 * ## Tim Sort
 * Hybrid sorting algorithm derived from merge sort and insertion sort.
 *
 * **Sorts in place**.
 * You might not need to get the return value.
 *
 * @see
 * https://en.wikipedia.org/wiki/Timsort
 *
 * @param {list} to_sort - The list to sort.
 *
 * @param {proc} cmp - The comparison proc to use. Default: Numeric ascending.
 *
 * @param {boolean} associative - Whether the list is associative. Default: FALSE.
 *
 * @param {int} fromIndex - The index to start sorting from. Default: 1.
 *
 * @param {int} toIndex - The index to stop sorting at. Default: 0.
 */
/proc/tim_sort(list/to_sort, cmp = GLOBAL_PROC_REF(cmp_numeric_asc), associative = FALSE, fromIndex = 1, toIndex = 0) as /list
	if(length(to_sort) < 2)
		return to_sort

	fromIndex = fromIndex % length(to_sort)
	toIndex = toIndex % (length(to_sort) + 1)
	if(fromIndex <= 0)
		fromIndex += length(to_sort)
	if(toIndex <= 0)
		toIndex += length(to_sort) + 1

	var/datum/sort_instance/sorter = GLOB.sort_instance
	if(isnull(sorter))
		sorter = new

	sorter.L = to_sort
	sorter.cmp = cmp
	sorter.associative = associative

	sorter.tim_sort(fromIndex, toIndex)
	return to_sort
