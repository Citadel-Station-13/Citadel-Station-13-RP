/datum/legacy_exported_crate
	/// name of crate
	var/name = "Unknown"
	/// total value of crate
	var/value = 0
	/// list("object" = name, "value" = value, "quantity" = quantity)
	var/list/contents = list()

/datum/legacy_exported_crate/clone()
	var/datum/legacy_exported_crate/cloning = new
	cloning.name = name
	cloning.value = value
	cloning.contents = deep_copy_list(contents)
	return cloning
