/// Gets a VSC prop from a global controller of a name by path and stores it in <varset> variable.
#define GET_VSC_PROP(controllerglobal, partialpath, varset)		var/##varset = GLOB.controllerglobal.get_value(/datum/variable_setting_entry##partialpath)
/// Like [GET_VSC_PROP] but caches the entry for faster access. In theory.
#define CACHE_VSC_PROP(controllerglobal, partialpath, varset) \
	var/static/datum/variable_setting_entry##partialpath/__cachedatum_##varset; \
	if(QDELETED(__cachedatum_##varset)){ \
		__cachedatum_##varset = GLOB.controllerglobal.get_datum(/datum/variable_setting_entry##partialpath);} \
	var/##varset = __cachedatum_##varset.value

// Value types
#define VSC_VALUE_NUMBER			"number"
#define VSC_VALUE_BOOLEAN			"boolean"
