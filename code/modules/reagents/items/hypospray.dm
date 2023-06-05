/obj/item/hypospray
	name = "hypospray"
	desc = "A standard issue prototype hypospray that allows for the quick, sterile application of medications both dermally and directly to the bloodstream."
	description_fluff = "While technically still a prototype due to its unique two-mode applicator, this model - and others like it - have been floating around space for almost a century.\n \
	Hardened, low-power electronics allow for it to optimize an injection sequence when the trigger is pulled on the fly, avoiding the need to directly aim for a vein - though a skilled user still tends to have faster operation cycles by far.\n \
	Initially developed in a joint venture between Nanotrasen and Vey-Med, the designs quickly proliferated due to their immense usefulness - and were subsequently leaked. \
	Nowadays, one can expect this model to be on all but the most backwater colonies and installations."
	icon = 'icons/modules/reagents/items/hypospray.dmi'
	icon_state = "hypo"
	inhand_state = "hypo"
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	worn_render_flags = NONE

	/// loaded vial
	var/obj/item/reagent_containers/glass/hypovial/loaded
	/// allow large vials
	var/allow_large = FALSE
	/// standard injection delay
	var/injection_time = 1 SECONDS
	/// delay add if person is resisting. null to disallow inject.
	var/resist_add_time = 2 SECONDS
	/// delay add to injection port items (like hardsuits). null to disallow inject. overriden by thick_add_time.
	var/port_add_time = 1 SECONDS
	/// delay add to thickmaterial suits. null to disallow inject. overrides port_add_time.
	var/thick_add_time = null
	/// injection amount
	var/inject_amount = 5
	/// max injection level
	var/inject_max = 10
	/// injection mode
	var/inject_mode = HYPOSPRAY_MODE_INJECT
	/// can people change how much to inject?
	var/inject_adjustable = TRUE

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
		update_icon()
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
		update_icon()
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
	if(injection_checks(target, user, target_zone))
		do_inject(target, user)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/hypospray/proc/injection_checks(mob/target, mob/user, target_zone, speed_mult = 1, silent = FALSE)
	// todo: legacy cast, get organ/etc should be on mob level maybe.
	var/mob/living/L = target
	if(!istype(L))
		user.action_feedback(SPAN_WARNING("[target] isn't injectable."), src)
		return FALSE
	var/obj/item/organ/external/limb = L.get_organ(target_zone || BP_HEAD)
	if(isnull(limb))
		user.action_feedback(SPAN_WARNING("[target] doesn't have that limb."), src)
		return FALSE
	var/inject_verb
	var/inject_message
	switch(inject_mode)
		if(HYPOSPRAY_MODE_INJECT)
			inject_verb = "inject"
		if(HYPOSPRAY_MODE_SPRAY)
			inject_verb = "spray"
	var/block_flags = NONE
	for(var/obj/item/I as anything in target.inventory.items_that_cover(limb.body_part_flags))
		block_flags |= (I.clothing_flags & (CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT))
	// got all coverage, proceed.
	var/delay = injection_time
	if(block_flags & CLOTHING_THICK_MATERIAL)
		if(isnull(thick_add_time))
			user.action_feedback(SPAN_WARNING("[src] can't [inject_verb] through something that thick!"), src)
			return FALSE
		delay += thick_add_time
		// todo: 'friendly name' so limbs can stay concealed of their true names while under clothing?
		inject_message = SPAN_WARNING("[user] starts to dig [src] up against [target]'s [limb]!")
	else if(block_flags & CLOTHING_INJECTION_PORT)
		if(isnull(thick_add_time))
			user.action_feedback(SPAN_WARNING("[src] is not compatible with injection ports!"), src)
			return FALSE
		delay += port_add_time
		// todo: 'friendly name' so limbs can stay concealed of their true names while under clothing?
		inject_message = SPAN_NOTICE("[user] starts to search for an injection port on [target]'s [limb].")
	if(target.a_intent != INTENT_HELP)
		if(isnull(resist_add_time))
			user.action_feedback(SPAN_WARNING("[src] is not capable of aligning while [target] is resisting! (Non-help intent)"), src)
			return FALSE
		delay += resist_add_time
		// todo: 'friendly name' so limbs can stay concealed of their true names while under clothing?
		inject_message = SPAN_WARNING("[user] starts to intrusively align [src] up against [target]'s [limb]!")
	if(!silent)
		user.visible_action_feedback(inject_message, target, MESSAGE_RANGE_COMBAT_SUPPRESSED)
	if(!do_after(user, delay, target, mobility_flags = MOBILITY_CAN_USE))
		return FALSE
	return TRUE

/obj/item/hypospray/proc/do_inject(mob/target, mob/user, mode = inject_mode, silent = FALSE)
	if(!loaded.reagents.total_volume)
		return
	var/logstr = "[inject_amount] of [loaded.reagents.log_list()]"
	if(user)
		add_attack_logs(user, target, "injected with [logstr]")
	log_reagent("hypospray: [user] -> [target] using [mode]: [logstr]")
	var/where_str
	switch(mode)
		if(HYPOSPRAY_MODE_INJECT)
			loaded.reagents.trans_to_mob(target, inject_amount, CHEM_INJECT)
			where_str = "rushing into your veins"
		if(HYPOSPRAY_MODE_SPRAY)
			loaded.reagents.trans_to_mob(target, inject_amount, CHEM_TOUCH)
			where_str = "on your skin"
	playsound(src, 'sound/items/hypospray2.ogg', 50, TRUE, -1)
	target.tactile_feedback(SPAN_WARNING("You feel a tiny prick, and a cool sensation [where_str]."))

/obj/item/hypospray/loaded
	loaded = /obj/item/reagent_containers/glass/hypovial/tricordrazine

/obj/item/hypospray/advanced
	name = "advanced hypospray"
	desc = "An upgraded hypospray with faster injection protocols. Supports large vials."
	icon_state = "hypo-cmo"
	allow_large = TRUE
	injection_time = 0.5 SECONDS
	resist_add_time = 1 SECONDS
	port_add_time = 0.5 SECONDS

/obj/item/hypospray/advanced/loaded
	loaded = /obj/item/reagent_containers/glass/hypovial/large/tricordrazine

/obj/item/hypospray/advanced/cmo
	port_add_time = 0 SECONDS

/obj/item/hypospray/advanced/cmo/loaded
	loaded = /obj/item/reagent_containers/glass/hypovial/large/tricordrazine

/obj/item/hypospray/combat
	name = "combat hypospray"
	desc = "An upgraded variant of the regular hypospray, this one sports quickened injection - allowing for the faster incapacitation of vic- er, medication of allies. Supports large vials."
	icon_state = "hypo-combat"
	inhand_state = "hypo-combat"
	allow_large = TRUE
	injection_time = 0.5 SECONDS
	resist_add_time = 1 SECONDS
	port_add_time = 0.5 SECONDS
	thick_add_time = 3 SECONDS

/obj/item/hypospray/combat/loaded
	loaded = /obj/item/reagent_containers/glass/hypovial/large/tricordrazine
