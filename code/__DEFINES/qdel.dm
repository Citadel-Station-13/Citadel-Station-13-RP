//defines that give qdel hints. these can be given as a return in destory() or by calling


///qdel should queue the object for deletion.
#define QDEL_HINT_QUEUE 		0
///qdel should let the object live after calling destory.
#define QDEL_HINT_LETMELIVE		1
///functionally the same as the above. qdel should assume the object will gc on its own, and not check it.
#define QDEL_HINT_IWILLGC		2
///qdel should assume this object won't gc, and queue a hard delete using a hard reference.
#define QDEL_HINT_HARDDEL		3
///qdel should assume this object won't gc, and hard del it post haste.
#define QDEL_HINT_HARDDEL_NOW	4
//defines for the gc_destroyed var


#ifdef REFERENCE_TRACKING
/** If REFERENCE_TRACKING is enabled, qdel will call this object's find_references() verb.
 *
 * Functionally identical to [QDEL_HINT_QUEUE] if [GC_FAILURE_HARD_LOOKUP] is not enabled in _compiler_options.dm.
*/
#warn TG0001 qdel REFERENCE_TRACKING enabled
#define QDEL_HINT_FINDREFERENCE 5
/// Behavior as [QDEL_HINT_FINDREFERENCE], but only if the GC fails and a hard delete is forced.
#define QDEL_HINT_IFFAIL_FINDREFERENCE 6
#endif

// Defines for the ssgarbage queues
#define GC_QUEUE_FILTER 1 //! short queue to filter out quick gc successes so they don't hang around in the main queue for 5 minutes
#define GC_QUEUE_CHECK 2 //! main queue that waits 5 minutes because thats the longest byond can hold a reference to our shit.
#define GC_QUEUE_HARDDELETE 3 //! short queue for things that hard delete instead of going thru the gc subsystem, this is purely so if they *can* softdelete, they will soft delete rather then wasting time with a hard delete.
#define GC_QUEUE_COUNT 3 //! Number of queues, used for allocating the nested lists. Don't forget to increase this if you add a new queue stage

// Defines for the ssgarbage queue items
#define GC_QUEUE_ITEM_QUEUE_TIME 1 //! Time this item entered the queue
#define GC_QUEUE_ITEM_REF 2 //! Ref to the item
#define GC_QUEUE_ITEM_GCD_DESTROYED 3 //! Item's gc_destroyed var value. Used to detect ref reuse.
#define GC_QUEUE_ITEM_INDEX_COUNT 3 //! Number of item indexes, used for allocating the nested lists. Don't forget to increase this if you add a new queue item index

// Defines for the time an item has to get its reference cleaned before it fails the queue and moves to the next.
#define GC_FILTER_QUEUE (1 SECONDS)
#define GC_CHECK_QUEUE (5 MINUTES)
#define GC_DEL_QUEUE (10 SECONDS)

#define QDEL_ITEM_ADMINS_WARNED (1<<0) //! Set when admins are told about lag causing qdels in this type.
#define QDEL_ITEM_SUSPENDED_FOR_LAG (1<<1) //! Set when a type can no longer be hard deleted on failure because of lag it causes while this happens.

// Defines for the [gc_destroyed][/datum/var/gc_destroyed] var.
#define GC_CURRENTLY_BEING_QDELETED -2

#define QDELING(X) (X.gc_destroyed)
#define QDELETED(X) (!X || QDELING(X))
#define QDESTROYING(X) (!X || X.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)

//* Qdel helper macros. *//

/// qdel something in a specific amount of time. returns a timer ID.
#define QDEL_IN(item, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), item), time, TIMER_STOPPABLE)
/// qdel something in a specific amount of real (wall) time. returns a timer ID.
#define QDEL_IN_CLIENT_TIME(item, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), item), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
/// qdel's something and nulls it out
#define QDEL_NULL(item) qdel(item); item = null
/// qdel's all the elements in a list and then nulls the list out.
#define QDEL_NULL_LIST QDEL_LIST_NULL
/// qdel's all the elements in a list and then nulls the list out.
#define QDEL_LIST_NULL(x) if(x) { for(var/y in x) { qdel(y) } ; x = null }
/// qdels the elements in a list and proceed to cut the list. in an asosciative list, this will qdelete the keys.
#define QDEL_LIST(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
/// Qdel every item in the list before setting the list to null. Can't cut it because the lazylist will already be nulled in some cases.
#define QDEL_LAZYLIST(L) for(var/I in L) qdel(I); L = null;
/// QDEL_LIST in a specific amount of time
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(______qdel_list_wrapper), L), time, TIMER_STOPPABLE)
/// qdel's both the keys and the values of an associative list, and then cut the list.
#define QDEL_LIST_ASSOC(L) if(L) { for(var/I in L) { qdel(L[I]); qdel(I); } L.Cut(); }
/// qdel()'s the value associations of an associative list, and then cut the list.
#define QDEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) qdel(L[I]); L.Cut(); }

/proc/______qdel_list_wrapper(list/L) //the underscores are to encourage people not to use this directly.
	QDEL_LIST(L)
