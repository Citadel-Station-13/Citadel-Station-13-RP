/**
 * allows things to get contaminated by passing radiation waves.
 * 
 * said thing needs to be hit with rad_act for this to work,
 * so use /datum/component/radiation_listener if you need it to
 * receive rad_act inside of something.
 */
/datum/component/latently_radioactive
	/// strength left
	var/strength_left
	/// multiplier for catalyzing our latent radioactivity
	var/activation_multiplier = 0.01 // slow buildup, even in chain reactions.

/datum/component/latently_radioactive/Initialize(strength_left = 1000)
	src.strength_left = strength_left
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
