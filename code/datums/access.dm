/datum/prototype/access
	abstract_type = /datum/prototype/access

	/// access constnat
	var/access_value
	/// access region
	var/access_region = ACCESS_REGION_NONE
	/// access category - *overrides* region if set; this is for "minor accesses" like factional stuff
	var/access_category
	/// access type
	var/access_type = ACCESS_TYPE_NONE
	/// access name
	var/access_name = "Unknown"

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

#warn make sure this is sorted by name within its category.
#warn see if it's possible to unregister prototypes on destroy

/datum/prototype/access/register()
	#warn impl and check params from root on merge

/datum/prototype/access/unregister()
	#warn ditto

/datum/prototype/access/station
	abstract_type = /datum/prototype/access/station
	access_type = ACCESS_TYPE_STATION

/datum/prototype/access/station/security
	abstract_type = /datum/prototype/access/station/security
	access_region = ACCESS_REGION_SECURITY

/datum/prototype/access/station/general
	abstract_type = /datum/prototype/access/station/general
	access_region = ACCESS_REGION_GENERAL

/datum/prototype/access/station/command
	abstract_type = /datum/prototype/access/station/command
	access_region = ACCESS_REGION_COMMAND

/datum/prototype/access/station/medical
	abstract_type = /datum/prototype/access/station/medical
	access_region = ACCESS_REGION_MEDBAY

/datum/prototype/access/station/supply
	abstract_type = /datum/prototype/access/station/supply
	access_region = ACCESS_REGION_SUPPLY

/datum/prototype/access/station/engineering
	abstract_type = /datum/prototype/access/station/engineering
	access_region = ACCESS_REGION_ENGINEERING

/datum/prototype/access/station/science
	abstract_type = /datum/prototype/access/station/science
	access_region = ACCESS_REGION_RESEARCH

/datum/prototype/access/centcom
	abstract_type = /datum/prototype/access/centcom
	access_type = ACCESS_TYPE_CENTCOM

/datum/prototype/access/syndicate
	abstract_type = /datum/prototype/access/syndicate
	access_type = ACCESS_TYPE_SYNDICATE

/datum/prototype/access/faction
	abstract_type = /datum/prototype/access/faction
	access_type = ACCESS_TYPE_PRIVATE

/datum/prototype/access/misc
	abstract_type = /datum/prototype/access/misc
	access_type = ACCESS_TYPE_NONE

/datum/prototype/access/special
	abstract_type = /datum/prototype/access/special
	access_type = ACCESS_TYPE_NONE
