/**
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * tgui state: language_menu_state
 */

GLOBAL_DATUM_INIT(language_menu_state, /datum/ui_state/language_menu, new)

/datum/ui_state/language_menu/can_use_topic(datum/src_object, mob/user, datum/tgui/ui)
	. = UI_CLOSE
	if(check_rights_for(user.client, R_ADMIN))
		. = UI_INTERACTIVE
	else if(istype(src_object, /datum/prototype/language_menu))
		var/datum/prototype/language_menu/LM = src_object
		if(LM.language_holder.get_atom() == user)
			. = UI_INTERACTIVE
