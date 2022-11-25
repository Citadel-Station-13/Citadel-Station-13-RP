//! mobs
/// radiation applied via afflict_radiation is multiplied by this
#define RAD_MOB_ACT_COEFFICIENT 0.20
/// flat loss to radiation hitting mobs via rad_act
#define RAD_MOB_ACT_PROTECTION 15

// #define RAD_LOSS_PER_TICK 0.5
// #define RAD_TOX_COEFFICIENT 0.05					// Toxin damage per tick coefficient
// overdose was radiation ** 2 * overdose (?)
// #define RAD_OVERDOSE_REDUCTION 0.000001				// Coefficient to the reduction in applied rads once the thing, usualy mob, has too much radiation
// 													// WARNING: This number is highly sensitive to change, graph is first for best results
// #define RAD_BURN_THRESHOLD 1000						// Applied radiation must be over this to burn

// #define RAD_MOB_SAFE 500							// How much stored radiation in a mob with no ill effects
// #define RAD_DEFAULT_ROBOT_SAFE 250					// Like above, except for robotic carbons. Far more susceptible to corruption from radiation.
// #define RAD_UPGRADED_ROBOT_SAFE 750					// If the robot has been upgraded via an implant, their radiation threshold is raised to be somewhat above that of organics.

// #define RAD_MOB_HAIRLOSS 800						// How much stored radiation to check for hair loss

// #define RAD_MOB_MUTATE 1250							// How much stored radiation to check for mutation

// #define RAD_MONKEY_GORILLIZE 1650					// How much stored radiation to check for Harambe time.
// #define RAD_MOB_GORILLIZE_FACTOR 100
// #define RAD_MONKEY_GORILLIZE_EXPONENT 0.5

// #define RAD_MOB_VOMIT 2000							// The amount of radiation to check for vomitting
// #define RAD_MOB_VOMIT_PROB 1						// Chance per tick of vomitting

// #define RAD_MOB_KNOCKDOWN 2000						// How much stored radiation to check for stunning
// #define RAD_MOB_KNOCKDOWN_PROB 1					// Chance of knockdown per tick when over threshold
// #define RAD_MOB_KNOCKDOWN_AMOUNT 3					// Amount of knockdown when it occurs

//! stuff passed into afflict/cure_radiation

#define RAD_MOB_AFFLICT_STRENGTH_SIFSLURRY_OD(removed) (50 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_ASLIMETOXIN(removed) (50 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_SLIMETOXIN(removed) (75 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_MUTAGEN(removed) (100 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_RADIUM(removed) (100 * removed)

#define RAD_MOB_CURE_STRENGTH_HYRONALIN(removed) (50 * removed)
#define RAD_MOB_CURE_STRENGTH_ARITHRAZINE(removed) (100 * removed)
#define RAD_MOB_CURE_STRENGTH_CLEANSALAZE(removed) (25 * removed)
#define RAD_MOB_CURE_STRENGTH_MEDIGUN 150
#define RAD_MOB_CURE_STRENGTH_VODKA(removed) (20 * removed)
#define RAD_MOB_CURE_STRENGTH_GODKA(removed) (100 * removed)

//! stuff passed into rad_act
//! you should generally be using afflict radiation instead.

#define RAD_MOB_ACT_STRENGTH_
