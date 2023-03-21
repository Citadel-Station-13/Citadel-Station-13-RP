//? do_after

//? Interaction Checks
/// checks if we're interacting with an atom
#define INTERACTING_WITH(M, A) M.interacting_with?[A]
/// checks if we're interacting with an atom for a certain type
#define INTERACTING_WITH_FOR(M, A, T) (M.interacting_with?[A]?[T])
/// start interacting with something for a reason. you MUST stop it always, make sure it works!! or there's going to be lingering references and bad things!!
#define START_INTERACTING_WITH(M, A, T) do {if(!M.interacting_with){M.interacting_with = list();}; var/list/_L = M.interacting_with; if(!_L[A]){_L[A] = list()}; ++_L[A][T]; if(!A.interacting_mobs){A.interacting_mobs = list()}; ++A.interacting_mobs[M];} while(FALSE);
/// stop interacting with something for a reason.
#define STOP_INTERACTING_WITH(M, A, T) do {if(M.interacting_with?[A]?[T]){--M.interacting_with[A][T]; if(M.interacting_with[A][T] <= 0){M.interacting_with[A] -= T}; if(!length(M.interacting_with[A])){M.interacting_with -= A};}; if(!length(M.interacting_with)){M.interacting_with = null}; if(A.interacting_mobs){--A.interacting_mobs[M]; if(A.interacting_mobs[M] <= 0){A.interacting_mobs -= M};}; if(!length(A.interacting_mobs)){A.interacting_mobs = null};} while(FALSE);
/// interrupts all (checked) interactions with an atom. whatever is interacting MUST actually check INTERACTING_WITH for this to work!
#define INTERRUPT_INTERACTION(M, A) M.interacting_with?.Remove(A)
/// interrupts all (checked) interactions of a type with an atom. whatever is interacting MUST actually check INTERACTING_WITH for this to work!
#define INTERRUPT_INTERACTION_FOR(M, A, T) M.interacting_with?[A]?.Remove(T)
/// checks if we're interacting with *anything* for *any* reason.
#define IS_INTERACTING_WITH_SOMETHING(M) !!length(M.interacting_with)

//? Interactiong Types
/// Generic do after
#define INTERACTING_FOR_DO_AFTER "do_after"
/// Dynaimc tool usage in progress
#define INTERACTING_FOR_DYNAMIC_TOOL "dynamic_tools"
/// Generic 'something' in attack hand
#define INTERACTING_FOR_ATTACK_HAND "attack_hand"
/// Generic 'something' in alt click
#define INTERACTING_FOR_ALT_CLICK "alt_click"
