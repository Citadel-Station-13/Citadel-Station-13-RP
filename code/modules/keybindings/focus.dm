/**
 * set our keyboard input focus
 */
/mob/proc/set_key_focus(datum/new_focus)
	if(key_focus == new_focus)
		return
	key_focus = new_focus

/**
 * set our keyboard focus intercept
 *
 * *FAILS* if something is already there
 *
 * @return TRUE/FALSE for success/fail
 */
/mob/proc/request_key_intercept(datum/intercepting)
	if(key_intercept)
		return FALSE
	key_intercept = intercepting
	return TRUE

/**
 * clears keyboard focus intercept
 *
 * @return old intercept, or null if none found
 */
/mob/proc/clear_key_intercept()
	if(!key_intercept)
		return
	. = key_intercept
	key_intercept = null
