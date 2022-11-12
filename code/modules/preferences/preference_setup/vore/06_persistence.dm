/// Persist spawnpoint based on location of despawn/logout.
#define PERSIST_SPAWN		0x01
/// Persist mob weight
#define PERSIST_WEIGHT		0x02
/// Persist the status (normal/amputated/robotic/etc) and model (for robotic) status of organs
#define PERSIST_ORGANS		0x04
/// Persist markings
#define PERSIST_MARKINGS	0x08
/// Persist size
#define PERSIST_SIZE		0x10
/// Number of valid bits in this bitflag.  Keep this updated!
#define PERSIST_COUNT		5
/// Default setting for new folks
#define PERSIST_DEFAULT		PERSIST_SPAWN|PERSIST_ORGANS|PERSIST_MARKINGS|PERSIST_SIZE
// Define a place to save in character setup
/datum/preferences
	var/persistence_settings = PERSIST_DEFAULT	// Control what if anything is persisted for this character between rounds.

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/persistence
	name = "Persistence"
	sort_order = 6

/datum/category_item/player_setup_item/vore/persistence/load_character(var/savefile/S)
	S["persistence_settings"]		>> pref.persistence_settings
	sanitize_character() // Don't let new characters start off with nulls

/datum/category_item/player_setup_item/vore/persistence/save_character(var/savefile/S)
	S["persistence_settings"]		<< pref.persistence_settings

/datum/category_item/player_setup_item/vore/persistence/sanitize_character()
	pref.persistence_settings		= sanitize_integer(pref.persistence_settings, 0, (1<<(PERSIST_COUNT+1)-1), initial(pref.persistence_settings))

/datum/category_item/player_setup_item/vore/persistence/content(datum/preferences/prefs, mob/user, data)
	. = list()
	. += "<b>Round-to-Round Persistence</b><br>"
	. += "<table>"

	. += "<tr><td title=\"Set spawn location based on where you cryo'd out.\">Save Spawn Location: </td>"
	. += make_yesno(PERSIST_SPAWN)
	. += "</tr>"

	. += "<tr><td title=\"Save your character's weight until next round.\">Save Weight: </td>"
	. += make_yesno(PERSIST_WEIGHT)
	. += "</tr>"

	. += "<tr><td title=\"Update organ preferences (normal/amputated/robotic/etc) and model (for robotic) based on what you have at round end.\">Save Organs: </td>"
	. += make_yesno(PERSIST_ORGANS)
	. += "</tr>"

	. += "<tr><td title=\"Update marking preferences (type and color) based on what you have at round end.\">Save Markings: </td>"
	. += make_yesno(PERSIST_MARKINGS)
	. += "</tr>"

	. += "<tr><td title=\"Update character scale based on what you were at round end.\">Save Scale: </td>"
	. += make_yesno(PERSIST_SIZE)
	. += "</tr>"

	. += "</table>"
	return jointext(., "")

/datum/category_item/player_setup_item/vore/persistence/proc/make_yesno(var/bit)
	if(pref.persistence_settings & bit)
		return "<td><span class='linkOn'><b>Yes</b></span></td> <td><a href='?src=\ref[src];toggle_off=[bit]'>No</a></td>"
	else
		return "<td><a href='?src=\ref[src];toggle_on=[bit]'>Yes</a></td> <td><span class='linkOn'><b>No</b></span></td>"

/datum/category_item/player_setup_item/vore/persistence/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_on"])
		var/bit = text2num(href_list["toggle_on"])
		pref.persistence_settings |= bit
		return PREFERENCES_REFRESH
	else if(href_list["toggle_off"])
		var/bit = text2num(href_list["toggle_off"])
		pref.persistence_settings &= ~bit
		return PREFERENCES_REFRESH
	return ..()
