// todo: can element this by usign 3 signals instead of 2, one to receive a keybind signal.
/datum/component/wielding
	/// hands needed
	var/hands
	/// lazylist
	var/list/obj/item/offhand/wielding/offhands
	/// wielded user
	var/mob/wielder
	/// callback on wield
	var/datum/callback/on_wield
	/// callback on unwield
	var/datum/callback/on_unwield

/datum/component/wielding/Initialize(hands = 2, datum/callback/on_wield, datum/callback/on_unwield)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if((. = ..()) & COMPONENT_INCOMPATIBLE)
		return
	src.hands = hands
	src.on_wield = on_wield
	src.on_unwield = on_unwield

/datum/component/wielding/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/signal_examine)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/signal_dropped)

/datum/component/wielding/UnregisterFromParent()
	unwield()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_ITEM_DROPPED
	))

/datum/component/wielding/proc/signal_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += SPAN_NOTICE("[parent] seems to be able to be used with [hands] hands. Press your \"Wield Item\" keybind to toggle wielding.")

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
	to_chat(src.wielder, SPAN_WARNING("You start wielding [parent] with [hands == 2? "both" : "[hands]"] hands."))
	post_wield(src.wielder, hands)

/datum/component/wielding/proc/post_wield(mob/user, hands)
	if(on_wield)
		on_wield.Invoke(user, hands)
	var/obj/item/I = parent
	I.on_wield(user, hands)

/datum/component/wielding/proc/unwield(gcing)
	if(!wielder)
		return
	if(offhands)
		var/list/old = offhands
		offhands = null
		QDEL_LIST(old)
	var/obj/item/I = parent
	var/mob/unwielding = wielder
	I.item_flags &= ~ITEM_MULTIHAND_WIELDED
	if(wielder && !gcing)
		to_chat(wielder, SPAN_WARNING("You stop wielding [parent] with [hands == 2? "both" : "[hands]"] hands."))
	wielder = null
	post_unwield(unwielding, hands)

/datum/component/wielding/proc/post_unwield(mob/user, hands)
	if(on_unwield)
		on_unwield.Invoke(user, hands)
	var/obj/item/I = parent
	I.on_unwield(user, hands)

/datum/component/wielding/proc/offhand_destroyed(obj/item/offhand/wielding/I)
	unwield()
/obj/item/offhand/wielding
	name = "wielding offhand"
	desc = "You shouldn't be able to see this."
	/// host
	var/datum/component/wielding/host

/obj/item/offhand/wielding/Destroy()
	if(host)
		host.offhand_destroyed(src)
		host = null
	return ..()

// item procs
/obj/item/proc/on_wield(mob/user, hands)
	return

/obj/item/proc/on_unwield(mob/user, hands)
	return
