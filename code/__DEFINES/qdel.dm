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
 * Functionally identical to QDEL_HINT_QUEUE if GC_FAILURE_HARD_LOOKUP is not enabled in _compiler_options.dm.
 */
#define QDEL_HINT_FINDREFERENCE	5
/// Behavior as QDEL_HINT_FINDREFERENCE, but only if the GC fails and a hard delete is forced.
#define QDEL_HINT_IFFAIL_FINDREFERENCE 6
#endif

#define GC_QUEUE_CHECK 1
#define GC_QUEUE_HARDDELETE 2
///increase this when adding more steps.
#define GC_QUEUE_COUNT 2
#define GC_QUEUED_FOR_QUEUING -1
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
/// QDEL_LIST in a specific amount of time
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(______qdel_list_wrapper), L), time, TIMER_STOPPABLE)
/// qdel's both the keys and the values of an associative list, and then cut the list.
#define QDEL_LIST_ASSOC(L) if(L) { for(var/I in L) { qdel(L[I]); qdel(I); } L.Cut(); }
/// qdel()'s the value associations of an associative list, and then cut the list.
#define QDEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) qdel(L[I]); L.Cut(); }

/proc/______qdel_list_wrapper(list/L) //the underscores are to encourage people not to use this directly.
	QDEL_LIST(L)
