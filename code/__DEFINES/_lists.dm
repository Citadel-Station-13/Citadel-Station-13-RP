/*
 * Holds procs to help with list operations
 */

/// Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)
/// Ensures L is initailized after this point
#define LAZYINITLIST(L) if (!L) L = list()
/// Sets a L back to null iff it is empty
#define UNSETEMPTY(L) if (L && !length(L)) L = null
/// Removes I from list L, and sets I to null if it is now empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
/// Adds I to L, initalizing I if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
/// Adds I to L, initalizing L if necessary, if I is not already in L
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
/// please use LAZYDISTINCTADD instead, this is juts an alias for tgcode ports
#define LAZYOR(L, I) LAZYDISTINCTADD(L, I)
#define LAZYFIND(L, V) (L ? L.Find(V) : 0)
/// Reads I from L safely - Works with both associative and traditional lists.
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
/// Turns LAZYINITLIST(L) L[K] = V into ...  for associated lists
#define LAZYSET(L, K, V) if(!L) { L = list(); } L[K] = V;
/// Reads the length of L, returning 0 if null
#define LAZYLEN(L) length(L)
///Sets a list to null
#define LAZYNULL(L) L = null
/// Null-safe L.Cut()
#define LAZYCLEARLIST(L) if(L) L.Cut()
/// Null-safe L.Copy()
#define LAZYCOPY(L) (L? L.Copy() : null)
/// Reads L or an empty list if L is not a list.  Note: Does NOT assign, L may be an expression.
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
#define SANITIZE_TO_LIST(L) ( islist(L) ? L : list(L) )
#define reverseList(L) reverseRange(L.Copy())

#define SAFEPICK(L) (length(L)? pick(L) : null)
#define SAFEFIND(L, S) (length(L)? (L.Find(S)) : null)
#define SAFEACCESS(L, I) (isnum(I)? (SAFEINDEXACCESS(L, I)) : ((I in L)? L[I] : null))
#define SAFEINDEXACCESS(L, I) (ISINRANGE(I, 1, length(L))? L[I] : null)
// Returns the key based on the index
#define KEYBYINDEX(L, index) (((index <= length(L)) && (index > 0)) ? L[index] : null)

/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]
/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]

/****
	* Binary search sorted insert
	* INPUT: Object to be inserted
	* LIST: List to insert object into
	* TYPECONT: The typepath of the contents of the list
	* COMPARE: The object to compare against, usualy the same as INPUT
	* COMPARISON: The variable on the objects to compare
	* COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
	*/
#define BINARY_INSERT(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON <= COMPARE.##COMPARISON) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON > COMPARE.##COMPARISON ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

#define islist(L) istype(L, /list)

#define VARSET_FROM_LIST(L, V) if(L && L[#V]) V = L[#V]
#define VARSET_FROM_LIST_IF(L, V, C...) if(L && L[#V] && (C)) V = L[#V]
#define VARSET_TO_LIST(L, V) if(L) L[#V] = V
#define VARSET_TO_LIST_IF(L, V, C...) if(L && (C)) L[#V] = V
