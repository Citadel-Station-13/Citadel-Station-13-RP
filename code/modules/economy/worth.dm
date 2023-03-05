/**
 * ## Atom Worth System
 *
 * In actuality, just a bunch of modules determining what something is relatively priced at / normalizing pricing.
 *
 * Variables for this system are defined at the types involved, and all getters are procs
 * for modularity reasons.
 */

/**
 * gets our worth
 */
/atom/proc/worth(flags = GET_WORTH_DEFAULT, buying)
	return worth_provider().get_worth(flags, buying)

/**
 * estimate our total worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 * * buying - buying instead of selling
 *
 * @return worth as number
 */
/atom/proc/get_worth(flags, buying)
	. = 0
	if(flags & GET_WORTH_INTRINSIC)
		. = worth_intrinsic
	if(flags & GET_WORTH_MATERIALS)
		. += get_materials_worth(flags, buying)
	if(flags & GET_WORTH_CONTAINING)
		. += get_containing_worth(flags, buying)
	if(buying)
		. *= worth_buy_factor

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
	return 0

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
	. = 0
	for(var/atom/target as anything in worth_containing(flags, buying))
		. += target.worth(flags, buying)

/**
 * gets relevant atoms inside us to be checked for containing worth
 */
/atom/proc/worth_containing(flags, buying)
	return list()

/**
 * used to change the "real" target of what we're checking the worth of.
 *
 * usefulf for things like skateboards and roller beds.
 */
/atom/proc/worth_provider()
	RETURN_TYPE(/atom)
	return src

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
	var/atom/fetching = path
	if(initial(fetching.worth_dynamic))
		return null
	. = initial(fetching.worth_intrinsic)
	. += get_materials_worth_static(path, flags, buying)
	. += get_containing_worth_static(path, flags, buying)

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
	var/atom/fetching = path
	return initial(fetching.worth_materials)

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
	var/atom/fetching = path
	return initial(fetching.worth_containing)
