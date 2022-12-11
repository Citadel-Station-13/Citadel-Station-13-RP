/datum/component/wielding
	/// hands needed
	var/hands
	/// lazylist
	var/list/obj/item/offhand/wielding/offhands
	/// wielded user
	var/mob/wielder

/datum/component/wielding/Initialize(hands = 2)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if((. = ..()) & COMPONENT_INCOMPATIBLE)
		return
	src.hands = hands

/datum/component/wielding/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EXAMINE, .proc/signal_examine)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/signal_dropped)

/datum/component/wielding/UnregisterFromParent()
	unwield()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_EXAMINE,
		COMSIG_ITEM_DROPPED
	))

/datum/component/wielding/proc/signal_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += SPAN_NOTICE("[parent] seems to be intended to be used with [hands] hands. Press your \"Wield Item\" keybind to toggle wielding.")

/datum/component/wielding/proc/signal_dropped(datum/source, mob/user, flags, atom/newloc)
	unwield()

/datum/component/wielding/proc/wield(mob/wielder)
	if(src.wielder)
		return
	var/possible = wielder.get_number_of_hands()
	var/wanted = hands - 1
	if(possible < wanted)
		return
	var/list/obj/item/offhand/wielding/made = list()
	for(var/i in 1 to wanted)
		var/obj/item/offhand/wielding/creating = wielder.allocate_offhand(/obj/item/offhand/wielding)
		if(!creating)
			QDEL_LIST(made)
			return
		creating.host = src
		made += creating
	offhands = made
	src.wielder = wielder
	to_chat(wielder, SPAN_WARNING("You start wielding [parent] with [hands == 2? "both" : "[hands]"] hands."))

/datum/component/wielding/proc/unwield(gcing)
	if(!wielder)
		return
	if(offhands)
		var/list/old = offhands
		offhands = null
		QDEL_LIST(old)
	var/obj/item/I = parent
	I.on_wield(hands)
	I.item_flags &= ~ITEM_MULTIHAND_WIELDED
	if(wielder && !gcing)
		to_chat(wielder, SPAN_WARNING("You stop wielding [parent] with [hands == 2? "both" : "[hands]"] hands."))
	wielder = null

/datum/component/wielding/proc/offhand_destroyed(obj/item/offhand/wielding/I)
	unwield()

/obj/item/offhand/wielding
	name = "wielding offhand"
	desc = "You shouldn't be able to see this."
	/// host
	var/datum/component/wielding/host

/obj/item/offhand/wielding/Destroy()
	host?.offhand_destroyed(src)
	return ..()

// item procs
/obj/item/proc/on_wield(hands)
	return

/obj/item/proc/on_unwield(hands)
	return
