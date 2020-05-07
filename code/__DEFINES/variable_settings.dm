#define GET_VSC_PROP(controllerglobal, partialpath, varset)		var/##varset = GLOB.controllerglobal.get_value(/datum/variable_setting_entry##partialpath)
#define CACHE_VSC_PROP(controllerglobal, partialpath, varset) \
	var/static/datum/variable_setting_entry##partialpath/__cachedatum_##varset; \
	if(QDELETED(partialpath)){ \
		__cachedatum_##varset = GLOB.controllerglobal.get_datum(/datum/variable_setting_entry##partialpath);} \
	var/##varset = __cachedatum_##varset.value
