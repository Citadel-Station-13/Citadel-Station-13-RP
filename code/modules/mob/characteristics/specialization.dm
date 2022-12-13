GLOBAL_LIST_INIT(characteristics_specializations, _create_characteristics_specializations())

/proc/_create_characteristics_specializations()

/**
 * gets a specialization datum
 *
 * use typepaths whenever possible for compile time!
 */
/proc/resolve_characteristics_specialization(datum/characteristic_specialization/typepath_or_id)
	if(ispath(typepath_or_id))
		return GLOB.characteristics_specializations[initial(typepath_or_id[id])]
	ASSERT(istext(typepath_or_id))
	return GLOB.characteristics_specializations[typepath_or_id]

/**
 * specializations - more enum-like numerics/whatnot than boolean-like talents
 * are held in specialization holder
 */
/datum/characteristic_specialization
	abstract_type = /datum/characteristic_specialization
	/// unique id
	var/id
	/// name
	var/name = "ERROR"
	/// desc
	var/desc = "An unknown specialization. Someone needs to set this!"

	#warn specializations?

	#warn scaling


