/**
 * ## Atom Worth System
 *
 * In actuality, just a bunch of modules determining what something is relatively priced at / normalizing pricing.
 *
 * Variables for this system are defined at the types involved, and all getters are procs
 * for modularity reasons.
 */

/**
 * estimate our total worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number
 */
/atom/proc/get_worth(flags = GET_WORTH_DEFAULT, buying)
	#warn impl

/**
 * estimate our raw materials worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number
 */
/atom/proc/get_materials_worth(flags, buying)

/**
 * estimates our contents worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number
 */
/atom/proc/get_containing_worth(flags, buying)

/**
 * estimate a typepath's worth
 *
 * @params
 * * path - typepath to estimate
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number or null if unable
 */
/proc/get_worth_static(path, flags = GET_WORTH_DEFAULT, buying)

/**
 * estimates a typepath's raw materials worth
 *
 * @params
 * * path - typepath to estimate
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number or null if unable
 */
/proc/get_materials_worth_static(path, flags, buying)

/**
 * estimates a typepath's contents worth
 *
 * @params
 * * path - typepath to estimate
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number or null if unable
 */
/proc/get_containing_worth_static(path, flags, buying)
