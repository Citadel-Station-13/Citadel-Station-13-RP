/**
 * allows things to get contaminated by passing radiation waves.
 */
/datum/component/latently_radioactive
	/// strength left
	var/strength_left
	/// multiplier for catalyzing our latent radioactivity
	var/activation_multiplier = 0.01 // slow buildup, even in chain reactions.

/datum/component/latently_radioactive/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/latently_radioactive/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_RAD_ACT, .proc/on_radiated)

/datum/component/latently_radioactive/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ATOM_RAD_ACT)
	
/datum/component/latently_radioactive/proc/on_radiated(atom/source, strength, datum/radiation_wave/wave)
	#warn impl
