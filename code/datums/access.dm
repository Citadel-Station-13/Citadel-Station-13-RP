/datum/access
	abstract_type = /datum/access

	/// access constnat
	var/access_value
	/// access region
	var/access_region = ACCESS_REGION_NONE
	/// access category
	var/access_category = "Misc"
	/// access type
	var/access_type = ACCESS_TYPE_NONE
	/// access name
	var/access_name = "Unknown"

	/// Sort order; if the same, we go by name. Higher first.
	var/sort_order = 0

	//? it's weird to have region and type without a 2d array huh
	//? explanation:
	//? there's almost no cases where you want to grant type edit
	//? without region edit, or that you'd grant only partial type edit
	//? it's almost impossible to need more than 24 regions unless
	//? we somehow get more than 20 departments, since
	//? centcom is one, and we might get 2-3 special's
	//? but stuff like pirates/mercs/whatever would get their own
	//? not-quite-region.

	//* all of the below act *additively*

	/// access region flags this access can edit
	var/access_edit_region = NONE
	/// access type flags this access can edit
	var/access_edit_type = NONE
	/// list of access datums by typepath that this access can also control
	var/list/access_edit_list
	/// a single access category that's set to allow easily setting categorical edit without edit_list
	var/access_edit_category

/datum/access/compare_to(datum/access/D)
	return (src.sort_order == D.sort_order)? (sorttext(D.access_name, src.access_name)) : (D.sort_order - src.sort_order)

/**
 * check if we're able to grant permission to edit atleast one other access
 */
/datum/access/proc/is_edit_relevant()
	return access_edit_region || access_edit_type || access_edit_category || length(access_edit_list)

/datum/access/station
	abstract_type = /datum/access/station
	access_type = ACCESS_TYPE_STATION

/datum/access/station/security
	abstract_type = /datum/access/station/security
	access_region = ACCESS_REGION_SECURITY
	access_category = "Security"

/datum/access/station/general
	abstract_type = /datum/access/station/general
	access_region = ACCESS_REGION_GENERAL
	access_category = "General"

/datum/access/station/command
	abstract_type = /datum/access/station/command
	access_region = ACCESS_REGION_COMMAND
	access_category = "Command"

/datum/access/station/medical
	abstract_type = /datum/access/station/medical
	access_region = ACCESS_REGION_MEDBAY
	access_category = "Medical"

/datum/access/station/supply
	abstract_type = /datum/access/station/supply
	access_region = ACCESS_REGION_SUPPLY
	access_category = "Supply"

/datum/access/station/engineering
	abstract_type = /datum/access/station/engineering
	access_region = ACCESS_REGION_ENGINEERING
	access_category = "Engineering"

/datum/access/station/science
	abstract_type = /datum/access/station/science
	access_region = ACCESS_REGION_RESEARCH
	access_category = "Science"

/datum/access/centcom
	abstract_type = /datum/access/centcom
	access_type = ACCESS_TYPE_CENTCOM
	access_category = "Centcom"

/datum/access/syndicate
	abstract_type = /datum/access/syndicate
	access_type = ACCESS_TYPE_SYNDICATE
	access_category = "Syndicate"

/datum/access/faction
	abstract_type = /datum/access/faction
	access_type = ACCESS_TYPE_PRIVATE
	access_category = "Faction"

/datum/access/misc
	abstract_type = /datum/access/misc
	access_type = ACCESS_TYPE_NONE
	access_category = "Unknown"

/datum/access/special
	abstract_type = /datum/access/special
	access_type = ACCESS_TYPE_NONE
	access_category = "Special"
