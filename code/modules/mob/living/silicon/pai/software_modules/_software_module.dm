/datum/pai_software
	// Name for the software. This is used as the button text when buying or opening/toggling the software
	var/name = "pAI software module"
	// RAM cost; pAIs start with 100 RAM, spending it on programs
	var/ram_cost = 0
	// ID for the software. This must be unique
	var/id = ""
	// Whether this software is a toggle or not
	// Toggled software should override toggle() and is_active()
	// Non-toggled software should override on_nano_ui_interact() and Topic()
	var/toggle = 1
	// Whether pAIs should automatically receive this module at no cost
	var/default = 0

/datum/pai_software/proc/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	return

/datum/pai_software/proc/toggle(mob/living/silicon/pai/user)
	return

/datum/pai_software/proc/is_active(mob/living/silicon/pai/user)
	return 0

// todo: translation context

// /datum/pai_software/translator
// 	name = "Universal Translator"
// 	ram_cost = 35
// 	id = "translator"

// /datum/pai_software/translator/toggle(mob/living/silicon/pai/user)
// 	// 	Sol Common, Tradeband, Terminus and Gutter are added with New() and are therefore the current default, always active languages
// 	// todo: translation contexts for pais
// 	user.translator_on = !user.translator_on
// 	if(user.translator_on)
// 		user.add_language(LANGUAGE_UNATHI)
// 		user.add_language(LANGUAGE_SIIK)
// 		user.add_language(LANGUAGE_AKHANI)
// 		user.add_language(LANGUAGE_SKRELLIAN)
// 		user.add_language(LANGUAGE_ZADDAT)
// 		user.add_language(LANGUAGE_SCHECHI)
// 	else
// 		user.remove_language(LANGUAGE_UNATHI)
// 		user.remove_language(LANGUAGE_SIIK)
// 		user.remove_language(LANGUAGE_AKHANI)
// 		user.remove_language(LANGUAGE_SKRELLIAN)
// 		user.remove_language(LANGUAGE_ZADDAT)
// 		user.remove_language(LANGUAGE_SCHECHI)

// /datum/pai_software/translator/is_active(mob/living/silicon/pai/user)
// 	return user.translator_on
