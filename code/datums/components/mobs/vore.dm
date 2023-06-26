/datum/component/vore
	can_transfer = TRUE

	/// ui panel
	var/datum/vore_panel/panel
	/// vore holders
	var/list/obj/vore_holder/holders

/datum/component/vore/Initialize(...)
	. = ..()

/datum/component/vore/RegisterWithParent()
	. = ..()

/datum/component/vore/UnregisterFromParent()
	. = ..()

/datum/component/vore/PreTransfer()
	. = ..()

/datum/component/vore/PostTransfer()
	. = ..()


#warn impl all
