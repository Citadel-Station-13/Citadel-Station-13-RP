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
/atom/proc/worth(flags = GET_WORTH_FLAGS_DEFAULT)
	return worth_provider().get_worth(flags)

/**
 * used to change the "real" target of what we're checking the worth of.
 *
 * useful for things like skateboards and roller beds.
 */
/atom/proc/worth_provider()
	RETURN_TYPE(/atom)
	return src

/**
 * estimate our total worth
 *
 * * Do not call this directly, call worth()
 *
 * todo: a way to get itemized worth
 * todo: the way must respect obfuscation (e.g. not accessing real names of undiscovered gases)
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 *
 * @return worth as number
 */
/atom/proc/get_worth(flags)
	return 0

//* Objs *//

/obj/get_worth(flags)
	. = 0
	if(flags & GET_WORTH_INTRINSIC)
		var/intrinsic = get_intrinsic_worth(flags)
		. += intrinsic
	if(flags & GET_WORTH_MATERIALS)
		var/materials = get_materials_worth(flags)
		. += materials
	if(flags & GET_WORTH_CONTAINING)
		var/containing = get_containing_worth(flags)
		. += containing

/**
 * estimate our intrinsic worth
 */
/obj/proc/get_intrinsic_worth(flags)
	return worth_intrinsic

/**
 * estimate our raw materials worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 *
 * @return worth as number
 */
/obj/proc/get_materials_worth(flags)
	return 0

/**
 * estimates our contents worth
 *
 * @params
 * * flags - see [code/__DEFINES/economy/worth.dm]
 *
 * @return worth as number
 */
/obj/proc/get_containing_worth(flags)
	. = 0
	for(var/obj/target as anything in worth_contents(flags))
		. += target.worth(flags)

/**
 * gets relevant atoms inside us to be checked for containing worth
 */
/obj/proc/worth_contents(flags)
	return list()
