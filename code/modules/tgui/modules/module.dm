/**
 * new, more-modular tgui_module system
 *
 * allows for generic interfaces that attach to .. really, whatever, and can even be embedded
 * without having to deal with copypaste code
 */
/datum/tgui_module
	/// root datum - only one for the moment, sorry
	var/datum/host
	/// tgui module id
	var/tgui_id

/datum/tgui_module/New(datum/host)
	src.host = host

/datum/tgui_module/Destroy()
	src.host = null
	return ..()

#warn impl

