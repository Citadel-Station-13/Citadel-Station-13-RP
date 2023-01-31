//* economy payscale:
//* round(max(0,
//* STARTING_BASE * MULT *
//* /datum/department/var/economy_payscale * /datum/job/var/economy_payscale *
//* (multiply together background lore modifiers here) *
//* economic_status +
//* gaussian(RANDOM_MEAN, RANDOM_DEV)))

#define ECONOMY_PAYSCALE_BASE 500
#define ECONOMY_PAYSCALE_MULT 1

#define ECONOMY_PAYSCALE_RANDOM_MEAN 5
#define ECONOMY_PAYSCALE_RANDOM_DEV 45

#define ECONOMY_PAYSCALE_DEPT_DEFAULT 1
#define ECONOMY_PAYSCALE_DEPT_SCI 3
#define ECONOMY_PAYSCALE_DEPT_MED 3
#define ECONOMY_PAYSCALE_DEPT_SEC 2.5
#define ECONOMY_PAYSCALE_DEPT_ENG 2.5
#define ECONOMY_PAYSCALE_DEPT_CIV 1.5
#define ECONOMY_PAYSCALE_DEPT_SUP 2
// command is just HoP / bridge officer / captain
#define ECONOMY_PAYSCALE_DEPT_COM 2

//? /datum/job multiplier

// default
#define ECONOMY_PAYSCALE_JOB_DEFAULT 1
// miners, explorers
#define ECONOMY_PAYSCALE_JOB_DANGER 1.25
// pilots, bridge officers
#define ECONOMY_PAYSCALE_JOB_HELM 2
// senior roles
#define ECONOMY_PAYSCALE_JOB_SENIOR 1.5
// head of staff
#define ECONOMY_PAYSCALE_JOB_COMMAND 2
// captain
#define ECONOMY_PAYSCALE_JOB_CAPTAIN 3
// centcom
#define ECONOMY_PAYSCALE_JOB_ADMIN 10

//? Economic Class (Legacy)

GLOBAL_LIST_INIT(economic_class_payscale_lookup, list(
	CLASS_UPPER = 1.1,
	CLASS_MIDDLE = 1,
	CLASS_LOWMID = 0.75,
	CLASS_LOWISH = 0.5,
	CLASS_LOW = 1/3,
))
