/**
 * ## Atom Worth System
 *
 * In actuality, just a bunch of modules determining what something is relatively priced at / normalizing pricing.
 *
 * Variables for this system are defined at the types involved, and all getters are procs
 * for modularity reasons.
 */

/**
 * estimate an atom's total worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 */
/atom/proc/get_worth(flags = GET_WORTH_DEFAULT, buying)
	#warn impl

/atom/proc/get_materials_worth(flags, buying)

/atom/proc/get_containing_worth(flags, buying)
