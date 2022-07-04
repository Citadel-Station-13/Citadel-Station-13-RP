GLOBAL_LIST_INIT(admin_verbs, init_admin_verbs())

/proc/init_admin_verbs()
	. = list()

/proc/recreate_admin_verbs()
	GLOB.admin_verbs = init_admin_verbs()
	// reset people's admin panels

/proc/fetch_admin_verb(path)
	return GLOB.admin_verbs[path]

#warn finish
#warn unit test for id + name uniqueness
/**
 * individual, piecewise actions
 * these are singletons.
 * do not put anything important like vv on these - those are too integral.
 *
 * define these with ADMIN_VERB_DEF(id, name, category, args).
 */
/datum/admin_verb
	/// verb category
	var/category = "Admin - Unsorted"
	/// verb name
	var/name = "Unknown Verb"
	/// rights required - all
	var/rights_required_all = NONE
	/// rights required - one
	var/rights_required_one = NONE
	/// are we a byond verb? if not, we need to be added to the tgui admin panel on one of the categories.
	var/client_verb = FALSE
	/// verb path
	var/verb_path

/**
 * invoke
 */
/datum/admin_verb/proc/Invoke()
	SHOULD_NOT_OVERRIDE(TRUE)
	// rights check
	Run()

/**
 * run - override this
 */
/datum/admin_verb/proc/Run()
