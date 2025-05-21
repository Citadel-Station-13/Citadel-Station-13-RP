// todo: can element this by usign 3 signals instead of 2, one to receive a keybind signal.
/datum/component/wielding
	registered_type = /datum/component/wielding

	/// hands needed
	var/hands = 2
	/// lazylist
	var/list/obj/item/offhand/wielding/offhands
	/// wielded user
	var/mob/wielder
	/// callback on wield
	/// * this is called with (mob/user, hand_count)
	/// * this is executed asynchronously
	var/datum/callback/on_wield
	/// callback on unwield
	/// * this is called with (mob/user, hand_count)
	/// * this is executed asynchronously
	var/datum/callback/on_unwield

/datum/component/wielding/Initialize(hands = 2, datum/callback/on_wield, datum/callback/on_unwield)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if((. = ..()) == COMPONENT_INCOMPATIBLE)
		return
	if(hands)
		src.hands = hands
	if(on_wield)
		src.on_wield = on_wield
	if(on_unwield)
		src.on_unwield = on_unwield

/datum/component/wielding/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(signal_examine))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(signal_dropped))

/datum/component/wielding/UnregisterFromParent()
	unwield()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_ITEM_DROPPED
	))

/datum/component/wielding/proc/signal_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += SPAN_NOTICE("[parent] seems to be able to be used with [hands] hands. Press your \"<b>Wield Item</b>\" keybind [user?.client?.print_keys_for_keybind_with_prefs_link(/datum/keybinding/item/multihand_wield, " ")]to toggle wielding.")

/datum/component/wielding/proc/signal_dropped(datum/source, mob/user, flags, atom/newloc)
	unwield()

/**
 * todo: event_args/actor
 */
/datum/component/wielding/proc/auto_wield()
	var/obj/item/our_item = parent
	var/mob/holding = our_item.is_being_held()
	if(!holding || wielder)
		unwield()
	else
		wield(holding)

/**
 * todo: event_args/actor
 */
/datum/component/wielding/proc/wield(mob/wielder)
	if(src.wielder)
		return
	var/possible = wielder.get_nominal_hand_count()
	var/wanted = hands - 1
	if(possible < wanted)
		return
	var/list/obj/item/offhand/wielding/made = list()
	for(var/i in 1 to wanted)
		var/obj/item/offhand/wielding/creating = wielder.allocate_offhand(/obj/item/offhand/wielding)
		if(!creating)
			wielder.action_feedback(
				SPAN_WARNING("You don't have a free hand to hold [parent] with."),
				target = parent,
			)
			QDEL_LIST(made)
			return
		creating.host = src
		made += creating
	offhands = made
	var/obj/item/item_parent = parent
	item_parent.item_flags |= ITEM_MULTIHAND_WIELDED
	src.wielder = wielder
	to_chat(src.wielder, SPAN_WARNING("You start wielding [parent] with [hands == 2? "both" : "[hands]"] hands."))
	post_wield(src.wielder, hands)

/**
 * todo: event_args/actor
 */
/datum/component/wielding/proc/post_wield(mob/user, hands)
	if(on_wield)
		on_wield.InvokeAsync(user, hands)
	var/obj/item/I = parent
	I.on_wield(user, hands)

/**
 * todo: event_args/actor
 */
/datum/component/wielding/proc/unwield(gcing)
	if(!wielder)
		return
	if(offhands)
		var/list/old = offhands
		offhands = null
		for(var/obj/item/offhand/offhand as anything in old)
			// might already be qdeleting if we're unwield()ing due to a dropped()
			if(!QDELETED(offhand))
				qdel(offhand)
	var/obj/item/I = parent
	var/mob/unwielding = wielder
	I.item_flags &= ~ITEM_MULTIHAND_WIELDED
	if(wielder && !gcing)
		to_chat(wielder, SPAN_WARNING("You stop wielding [parent] with [hands == 2? "both" : "[hands]"] hands."))
	wielder = null
	post_unwield(unwielding, hands)

/**
 * todo: event_args/actor
 */
/datum/component/wielding/proc/post_unwield(mob/user, hands)
	if(on_unwield)
		on_unwield.InvokeAsync(user, hands)
	var/obj/item/I = parent
	I.on_unwield(user, hands)

/datum/component/wielding/proc/offhand_destroyed(obj/item/offhand/wielding/I)
	unwield()

//* Offhands *//

/obj/item/offhand/wielding
	name = "wielding offhand"
	desc = "You shouldn't be able to see this."
	allow_item_pickup_replace = TRUE
	/// host
	var/datum/component/wielding/host

/obj/item/offhand/wielding/Destroy()
	if(host)
		host.offhand_destroyed(src)
		host = null
	return ..()

/obj/item/offhand/wielding/get_host_drop_descriptor()
	return "stop wielding [host.parent]"

//* Item Hooks *//

/**
 * Call to attempt to wield/unwield with wield component.
 */
/obj/item/proc/auto_wield(datum/event_args/actor/actor)
	var/datum/component/wielding/wielding_component = GetComponent(/datum/component/wielding)
	if(!wielding_component)
		return
	wielding_component.auto_wield(actor.performer)

/**
 * Called when wielded via wielding component.
 *
 * todo: /datum/event_args/actor
 *
 * * This is a default hook that's always executed, even if there's a callback provided to the component.
 */
/obj/item/proc/on_wield(mob/user, hands)
	SHOULD_CALL_PARENT(TRUE)
	update_icon()
	update_worn_icon()

/**
 * Called when wielded via wielding component.
 *
 * todo: /datum/event_args/actor
 *
 * * This is a default hook that's always executed, even if there's a callback provided to the component.
 */
/obj/item/proc/on_unwield(mob/user, hands)
	SHOULD_CALL_PARENT(TRUE)
	update_icon()
	update_worn_icon()
