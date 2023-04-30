/**
 * These are macros used to reduce on proc calls.
 */
#define FETCH_ELEMENT(L, i) (associative) ? L[L[i]] : L[i]

/**
 * Minimum sized sequence that will be merged. Anything smaller than this will use binary-insertion sort.
 * Should be a power of 2
 */
#define MIN_MERGE 32

/**
 * When we get into galloping mode, we stay there until both runs win less often than MIN_GALLOP consecutive times.
 */
#define MIN_GALLOP 7

/**
 * This is a global instance to allow much of this code to be reused. The interfaces are kept separately.
 */
GLOBAL_DATUM_INIT(sort_instance, /datum/sort_instance, new())
/datum/sort_instance
	/// The array being sorted.
	var/list/L

	/// The comparator proc-reference.
	var/cmp = /proc/cmp_numeric_asc

	/// Whether we are sorting list keys (0: L[i]) or associated values (1: L[L[i]])
	var/associative = 0

	/**
	 * This controls when we get *into* galloping mode.  It is initialized	to MIN_GALLOP.
	 * The merge_low and merge_high methods nudge it higher for random data, and lower for highly structured data.
	 */
	var/min_gallop = MIN_GALLOP

	/**
	 * Stores information regarding runs yet to be merged.
	 * Run i starts at runBase[i] and extends for runLen[i] elements.
	 * runBase[i] + runLen[i] == runBase[i+1]
	 */
	var/list/run_bases = list()
	var/list/run_lens = list()


/datum/sort_instance/proc/tim_sort(start, end)
	run_bases.Cut()
	run_lens.Cut()

	var/remaining = end - start

	// If array is small, do a 'mini-TimSort' with no merges.
	if(remaining < MIN_MERGE)
		var/initRunLen = count_run_and_make_ascending(start, end)
		binary_sort(start, end, start+initRunLen)
		return

	// March over the array finding natural runs.
	// Extend any short natural runs to runs of length minRun.
	var/minRun = min_run_length(remaining)

	do
		// Identify next run.
		var/runLen = count_run_and_make_ascending(start, end)

		// If run is short, extend to min(minRun, remaining)
		if(runLen < minRun)
			var/force = (remaining <= minRun) ? remaining : minRun

			binary_sort(start, start+force, start+runLen)
			runLen = force

		// Add data about run to queue.
		run_bases.Add(start)
		run_lens.Add(runLen)

		// Maybe merge.
		merge_collapse()

		// Advance to find next run.
		start += runLen
		remaining -= runLen

	while(remaining > 0)


	// Merge all remaining runs to complete sort.
	// ASSERT(start == end)
	merge_force_collapse();
	// ASSERT(run_bases.len == 1)

	// reset min_gallop, for successive calls
	min_gallop = MIN_GALLOP

	return L

/**
 * Sorts the specified portion of the specified array using a binary
 * insertion sort.  This is the best method for sorting small numbers
 * of elements.  It requires O(n log n) compares, but O(n^2) data
 * movement (worst case).
 *
 * If the initial part of the specified range is already sorted,
 * this method can take advantage of it: the method assumes that the
 * elements in range [lo,start) are already sorted
 *
 * lo		the index of the first element in the range to be sorted
 * hi		the index after the last element in the range to be sorted
 * start	the index of the first element in the range that is	not already known to be sorted
 */
/datum/sort_instance/proc/binary_sort(lo, hi, start)
	//ASSERT(lo <= start && start <= hi)
	if(start <= lo)
		start = lo + 1

	for(,start < hi, ++start)
		var/pivot = FETCH_ELEMENT(L,start)

		//set left and right to the index where pivot belongs
		var/left = lo
		var/right = start
		//ASSERT(left <= right)

		//[lo, left) elements <= pivot < [right, start) elements
		//in other words, find where the pivot element should go using bisection search
		while(left < right)
			var/mid = (left + right) >> 1	//round((left+right)/2)
			if(call(cmp)(FETCH_ELEMENT(L,mid), pivot) > 0)
				right = mid
			else
				left = mid+1

		//ASSERT(left == right)
		move_element(L, start, left)	//move pivot element to correct location in the sorted range

/**
 * Returns the length of the run beginning at the specified position and reverses the run if it is back-to-front.
 *
 * A run is the longest ascending sequence with:
 * * a[lo] <= a[lo + 1] <= a[lo + 2] <= ...
 *
 * or the longest descending sequence with:
 * * a[lo] >  a[lo + 1] >  a[lo + 2] >  ...
 *
 * For its intended use in a stable mergesort, the strictness of the
 * definition of "descending" is needed so that the call can safely
 * reverse a descending sequence without violating stability.
 */
/datum/sort_instance/proc/count_run_and_make_ascending(lo, hi)
	// ASSERT(lo < hi)

	var/run_hi = lo + 1
	if(run_hi >= hi)
		return 1

	var/last = FETCH_ELEMENT(L,lo)
	var/current = FETCH_ELEMENT(L,run_hi++)

	if(call(cmp)(current, last) < 0)
		while(run_hi < hi)
			last = current
			current = FETCH_ELEMENT(L,run_hi)
			if(call(cmp)(current, last) >= 0)
				break
			++run_hi
		reverseRange(L, lo, run_hi)
	else
		while(run_hi < hi)
			last = current
			current = FETCH_ELEMENT(L,run_hi)
			if(call(cmp)(current, last) < 0)
				break
			++run_hi

	return run_hi - lo

/**
 * Returns the minimum acceptable run length for an array of the specified length.
 * Natural runs shorter than this will be extended with binary_sort
 */
/datum/sort_instance/proc/min_run_length(n)
	// ASSERT(n >= 0)
	// Becomes 1 if any bits are shifted off.
	var/r = 0
	while(n >= MIN_MERGE)
		r |= (n & 1)
		n >>= 1
	return n + r

/**
 * Examines the stack of runs waiting to be merged and merges adjacent runs until the stack invariants are reestablished:
 * * runLen[i-3] > runLen[i-2] + runLen[i-1]
 * * runLen[i-2] > runLen[i-1]
 *
 * This method is called each time a new run is pushed onto the stack.
 * So the invariants are guaranteed to hold for i<stackSize upon entry to the method.
 */
/datum/sort_instance/proc/merge_collapse()
	while(run_bases.len >= 2)
		var/n = run_bases.len - 1
		if(n > 1 && run_lens[n - 1] <= run_lens[n] + run_lens[n + 1])
			if(run_lens[n - 1] < run_lens[n + 1])
				--n
			merge_at(n)
		else if(run_lens[n] <= run_lens[n + 1])
			merge_at(n)
		else
			// Invariant is established.
			break

/**
 * Merges all runs on the stack until only one remains.
 * Called only once, to finalise the sort
 */
/datum/sort_instance/proc/merge_force_collapse()
	while(run_bases.len >= 2)
		var/n = run_bases.len - 1
		if(n > 1 && run_lens[n - 1] < run_lens[n + 1])
			--n
		merge_at(n)

/**
 * Merges the two consecutive runs at stack indices i and i+1.
 * Run i must be the penultimate or antepenultimate run on the stack.
 * In other words, i must be equal to stackSize-2 or stackSize-3.
 */
/datum/sort_instance/proc/merge_at(i)
	// ASSERT(run_bases.len >= 2)
	// ASSERT(i >= 1)
	// ASSERT(i == run_bases.len - 1 || i == run_bases.len - 2)

	var/base1 = run_bases[i]
	var/base2 = run_bases[i+1]
	var/len1 = run_lens[i]
	var/len2 = run_lens[i+1]

	// ASSERT(len1 > 0 && len2 > 0)
	// ASSERT(base1 + len1 == base2)

	/**
	 * Record the legth of the combined runs. If i is the 3rd last run now, also slide over the last run.
	 * (which isn't involved in this merge). The current run (i+1) goes away in any case.
	 */
	run_lens[i] += run_lens[i+1]
	run_lens.Cut(i+1, i+2)
	run_bases.Cut(i+1, i+2)

	/**
	 * Find where the first element of run2 goes in run1.
	 * Prior elements in run1 can be ignored (because they're already in place)
	 */
	var/k = gallop_right(FETCH_ELEMENT(L,base2), base1, len1, 0)
	// ASSERT(k >= 0)
	base1 += k
	len1 -= k
	if(len1 == 0)
		return

	/**
	 * Find where the last element of run1 goes in run2.
	 * Subsequent elements in run2 can be ignored (because they're already in place)
	 */
	len2 = gallop_left(FETCH_ELEMENT(L,base1 + len1 - 1), base2, len2, len2-1)
	// ASSERT(len2 >= 0)
	if(len2 == 0)
		return

	// Merge remaining runs, using tmp array with min(len1, len2) elements
	if(len1 <= len2)
		merge_low(base1, len1, base2, len2)
	else
		merge_high(base1, len1, base2, len2)


/**
 * Locates the position to insert key within the specified sorted range
 * If the range contains elements equal to key, this will return the index of the LEFTMOST of those elements
 *
 * key		the element to be inserted into the sorted range
 * base	the index of the first element of the sorted range
 * len		the length of the sorted range, must be greater than 0
 * hint	the offset from base at which to begin the search, such that 0 <= hint < len; i.e. base <= hint < base+hint
 *
 * Returns the index at which to insert element 'key'
 */
/datum/sort_instance/proc/gallop_left(key, base, len, hint)
	// ASSERT(len > 0 && hint >= 0 && hint < len)

	var/last_offset = 0
	var/offset = 1
	if(call(cmp)(key, FETCH_ELEMENT(L,base+hint)) > 0)
		var/max_offset = len - hint
		while(offset < max_offset && call(cmp)(key, FETCH_ELEMENT(L,base + hint + offset)) > 0)
			last_offset = offset
			offset = (offset << 1) + 1

		if(offset > max_offset)
			offset = max_offset

		last_offset += hint
		offset += hint

	else
		var/max_offset = hint + 1
		while(offset < max_offset && call(cmp)(key, FETCH_ELEMENT(L, base + hint-offset)) <= 0)
			last_offset = offset
			offset = (offset << 1) + 1

		if(offset > max_offset)
			offset = max_offset

		var/temp = last_offset
		last_offset = hint - offset
		offset = hint - temp

		// ASSERT(-1 <= last_offset && last_offset < offset && offset <= len)

	/**
	 * Now L[base+last_offset] < key <= L[base + offset], so key belongs somewhere to the right of last_offset but no farther than
	 * offset. Do a binary search with invariant L[base+last_offset-1] < key <= L[base+offset]
	 */
	++last_offset
	while(last_offset < offset)
		var/m = last_offset + ((offset - last_offset) >> 1)

		if(call(cmp)(key, FETCH_ELEMENT(L, base + m)) > 0)
			last_offset = m + 1
		else
			offset = m

	// ASSERT(last_offset == offset)
	return offset

/**
 * Like gallop_left, except that if the range contains an element equal to
 * key, gallop_right returns the index after the rightmost equal element.
 *
 * @param key the key whose insertion point to search for
 * @param a the array in which to search
 * @param base the index of the first element in the range
 * @param len the length of the range; must be > 0
 * @param hint the index at which to begin the search, 0 <= hint < n.
 *	 The closer hint is to the result, the faster this method will run.
 * @param c the comparator used to order the range, and to search
 * @return the int k,  0 <= k <= n such that a[b + k - 1] <= key < a[b + k]
 */
/datum/sort_instance/proc/gallop_right(key, base, len, hint)
	// ASSERT(len > 0 && hint >= 0 && hint < len)

	var/offset = 1
	var/last_offset = 0
	// If key <= L[base+hint]
	if(call(cmp)(key, FETCH_ELEMENT(L, base + hint)) < 0)
		// Therefore we want to insert somewhere in the range [base,base+hint] = [base+,base+(hint+1))
		var/max_offset = hint + 1
		// We are iterating backwards.
		while(offset < max_offset && call(cmp)(key, FETCH_ELEMENT(L, base + hint-offset)) < 0)
			last_offset = offset
			//1 3 7 15
			offset = (offset << 1) + 1

		if(offset > max_offset)
			offset = max_offset

		var/temp = last_offset
		last_offset = hint - offset
		offset = hint - temp

	// If key > L[base+hint]
	else
		// Therefore we want to insert somewhere in the range (base+hint,base+len) = [base+hint+1, base+hint+(len-hint))
		var/max_offset = len - hint
		while(offset < max_offset && call(cmp)(key, FETCH_ELEMENT(L, base + hint + offset)) >= 0)
			last_offset = offset
			offset = (offset << 1) + 1

		if(offset > max_offset)
			offset = max_offset

		last_offset += hint
		offset += hint

	// ASSERT(-1 <= last_offset && last_offset < offset && offset <= len)

	++last_offset
	while(last_offset < offset)
		var/m = last_offset + ((offset - last_offset) >> 1)

		// If key <= L[base+m]
		if(call(cmp)(key, FETCH_ELEMENT(L,base + m)) < 0)
			offset = m
		// If key > L[base+m]
		else
			last_offset = m + 1

	// ASSERT(last_offset == offset)

	return offset


/**
 * Merges two adjacent runs in-place in a stable fashion.
 * For performance this method should only be called when len1 <= len2!
 */
/datum/sort_instance/proc/merge_low(base1, len1, base2, len2)
	// ASSERT(len1 > 0 && len2 > 0 && base1 + len1 == base2)

	var/cursor1 = base1
	var/cursor2 = base2

	// Degenerate cases.
	if(len2 == 1)
		move_element(L, cursor2, cursor1)
		return

	if(len1 == 1)
		move_element(L, cursor1, cursor2 + len2)
		return


	// Move first element of second run.
	move_element(L, cursor2++, cursor1++)
	--len2

	outer:
		while(1)
			/// # of times in a row that first run won.
			var/count1 = 0
			/// # of times in a row that second run won.
			var/count2 = 0

			// Do the straightfoward thin until one run starts winning consistently.
			do
				// ASSERT(len1 > 1 && len2 > 0)
				if(call(cmp)(FETCH_ELEMENT(L, cursor2), FETCH_ELEMENT(L, cursor1)) < 0)
					move_element(L, cursor2++, cursor1++)
					--len2

					++count2
					count1 = 0

					if(len2 == 0)
						break outer
				else
					++cursor1

					++count1
					count2 = 0

					if(--len1 == 1)
						break outer

			while((count1 | count2) < min_gallop)

			/**
			 * One run is winning consistently so galloping may provide huge benifits
			 * so try galloping, until such time as the run is no longer consistently winning.
			 */
			do
				// ASSERT(len1 > 1 && len2 > 0)

				count1 = gallop_right(FETCH_ELEMENT(L, cursor2), cursor1, len1, 0)
				if(count1)
					cursor1 += count1
					len1 -= count1

					if(len1 <= 1)
						break outer

				move_element(L, cursor2, cursor1)
				++cursor2
				++cursor1
				if(--len2 == 0)
					break outer

				count2 = gallop_left(FETCH_ELEMENT(L, cursor1), cursor2, len2, 0)
				if(count2)
					move_range(L, cursor2, cursor1, count2)

					cursor2 += count2
					cursor1 += count2
					len2 -= count2

					if(len2 == 0)
						break outer

				++cursor1
				if(--len1 == 1)
					break outer

				--min_gallop

			while((count1 | count2) > MIN_GALLOP)

			if(min_gallop < 0)
				min_gallop = 0
			// Penalize for leaving gallop mode.
			min_gallop += 2;


	if(len1 == 1)
		// ASSERT(len2 > 0)
		move_element(L, cursor1, cursor2+len2)

	// else
	// 	ASSERT(len2 == 0)
	// 	ASSERT(len1 > 1)


/datum/sort_instance/proc/merge_high(base1, len1, base2, len2)
	// ASSERT(len1 > 0 && len2 > 0 && base1 + len1 == base2)

	// Start at end of sublists.
	var/cursor1 = base1 + len1 - 1
	var/cursor2 = base2 + len2 - 1

	// Degenerate cases.
	if(len2 == 1)
		move_element(L, base2, base1)
		return

	if(len1 == 1)
		move_element(L, base1, cursor2+1)
		return

	move_element(L, cursor1--, cursor2-- + 1)
	--len1

	outer:
		while(1)
			/// # of times in a row that first run won.
			var/count1 = 0
			/// # of times in a row that second run won.
			var/count2 = 0

			// Do the straightfoward thing until one run starts winning consistently.
			do
				// ASSERT(len1 > 0 && len2 > 1)
				if(call(cmp)(FETCH_ELEMENT(L, cursor2), FETCH_ELEMENT(L, cursor1)) < 0)
					move_element(L, cursor1--, cursor2-- + 1)
					--len1

					++count1
					count2 = 0

					if(len1 == 0)
						break outer
				else
					--cursor2
					--len2

					++count2
					count1 = 0

					if(len2 == 1)
						break outer
			while((count1 | count2) < min_gallop)

			/**
			 * One run is winning consistently so galloping may provide huge benifits
			 * so try galloping, until such time as the run is no longer consistently winning.
			 */
			do
				// ASSERT(len1 > 0 && len2 > 1)

				count1 = len1 - gallop_right(FETCH_ELEMENT(L, cursor2), base1, len1, len1-1)	//should cursor1 be base1?
				if(count1)
					cursor1 -= count1

					// cursor1+1 == cursor2 by definition.
					move_range(L, cursor1 + 1, cursor2 + 1, count1)

					cursor2 -= count1
					len1 -= count1

					if(len1 == 0)
						break outer

				--cursor2

				if(--len2 == 1)
					break outer

				count2 = len2 - gallop_left(FETCH_ELEMENT(L, cursor1), cursor1 + 1, len2, len2-1)
				if(count2)
					cursor2 -= count2
					len2 -= count2

					if(len2 <= 1)
						break outer

				move_element(L, cursor1--, cursor2-- + 1)
				--len1

				if(len1 == 0)
					break outer

				--min_gallop
			while((count1 | count2) > MIN_GALLOP)

			if(min_gallop < 0)
				min_gallop = 0
			// Penalize for leaving gallop mode.
			min_gallop += 2

	if(len2 == 1)
		// ASSERT(len1 > 0)

		cursor1 -= len1
		move_range(L, cursor1 + 1, cursor2 + 1, len1)

	// else
	// 	ASSERT(len1 == 0)
	// 	ASSERT(len2 > 0)


/datum/sort_instance/proc/sort_merge(start, end)
	var/remaining = end - start

	// If array is small, do an insertion sort.
	if(remaining < MIN_MERGE)
		binary_sort(start, end, start/*+initRunLen*/)
		return

	var/minRun = min_run_length(remaining)

	do
		var/runLen = (remaining <= minRun) ? remaining : minRun

		binary_sort(start, start + runLen, start)

		// Add data about run to queue.
		run_bases.Add(start)
		run_lens.Add(runLen)

		// Advance to find next run.
		start += runLen
		remaining -= runLen

	while(remaining > 0)

	while(run_bases.len >= 2)
		var/n = run_bases.len - 1
		if(n > 1 && run_lens[n - 1] <= run_lens[n] + run_lens[n + 1])
			if(run_lens[n - 1] < run_lens[n + 1])
				--n
			merge_at_2(n)
		else if(run_lens[n] <= run_lens[n + 1])
			merge_at_2(n)
		else
			// Invariant is established.
			break

	while(run_bases.len >= 2)
		var/n = run_bases.len - 1
		if(n > 1 && run_lens[n - 1] < run_lens[n + 1])
			--n
		merge_at_2(n)

	return L

/datum/sort_instance/proc/merge_at_2(i)
	var/cursor1 = run_bases[i]
	var/cursor2 = run_bases[i + 1]

	var/end1 = cursor1 + run_lens[i]
	var/end2 = cursor2 + run_lens[i + 1]

	var/val1 = FETCH_ELEMENT(L, cursor1)
	var/val2 = FETCH_ELEMENT(L, cursor2)

	while(1)
		if(call(cmp)(val1, val2) <= 0)
			if(++cursor1 >= end1)
				break
			val1 = FETCH_ELEMENT(L, cursor1)
		else
			move_element(L, cursor2, cursor1)

			if(++cursor2 >= end2)
				break
			++end1
			++cursor1

			val2 = FETCH_ELEMENT(L, cursor2)

	/**
	 * Record the legth of the combined runs. If i is the 3rd last run now, also slide over the last run
	 * (which isn't involved in this merge). The current run (i+1) goes away in any case.
	 */
	run_lens[i] += run_lens[i + 1]
	run_lens.Cut(i + 1, i + 2)
	run_bases.Cut(i + 1, i + 2)

#undef MIN_GALLOP
#undef MIN_MERGE

#undef FETCH_ELEMENT
