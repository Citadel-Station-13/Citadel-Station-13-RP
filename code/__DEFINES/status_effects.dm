
//These are all the different status effects. Use the paths for each effect in the defines.

///if it allows multiple instances of the effect
#define STATUS_EFFECT_MULTIPLE 0
///if it allows only one, preventing new instances
#define STATUS_EFFECT_UNIQUE 1
///if it allows only one, but new instances replace
#define STATUS_EFFECT_REPLACE 2
/// if it only allows one, and new instances just instead refresh the timer
#define STATUS_EFFECT_REFRESH 3
///////////
// BUFFS //
///////////

/////////////
// DEBUFFS //
/////////////

///if struck with a proto-kinetic crusher, takes a ton of damage
#define STATUS_EFFECT_CRUSHERMARK /datum/status_effect/crusher_mark
/////////////
// NEUTRAL //
/////////////
///tracks total kinetic crusher damage on a target
#define STATUS_EFFECT_CRUSHERDAMAGETRACKING /datum/status_effect/crusher_damage
/////////////
//  SLIME  //
/////////////

/////////////
// GROUPED //
/////////////
