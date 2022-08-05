//? Medical system defines go in here

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
