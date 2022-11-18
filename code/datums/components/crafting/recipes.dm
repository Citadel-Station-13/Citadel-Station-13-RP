/datum/crafting_recipe
	/// In-game display name.
	var/name = ""
	/// Type paths of items consumed associated with how many are needed.
	var/list/reqs = list()
	/// Type paths of items explicitly not allowed as an ingredient.
	var/list/blacklist = list()
	/// Type path of item resulting from this craft.
	var/result
	/// Type paths of items needed but not consumed.
	var/list/tools = list()
	/// Time in deciseconds.
	var/time = 30
	/// Type paths of items that will be placed in the result.
	var/list/parts = list()
	/// Like tools but for reagents.
	var/list/chem_catalysts = list()
	/// Where it shows up in the crafting UI.
	var/category    = CAT_NONE
	var/subcategory = CAT_NONE
	/// Set to FALSE if it needs to be learned first.
	var/always_available = TRUE

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result

/**
 * Run custom pre-craft checks for this recipe
 *
 * user: The /mob that initiated the crafting
 * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
 */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE
