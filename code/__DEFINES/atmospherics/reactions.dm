//REACTIONS
//return values for reactions (bitflags)
/// No reaction occured
#define NO_REACTION				(NONE)
/// An reaction occured
#define REACTING				(1<<0)
/// Halt any other reaction that could still happen in this react() cycle.
#define STOP_REACTIONS 			(1<<1)
