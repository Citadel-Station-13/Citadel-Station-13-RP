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

#warn impl
