//* persistent state keys *//

// none right now

//* local state keys *//

// none right now

#warn impl

//* Objective completion status

/// got the target/whatever
#define GAME_OBJECTIVE_SUCCESS 1
/// didn't yet get the target/whatever
#define GAME_OBJECTIVE_INCOMPLETE 2
/// failed to get the target (e.g. not physically able to anymore)
#define GAME_OBJECTIVE_FAILURE 3
/// target is no longer valid, but it isn't a failure
#define GAME_OBJECTIVE_VOIDED 4
