/obj/item/hypospray
	name = "hypospray"
	desc = "A standard issue prototype hypospray that allows for the quick, sterile application of medications both dermally and directly to the bloodstream."
	description_fluff = "While technically still a prototype due to its unique two-mode applicator, this model - and others like it - have been floating around space for almost a century.\n \
	Hardened, low-power electronics allow for it to optimize an injection sequence when the trigger is pulled on the fly, avoiding the need to directly aim for a vein - though a skilled user still tends to have faster operation cycles by far.\n \
	Initially developed in a joint venture between Nanotrasen and Vey-Med, the designs quickly proliferated due to their immense usefulness - and were subsequently leaked. \
	Nowadays, one can expect this model to be on all but the most backwater colonies and installations."
	icon = 'icons/modules/reagents/items/hyposprays.dmi'
	icon_state = "hypo"
	w_class = WEIGHT_CLASS_SMALL
	#warn inhand icons?

	/// loaded vial
	var/obj/item/reagent_containers/glass/hypovial/loaded
	/// allow large vials
	var/allow_large = FALSE
	/// standard injection delay
	var/injection_time = 1 SECONDS
	/// delay add if person is resisting. null to disallow inject.
	var/resist_add_time = 2 SECONDS
	/// delay add to injection port items (like hardsuits). null to disallow inject.
	var/port_add_time = 1 SECONDS
	/// delay add to thickmaterial suits. null to disallow inject.
	var/thick_add_time = null
	/// injection amount
	var/inject_amount = 5
	/// max injection level
	var/inject_max = 10
	/// injection mode
	var/inject_mode = HYPOSPRAY_MODE_INJECT
	/// can people change how much to inject?
	var/inject_adjustable = TRUE

#warn sprites: 'icons/modules/reagents/items/hypospray.dmi'
#warn vial: vial1, vial2, vial3
#warn vial-bs:
#warn vial-l: vial-l1, vial-l2, vial-l3, vial-l4, l4 is 100% but l3 is 50%

#warn kits in vendors & storage
#warn vials in chemmaster

/obj/item/hypospray/update_icon_state()
	var/vial_state
	if(!isnull(loaded))
		if(istype(loaded, /obj/item/reagent_containers/glass/hypovial/bluespace))
			vial_state = "-l-bs"
		else
			vial_state = "-l"
	icon_state = "[initial(icon_state)][vial_state]"
	return ..()

/obj/item/hypospray/attack_hand(mob/user, list/params)
	if(user.is_holding_inactive(src))
		user.put_in_hands_or_drop(loaded)
		user.action_feedback(SPAN_NOTICE("You remove [loaded] from [src]."), src)
		loaded = null
		playsound(src, 'sound/weapons/empty.ogg', 50, FALSE)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/hypospray/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/reagent_containers/glass/hypovial))
		var/obj/item/reagent_containers/glass/hypovial/vial = I
		if(!user.transfer_item_to_loc(vial, src))
			user.action_feedback(SPAN_WARNING("[vial] is stuck to your hand!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/reagent_containers/glass/hypovial/old_vial = loaded
		loaded = vial
		if(!isnull(old_vial))
			user.action_feedback(SPAN_NOTICE("You quickly swap [old_vial] with [vial]."), src)
		else
			user.action_feedback(SPAN_NOTICE("You insert [vial] into [src]."), src)
		playsound(src, 'sound/weapons/autoguninsert.ogg', 50, FALSE)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

// todo: alt click context radials?
/obj/item/hypospray/verb/set_transfer_amount()
	set name = "Set Injection Amount"
	set category = "Object"

	if(!inject_adjustable)
		usr.action_feedback(SPAN_WARNING("[src] can't have its injection thresholds changed."), src)
		return
	var/amount = input(usr, "Set how much you want to inject per use.", "Injection Amount", inject_amount) as num|null
	if(isnull(amount))
		return
	amount = round(amount, 1)
	if(amount <= 0)
		amount = 1
	inject_amount = amount
	usr.action_feedback(SPAN_NOTICE("[src] is now set to inject [amount] per use."), src)

/obj/item/hypospray/attack_self(mob/user)
	switch(inject_mode)
		if(HYPOSPRAY_MODE_INJECT)
			inject_mode = HYPOSPRAY_MODE_SPRAY
		if(HYPOSPRAY_MODE_SPRAY)
			inject_mode = HYPOSPRAY_MODE_INJECT
	switch(inject_mode)
		if(HYPOSPRAY_MODE_INJECT)
			user.action_feedback(SPAN_NOTICE("[src] is now set to subdermal injection."), src)
		if(HYPOSPRAY_MODE_SPRAY)
			user.action_feedback(SPAN_NOTICE("[src] is now set to surface spray."), src)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)

// todo: alt click context radials?
/obj/item/hypospray/AltClick(mob/user)
	if(!inject_adjustable)
		user.action_feedback(SPAN_WARNING("[src] can't have its injection thresholds changed."), src)
		return
	inject_amount = (inject_amount + 5 > inject_max)? min(inject_amount, inject_max) : inject_amount + 5
	user.action_feedback(SPAN_NOTICE("[src] is now set to inject [inject_amount] per use."), src)

/obj/item/hypospray/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(injection_checks(target, user))
		do_inject(target, user)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/hypospray/proc/injection_checks(mob/target, mob/user, speed_mult = 1, silent = FALSE)
	#warn impl

/obj/item/hypospray/proc/do_inject(mob/target, mob/user, mode)
	#warn impl

/obj/item/hypospray/advanced
	name = "advanced hypospray"
	desc = "An upgraded hypospray with faster injection protocols. Supports large vials."
	icon_state = "hypo-cmo"
	allow_large = TRUE
	injection_time = 0.5 SECONDS
	resist_add_time = 1 SECONDS
	port_add_time = 0.5 SECONDS

/obj/item/hypospray/combat
	name = "combat hypospray"
	desc = "An upgraded variant of the regular hypospray, this one sports quickened injection - allowing for the faster incapacitation of vic- er, medication of allies. Supports large vials."
	icon_state = "hypo-combat"
	allow_large = TRUE
	injection_time = 0.5 SECONDS
	resist_add_time = 1 SECONDS
	port_add_time = 0.5 SECONDS
	thick_add_time = 3 SECONDS

/obj/item/reagent_containers/glass/hypovial
	name = "hypospray vial"
	desc = "A standard issue vial used for hyposprays."
	icon = 'icons/modules/reagents/items/hyposprays.dmi'
	icon_state = "vial"
	w_class = WEIGHT_CLASS_TINY // 14 fits in a box, not 7
	volume = 60

/obj/item/reagent_containers/glass/hypovial/large
	name = "large hypospray vial"
	desc = "A larger variant of the common hypospray vial. Only compatible with advanced units."
	icon_state = "vial-l"
	volume = 120

/obj/item/reagent_containers/glass/hypovial/bluespace
	name = "bluespace hypospray vial"
	desc = "A prototype hypospray vial with the ability to hold reagents in a quasi-compressed state."
	icon_state = "vial-bs"
	volume = 120
