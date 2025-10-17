/// Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)
/// Ensures L is initialized and uses it as a rvalue
#define LAZYGETLIST(L) (isnull(L)? (L = list()) : L)

/*
 * ## Lazylists
 *
 * * What is a lazylist?
 *
 * True to its name a lazylist is a lazy instantiated list.
 * It is a list that is only created when necessary (when it has elements) and is null when empty.
 *
 * * Why use a lazylist?
 *
 * Lazylists save memory - an empty list that is never used takes up more memory than just `null`.
 *
 * * When to use a lazylist?
 *
 * Lazylists are best used on hot types when making lists that are not always used.
 *
 * For example, if you were adding a list to all atoms that tracks the names of people who touched it,
 * you would want to use a lazylist because most atoms will never be touched by anyone.
 *
 * * How do I use a lazylist?
 *
 * A lazylist is just a list you defined as `null` rather than `list()`.
 * Then, you use the LAZY* macros to interact with it, which are essentially null-safe ways to interact with a list.
 *
 * Note that you probably should not be using these macros if your list is not a lazylist.
 * This will obfuscate the code and make it a bit harder to read and debug.
 *
 * Generally speaking you shouldn't be checking if your lazylist is `null` yourself, the macros will do that for you.
 * Remember that LAZYLEN (and by extension, length) will return 0 if the list is null.
 */

///Initialize the lazylist
#define LAZYINITLIST(L) if (!L) { L = list(); }
///If the provided list is empty, set it to null
#define UNSETEMPTY(L) if (L && !length(L)) L = null
///If the provided key -> list is empty, remove it from the list
#define ASSOC_UNSETEMPTY(L, K) if (!length(L[K])) L -= K;
///Like LAZYCOPY - copies an input list if the list has entries, If it doesn't the assigned list is nulled
#define LAZYLISTDUPLICATE(L) (L ? L.Copy() : null )
///Remove an item from the list, set the list to null if empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
/// Adds I to L, initalizing L if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
///Add an item to the list if not already present, if the list is null it will initialize it
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
///Returns the key of the submitted item in the list
#define LAZYFIND(L, V) (L ? L.Find(V) : 0)
///returns L[I] if L exists and I is a valid index of L, runtimes if L is not a list
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
///Sets the item K to the value V, if the list is null it will initialize it
#define LAZYSET(L, K, V) if(!L) { L = list(); } L[K] = V;
///Sets the length of a lazylist
#define LAZYSETLEN(L, V) if (!L) { L = list(); } L.len = V;
///Returns the length of the list
#define LAZYLEN(L) length(L)
///Sets a list to null
#define LAZYNULL(L) L = null
///Adds to the item K the value V, if the list is null it will initialize it
#define LAZYADDASSOC(L, K, V) if(!L) { L = list(); } L[K] += V;
///This is used to add onto lazy assoc list when the value you're adding is a /list/. This one has extra safety over lazyaddassoc because the value could be null (and thus cant be used to += objects)
#define LAZYADDASSOCLIST(L, K, V) if(!L) { L = list(); } L[K] += list(V);
///Removes the value V from the item K, if the item K is empty will remove it from the list, if the list is empty will set the list to null
#define LAZYREMOVEASSOC(L, K, V) if(L) { if(L[K]) { L[K] -= V; if(!length(L[K])) L -= K; } if(!length(L)) L = null; }
///Accesses an associative list, returns null if nothing is found
#define LAZYACCESSASSOC(L, I, K) L ? L[I] ? L[I][K] ? L[I][K] : null : null : null
//These methods don't null the list
///Use LAZYLISTDUPLICATE instead if you want it to null with no entries
#define LAZYCOPY(L) (L ? L.Copy() : list() )
/// Consider LAZYNULL instead
#define LAZYCLEARLIST(L) if(L) L.Cut()
///Returns the list if it's actually a valid list, otherwise will initialize it
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
/// Performs an insertion on the given lazy list with the given key and value. If the value already exists, a new one will not be made.
#define LAZYDISTINCTADDASSOC(lazy_list, key, value) \
	LAZYINITLIST(lazy_list); \
	LAZYINITLIST(lazy_list[key]); \
	lazy_list[key] |= value;
/// Calls Insert on the lazy list if it exists, otherwise initializes it with the value
#define LAZYINSERT(lazylist, index, value) \
	if (!lazylist) { \
		lazylist = list(value); \
	} else if (index == 0 && index > length(lazylist)) { \
		lazylist += value; \
	} else { \
		lazylist.Insert(index, value); \
	}

///Ensures the length of a list is at least I, prefilling it with V if needed. if V is a proc call, it is repeated for each new index so that list() can just make a new list for each item.
#define LISTASSERTLEN(L, I, V...) \
	if (length(L) < I) { \
		var/_OLD_LENGTH = length(L); \
		L.len = I; \
		/* Convert the optional argument to a if check */ \
		for (var/_USELESS_VAR in list(V)) { \
			for (var/_INDEX_TO_ASSIGN_TO in _OLD_LENGTH+1 to I) { \
				L[_INDEX_TO_ASSIGN_TO] = V; \
			} \
		} \
	}

#define reverseList(L) reverseRange(L.Copy())

#define SAFEPICK(L) (length(L)? pick(L) : null)
#define SAFEFIND(L, S) (length(L)? (L.Find(S)) : null)
#define SAFEACCESS(L, I) (isnum(I)? (SAFEINDEXACCESS(L, I)) : ((I in L)? L[I] : null))
#define SAFEINDEXACCESS(L, I) (ISINRANGE(I, 1, length(L))? L[I] : null)
// Returns the key based on the index
#define KEYBYINDEX(L, index) (((index <= length(L)) && (index > 0)) ? L[index] : null)

/// sanitize a lazy null-or-entry-or-list into always a list
#define COERCE_OPTIONS_LIST(Entry) (islist(Entry)? Entry : (isnull(Entry)? list() : list(Entry)))
/// COERCE_OPTIONS_LIST but does it to an existing variable.
#define COERCE_OPTIONS_LIST_IN(Variable) Variable = COERCE_OPTIONS_LIST(Variable)

/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]
/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]

/****
	* Binary search sorted insert
	* Sorts low to high.
	*
	* * INPUT: Object to be inserted
	* * LIST: List to insert object into
	* * TYPECONT: The typepath of the contents of the list
	* * COMPARE: The object to compare against, usualy the same as INPUT
	* * COMPARISON: The variable on the objects to compare
	* * COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
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
