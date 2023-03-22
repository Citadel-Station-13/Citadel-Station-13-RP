/datum/component/radiation_listener

/datum/component/radiation_listener/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/radiation_listener/RegisterWithParent()
	. = ..()
	#warn impl

/datum/component/radiation_listener/UnregisterFromParent()
	. = ..()
	#warn impl
