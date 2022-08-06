//? Medical system defines go in here

//! Stat var - lets us get the most basic of mob health status from one var
/// we're conscious
#define CONSCIOUS   0
/// we're unconscious
#define UNCONSCIOUS 1
/// we're dead
#define DEAD        2

//! stat helpers - since most semantic checks are going to be compound checks
#define IS_CONSCIOUS(M)			(M.stat == STAT_CONSCIOUS)
#define IS_DEAD(M)				(M.stat == STAT_DEAD)

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
