/**
 * stateful categories
 * feel free to shove vars in these.
 *
 * basic behaviors that don't require stateful information on a category
 * can be relegated to the verbs list - they will act as if you pressed the verb
 * without inputting any arguments in byond.
 *
 * anything else should be manually set in tgui.
 */
#warn unit test for name/tgui id + uniqueness
/datum/admin_panel_category
	/// name
	var/name
	/// tgui id
	var/interface
	/// verbs datums to include - put paths in here.
	var/list/datum/admin_verb/verbs = list()

/datum/admin_panel_category/ui_act(action, list/params)

/datum/admin_panel_category/ui_data(mob/user)

/datum/admin_panel_category/ui_static_data(mob/user)

#warn finish - basic generic button support

