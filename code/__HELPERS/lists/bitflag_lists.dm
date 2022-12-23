GLOBAL_LIST_EMPTY(bitflag_lists)

/**
 * System for storing bitflags past the 24 limit, making use of an associative list.
 *
 * Macro converts a list of integers into an associative list of bitflag entries for quicker comparison.
 * Example: list(0, 4, 26, 32)) => list( "0" = ( (1<<0) | (1<<4) ), "1" = ( (1<<2) | (1<<8) ) )
 * Lists are cached into a global list of lists to avoid identical duplicates.
 * This system makes value comparisons faster than pairing every element of one list with every element of the other for evaluation.
 *
 * Arguments:
 * * target - List of integers. If this is null, we won't run at all.
 * * partition - max of positive integers; neg integers get added ontop
 */
#define SET_BITFLAG_LIST(target, partition) \
	if(target != null) { \
		var/txt_signature = target; \
		target = GLOB.bitflag_lists[txt_signature]; \
		if(isnull(target)) { \
			var/list/new_bitflag_list = list(); \
			var/list/decoded = json_decode("\[[txt_signature]0\]"); \
			decoded.len--; \
			for(var/value in decoded) { \
				if (value < 0) { \
					value = partition + 1 + abs(value); \
				} \
				new_bitflag_list["[round(value / 24)]"] |= (1 << (value % 24)); \
			}; \
			target = GLOB.bitflag_lists[txt_signature] = new_bitflag_list; \
		}; \
	}

// slow ; don't use for performance critical, just hardcode it in those cases. this one works in if()'s though.
#define COMPARE_BITFLAG_LIST(L1, L2) compare_bitlists(L1, L2)

/proc/compare_bitlists(list/L1, list/L2)
	// all?
	if(L1 == BODYTYPE_ALL || L2 == BODYTYPE_ALL)
		return TRUE
	// none will be picked up by regular compare
	// regular compare
	for(var/group in L1)
		if(L1[group] & L2[group])
			return TRUE
	return FALSE

// fast-ish ; carefully use for performance critical. this one works in if()'s.
#define CHECK_BITFLAG_LIST(L1, FLAG) (L1[num2text(round(bt / 24))] & (1 << (bt % 24)))
