/// Requires absolute stillness from the user
#define DO_AFTER_DISALLOW_MOVING_ABSOLUTE_USER		(1<<0)
/// Requires absolute stillness from the target
#define DO_AFTER_DISALLOW_MOVING_ABSOLUTE_TARGET	(1<<1)
/// Requires that the user is on a turf.
#define DO_AFTER_REQUIRES_USER_ON_TURF				(1<<2)
/// Requires relative stillness to our target via dx and dy coordinate difference but only if both are spacedrifting. Specify DO_AFTER_ALLOW_NONSPACEDRIFT_RELATIVITY to say otherwise.
#define DO_AFTER_DISALLOW_MOVING_RELATIVE			(1<<3)
/// Breaks if active hand item changes. Requires a tool be specified, otherwise defaults to active item
#define DO_AFTER_DISALLOW_ACTIVE_ITEM_CHANGE		(1<<4)
/// Breaks if the user has no free hands. If a tool is specified, allows that as well.
#define DO_AFTER_REQUIRE_FREE_HAND_OR_TOOL			(1<<5)
/// Do not display progressbar.
#define DO_AFTER_NO_PROGRESSBAR						(1<<6)
/// Do not check do_after_coefficient()
#define DO_AFTER_NO_COEFFICIENT						(1<<7)
/// For relative stillness, allow non spacedrift relative movement
#define DO_AFTER_ALLOW_NONSPACEDRIFT_RELATIVITY		(1<<8)

/// Ignores checks.
#define DO_AFTER_PROCEED		"PROCEED"
/// Uses all other checks
#define DO_AFTER_CONTINUE		"CONTINUE"
/// Breaks
#define DO_AFTER_STOP			"STOP"

/// Stage - initiating a do_after
#define DO_AFTER_STARTING 1
/// Stage - main loop of a do_after
#define DO_AFTER_PROGRESSING 2
/// Stage - Last check of a do_after
#define DO_AFTER_FINISHING 3

//! Interaction Checks
#define INTERACTING_WITH(M, A) M.interacting_with?[A]
#define INTERACTING_WITH_FOR(M, A, T) (M.interacting_with?[A]?[T])
#define START_INTERACTING_WITH(M, A, T) do {if(!M.interacting_with){M.interacting_with = list();}; var/list/_L = M.interacting_with; if(!_L[A]){_L[A] = list()}; ++_L[A][T]; if(!A.interacting_mobs){A.interacting_mobs = list()}; ++A.interacting_mobs[M];} while(FALSE);
#define STOP_INTERACTING_WITH(M, A, T) do {if(M.interacting_with?[A]?[T]){--M.interacting_with[A][T]; if(M.interacting_with[A][T] <= 0){M.interacting_with[A] -= T}; if(!length(M.interacting_with[A])){M.interacting_with -= A};}; if(!length(M.interacting_with)){M.interacting_with = null}; if(A.interacting_mobs){--A.interacting_mobs[M]; if(A.interacting_mobs[M] <= 0){A.interacting_mobs -= M};}; if(!length(A.interacting_mobs)){A.interacting_mobs = null};} while(FALSE);
#define INTERRUPT_INTERACTION(M, A) M.interacting_with?.Remove(A)
#define INTERRUPT_INTERACTION_FOR(M, A, T) M.interacting_with?[A]?.Remove(T)
#define IS_INTERACTING_WITH_SOMETHING(M) !!length(M.interacting_with)

//! Interactiong Types
/// Generic do after
#define INTERACTING_FOR_DO_AFTER "do_after"
/// Dynaimc tool usage in progress
#define INTERACTING_FOR_DYNAMIC_TOOL "dynamic_tools"
