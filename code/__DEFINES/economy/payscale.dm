/**
 * payscale
 *
 * * this determines how much money people start the round with
 * * this in the future may determine how money is distributed in-round,
 *   but probably not
 * * if someone is in multiple departments, the highest value is taken
 *
 * | formula: BASE * MULT * department payscale * job payscale * background lore
 * |                      * economic status
 * |                      * gaussian(RANDOM_MULT_MEAN, RANDOM_MULT_DEV)
 * |                      + gaussian(RANDOM_ADD_MEAN, RANDOM_ADD_DEV)
 */

#define ECONOMY_PAYSCALE_BASE ECONOMY_BASE_BALANCE_FOR_CREW
#define ECONOMY_PAYSCALE_MULT 1

#define ECONOMY_PAYSCALE_RANDOM_MULT_MEAN 1
#define ECONOMY_PAYSCALE_RANDOM_MULT_DEV 0.015

#define ECONOMY_PAYSCALE_RANDOM_ADD_MEAN 15
#define ECONOMY_PAYSCALE_RANDOM_ADD_DEV 45

//* departments *//

#define ECONOMY_PAYSCALE_DEPT_DEFAULT 1
#define ECONOMY_PAYSCALE_DEPT_CENTCOM 3
#define ECONOMY_PAYSCALE_DEPT_COM 1.5
#define ECONOMY_PAYSCALE_DEPT_SCI 1.333
#define ECONOMY_PAYSCALE_DEPT_MED 1.333
#define ECONOMY_PAYSCALE_DEPT_ENG 1.333
#define ECONOMY_PAYSCALE_DEPT_SEC 1.25
#define ECONOMY_PAYSCALE_DEPT_SUP 1.25
#define ECONOMY_PAYSCALE_DEPT_CIV 1.125

//* jobs *//

// default
#define ECONOMY_PAYSCALE_JOB_DEFAULT 1
// miners, explorers
#define ECONOMY_PAYSCALE_JOB_DANGER 1.25
// senior roles
#define ECONOMY_PAYSCALE_JOB_SENIOR 1.25

//? Economic Class (Legacy) ?//
// todo: rework

GLOBAL_LIST_INIT(economic_class_payscale_lookup, list(
	CLASS_UPPER = 1.1,
	CLASS_MIDDLE = 1,
	CLASS_LOWMID = 0.75,
	CLASS_LOWISH = 0.5,
	CLASS_LOW = 1/3,
))
