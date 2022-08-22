//? Medical system defines go in here

//! Health - Core
/** Round damage values to this value
 * Atom damage uses this too!
 */
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

//! direct stat helpers
#define STAT_IS_CONSCIOUS(N)			(N == CONSCIOUS)
#define STAT_IS_DEAD(N)					(N == DEAD)

//! CPR
/// how long CPR suppresses brain decay
#define CPR_BRAIN_STASIS_TIME					(15 SECONDS)
/// how long CPR acts as mechanical ventilation
#define CPR_VENTILATION_TIME					(10 SECONDS)
/// how long CPR acts as mechanical circulation
#define CPR_CIRCULATION_TIME					(7 SECONDS)
/// how long CPR takes to do
#define CPR_ACTION_TIME							(3 SECONDS)
/// how long CPR is on nominal cooldown (doing it faster is less effective)
#define CPR_NOMINAL_COOLDOWN					(7 SECONDS)
/// nominal CPR reagent tick strength (as multiplier of normal living)
#define CPR_FORCED_METABOLISM_STRENGTH_NOMINAL	(7)								// 100% as effective as living
/// on-cooldown reagent tick strength (as multiplier of normal living)
#define CPR_FORCED_METABOLISM_STRENGTH_CLIPPED	(3 * 0.5)								// 50% as effective as living at best

//! Organs - General

//! Organs - Decaying while dead/removed
//? current formula is generally (maxhealth / (seconds to decay))
/// how much damage most organs take per second when the user is dead and it is not preserved
#define ORGAN_DECAY_PER_SECOND_DEFAULT			(60 / (60 * 40))				// most organs decay entirely over 40 minutes, or to lethal degrees in 20
/// how much damage the brain takes per second when the user is dead and it is not preserved
#define ORGAN_DECAY_PER_SECOND_BRAIN			(60 / (60 * 10))				// brain decays entirely over 10 minutes, or to lethal degrees in 5


