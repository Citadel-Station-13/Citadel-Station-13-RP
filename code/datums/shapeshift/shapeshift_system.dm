/**
 * shapeshift system
 * for ui synchronization
 */
/datum/shapeshift_system
	/// max templates to store; if 0, can only edit current appearance
	var/max_templates
	/// stored templates
	var/list/datum/shapeshift/stored
	/// our capabilities
	var/shapeshift_capability
	/// system flags
	var/shapeshift_system_flags

#warn impl

/**
 * directly transform someone into someone else
 * we do this so we pass their stuff through shapeshift serialization/deserialization
 * for equivalence purposes
 */
/datum/shapeshift_system/proc/immediate_transform(mob/transforming, mob/template, capabilities = shapeshift_capability)
