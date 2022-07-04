/**
 * unified tgui panel
 *
 * **do not shove debug functions in here.**
 * if tgui breaks, you can't use this.
 * leave integral things like banning system/spawn/buildmode in their own things
 * this is basically for putting anything not too important in like like monkey everyone/etc
 */
/datum/admin_panel
	/// categories
	var/list/datum/admin_panel_category/categories
	/// active
	var/datum/admin_panel_category/selected

/datum/admin_panel/ui_data(mob/user)

/datum/admin_panel/ui_static_data(mob/user)

/datum/admin_panel/ui_act(action, list/params)
