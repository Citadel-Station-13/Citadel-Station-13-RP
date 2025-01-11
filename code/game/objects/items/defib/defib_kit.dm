// todo: rework defibs
// todo: object cell system

//backpack item
/obj/item/defib_kit
	name = "defibrillator"
	desc = "A device that delivers powerful shocks to detachable paddles that resuscitate incapacitated patients."
	icon = 'icons/obj/medical/defibrillator.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	slot_flags = SLOT_BACK
	damage_force = 5
	throw_force = 6
	preserve_item = 1
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2)
	item_action_name = "Remove/Replace Paddles"
	worth_intrinsic = 300

	var/obj/item/shockpaddles/linked/paddles
	var/obj/item/cell/bcell = null

/obj/item/defib_kit/Initialize(mapload) //starts without a cell for rnd
	. = ..()
	if(ispath(paddles))
		paddles = new paddles(src, src)
	else
		paddles = new(src, src)

	if(ispath(bcell))
		bcell = new bcell(src)
	update_icon()

/obj/item/defib_kit/Destroy()
	. = ..()
	QDEL_NULL(paddles)
	QDEL_NULL(bcell)

/obj/item/defib_kit/loaded //starts with a cell
	bcell = /obj/item/cell/apc

/obj/item/defib_kit/update_icon()
	cut_overlays()
	. = ..()
	var/list/new_overlays = list()

	if(paddles && paddles.loc == src) //in case paddles got destroyed somehow.
		new_overlays += "[initial(icon_state)]-paddles"
	if(bcell && paddles)
		if(bcell.check_charge(paddles.chargecost))
			if(paddles.combat)
				new_overlays += "[initial(icon_state)]-combat"
			else if(!paddles.safety)
				new_overlays += "[initial(icon_state)]-emagged"
			else
				new_overlays += "[initial(icon_state)]-powered"

		var/ratio = CEILING(bcell.percent()/25, 1) * 25
		new_overlays += "[initial(icon_state)]-charge[ratio]"
	else
		new_overlays += "[initial(icon_state)]-nocell"

	add_overlay(new_overlays)

/obj/item/defib_kit/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	toggle_paddles()

/obj/item/defib_kit/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(loc == user)
		toggle_paddles()
	else
		..()

/obj/item/defib_kit/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		reattach_paddles(user)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	else if(istype(W, /obj/item/cell))
		if(bcell)
			to_chat(user, "<span class='notice'>\the [src] already has a cell.</span>")
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else
			if(!user.attempt_insert_item_for_installation(W, src))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			update_icon()
			return CLICKCHAIN_DO_NOT_PROPAGATE

	else if(W.is_screwdriver())
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src.loc))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			update_icon()
		return CLICKCHAIN_DO_NOT_PROPAGATE
	else
		return ..()

/obj/item/defib_kit/emag_act(var/remaining_charges, var/mob/user)
	if(paddles)
		. = paddles.emag_act(user)
		update_icon()
	return

//Paddle stuff

/obj/item/defib_kit/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = VERB_CATEGORY_OBJECT

	var/mob/living/carbon/human/user = usr
	if(!paddles)
		to_chat(user, "<span class='warning'>The paddles are missing!</span>")
		return

	if(paddles.loc != src)
		reattach_paddles(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [paddles].</span>")
	else
		if(!usr.put_in_hands(paddles)) //Detach the paddles into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the paddles!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/defib_kit/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.item_by_slot_id(SLOT_ID_BACK) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.item_by_slot_id(SLOT_ID_BELT) == src)
		return 1

	return 0

/obj/item/defib_kit/unequipped(mob/user, slot, flags)
	. = ..()
	reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/defib_kit/proc/reattach_paddles(mob/user)
	if(!paddles)
		return

	if(ismob(paddles.loc))
		to_chat(paddles.loc, "<span class='notice'>\The [paddles] snap back into the main unit.</span>")
	paddles.forceMove(src)
	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/defib_kit/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon_state = "defibcompact"
	item_state = "defibcompact"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_POWER = 3)
	worth_intrinsic = 500

/obj/item/defib_kit/compact/loaded
	bcell = /obj/item/cell/high


/obj/item/defib_kit/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	paddles = /obj/item/shockpaddles/linked/combat

/obj/item/defib_kit/compact/combat/loaded
	bcell = /obj/item/cell/high
