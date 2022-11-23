//! mobs
// apply_effect((amount*RAD_MOB_COEFFICIENT)/max(1, (radiation**2)*RAD_OVERDOSE_REDUCTION), IRRADIATE, blocked)
#define RAD_MOB_COEFFICIENT 0.20					// Radiation applied is multiplied by this
#define RAD_MOB_SKIN_PROTECTION ((1/RAD_MOB_COEFFICIENT)+RAD_BACKGROUND_RADIATION)

// #define RAD_LOSS_PER_TICK 0.5
// #define RAD_TOX_COEFFICIENT 0.05					// Toxin damage per tick coefficient
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
