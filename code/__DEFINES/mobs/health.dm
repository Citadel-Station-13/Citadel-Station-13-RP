//? Medical system defines go in here

//! Health - Core
/// Round damage values to this value
#define DAMAGE_PRECISION			0.01

//! Stat var - lets us get the most basic of mob health status from one var
/// we're conscious
#define CONSCIOUS   0
/// we're unconscious
#define UNCONSCIOUS 1
/// we're dead
#define DEAD        2

//! stat helpers - since most semantic checks are going to be compound checks
#define IS_CONSCIOUS(M)			(M.stat == CONSCIOUS)
#define IS_DEAD(M)				(M.stat == DEAD)

//! CPR
/// how long CPR suppresses brain decay
#define CPR_BRAIN_STASIS_TIME					(15 SECONDS)
/// how long CPR acts as mechanical ventilation
#define CPR_VENTILATION_TIME					(10 SECONDS)
/// how long CPR takes to do
#define CPR_ACTION_TIME							(3 SECONDS)
/// how long CPR is on nominal cooldown (doing it faster is less effective)
#define CPR_NOMINAL_COOLDOWN					(7 SECONDS)
/// nominal CPR reagent tick strength (as multiplier of normal living)
#define CPR_FORCED_METABOLISM_STRENGTH_NOMINAL	(2/3 * 7)				// 66% as effective as living
/// on-cooldown reagent tick strength (as multiplier of normal living)
#define CPR_FORCED_METABOLISM_STRENGTH_CLIPPED	(1)						// 33% as effective as living

//! Organs - General

//! Organs - Decaying while dead
/// how much damage the brain takes per second when the user is dead and it is not preserved
#define ORGAN_DECAY_PER_SECOND_BRAIN			(60 / (5 MINUTES) * 10)		// 0 to 60 damage in 5 minutes when unmitigated
