/**
 * datums used to procedurally generate gas
 */
/datum/procedural_gas


/datum/procedural_gas/proc/instance()
	RETURN_TYPE(/datum/gas)
	var/datum/gas/G = new
	. = G
	G.id = "[GAS_ID_PREFIX_PROCGEN][++gas_data.next_procedural_gas_id]"

/datum/procedural_gas/proc/instance_and_register()

#warn impl
