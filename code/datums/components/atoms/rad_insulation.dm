// todo: element
/datum/component/rad_insulation
	can_transfer = FALSE
	var/amount					// Multiplier for radiation strength passing through

/datum/component/rad_insulation/Initialize(_amount = RAD_INSULATION_MEDIUM, protects = TRUE, contamination_proof = TRUE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	var/atom/A = parent

	if(protects) // Does this protect things in its contents from being affected?
		A.add_rad_block_contents(TRAIT_SOURCE_COMPONENT_RAD_INSULATION)
	if(contamination_proof) // Can this object be contaminated?
		RegisterSignal(parent, COMSIG_ATOM_RAD_CONTAMINATING, .proc/rad_contaminating)
	if(_amount != 1) // If it's 1 it wont have any impact on radiation passing through anyway
		RegisterSignal(parent, COMSIG_ATOM_RAD_WAVE_PASSING, .proc/rad_pass)

	amount = _amount

/datum/component/rad_insulation/UnregisterFromParent()
	. = ..()
	var/atom/A = parent
	A.remove_rad_block_contents(TRAIT_SOURCE_COMPONENT_RAD_INSULATION)
	UnregisterSignal(parent, list(
		COMSIG_ATOM_RAD_CONTAMINATING,
		COMSIG_ATOM_RAD_WAVE_PASSING
	))

/datum/component/rad_insulation/proc/rad_contaminating(datum/source, strength)
	return COMPONENT_BLOCK_CONTAMINATION

/datum/component/rad_insulation/proc/rad_pass(datum/source, datum/radiation_wave/wave, width)
	wave.current_intensity = wave.current_intensity*(1-((1-amount)/width)) // The further out the rad wave goes the less it's affected by insulation (larger width)
	return COMPONENT_RAD_WAVE_HANDLED
