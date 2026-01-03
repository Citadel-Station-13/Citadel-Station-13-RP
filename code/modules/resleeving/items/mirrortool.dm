// TODO: /mirror_tool
/obj/item/mirrortool
	name = "Mirror Installation Tool"
	desc = "A tool for the installation and removal of Mirrors. The tool has a set of barbs for removing Mirrors from a body, and a slot for depositing it directly into a resleeving console."
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirrortool"
	base_icon_state = "mirrortool"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	materials_base = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD

	var/obj/item/organ/internal/mirror/inserted_mirror

/obj/item/mirrortool/Destroy()
	QDEL_NULL(inserted_mirror)
	return ..()

/obj/item/mirrortool/update_icon_state()
	icon_state = inserted_mirror ? "mirrortool_loaded" : "mirrortool"

/obj/item/mirrortool/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/organ/internal/mirror))
		var/obj/item/organ/internal/mirror/mirror = using

/obj/item/mirrortool/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(target, /obj/item/organ/internal/mirror))
		var/obj/item/organ/internal/mirror/mirror = target

/obj/item/mirrortool/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(clickchain.initiator.is_holding_inactive(src))
		user_remove_mirror(clickchain)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/mirrortool/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/item/mirrortool/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()

/obj/item/mirrortool/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["mirror"] = inserted_mirror ? list(
		"activated" = !!inserted_mirror.owner_mind_ref,
		"body_recorded" = inserted_mirror.recorded_body ? list(
			"gender" = inserted_mirror.recorded_body.legacy_gender || "Unknown",
			"species" = inserted_mirror.recorded_body.legacy_custom_species_name || inserted_mirror.recorded_body.legacy_species_uid || "Unknown",
			"synthetic" = !!inserted_mirror.legacy_synthetic,
		) : null,
		"mind_recorded" = inserted_mirror.recorded_body ? list(
			"recorded_name" = inserted_mirror.recorded_mind.user_name,
		) : null,
	) : null

/obj/item/mirrortool/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("eject-mirror")
			user_remove_mirror(e_args)
			return TRUE

/obj/item/mirrortool/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(inserted_mirror)
		.["eject-mirror"] = create_context_menu_tuple("eject mirror", image(src), 0, MOBILITY_CAN_USE, FALSE)

/obj/item/mirrortool/proc/user_remove_mirror(datum/event_args/actor/actor, put_in_hands = TRUE)
	#warn impl

/obj/item/mirrortool/proc/remove_mirror(atom/new_loc, datum/event_args/actor/actor)

/obj/item/mirrortool/proc/on_mirror_removed(obj/item/organ/internal/mirror/mirror)
	update_static_data()
	update_icon()

/obj/item/mirrortool/proc/user_insert_mirror(obj/item/organ/internal/mirror/mirror, datum/event_args/actor/actor)
	#warn impl

/obj/item/mirrortool/proc/insert_mirror(obj/item/organ/internal/mirror/mirror, datum/event_args/actor/actor)

/obj/item/mirrortool/proc/on_mirror_inserted(obj/item/organ/internal/mirror/mirror)
	update_static_data()
	update_icon()

#warn below

/obj/item/mirrortool/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	var/mob/living/carbon/human/H = target
	if(user.zone_sel.selecting == BP_TORSO && imp == null)
		if(imp == null && H.mirror)
			H.visible_message("<span class='warning'>[user] is attempting remove [H]'s mirror!</span>")
			user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(H)
			var/turf/T1 = get_turf(H)
			if (T1 && ((H == user) || do_after(user, 20)))
				if(user && H && (get_turf(H) == T1) && src)
					H.visible_message("<span class='warning'>[user] has removed [H]'s mirror.</span>")
					add_attack_logs(user,H,"Mirror removed by [user]")
					src.imp = H.mirror
					H.mirror = null
					update_icon()
		else
			to_chat(usr, "This person has no mirror installed.")

	else if (user.zone_sel.selecting == BP_TORSO && imp != null)
		if (imp)
			if(!H.client)
				to_chat(usr, "Manual mirror transplant into mindless body not supported, please use the resleeving console.")
				return
			if(H.mirror)
				to_chat(usr, "This person already has a mirror!")
				return
			if(!H.mirror)
				H.visible_message("<span class='warning'>[user] is attempting to implant [H] with a mirror.</span>")
				user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN)
				user.do_attack_animation(H)
				var/turf/T1 = get_turf(H)
				if (T1 && ((H == user) || do_after(user, 20)))
					if(user && H && (get_turf(H) == T1) && src && src.imp)
						H.visible_message("<span class='warning'>[H] has been implanted by [user].</span>")
						add_attack_logs(user,H,"Implanted with [imp.name] using [name]")
						if(imp.handle_implant(H))
							imp.post_implant(H)
						src.imp = null
						update_icon()
	else
		to_chat(usr, "You must target the torso.")
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/mirrortool/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/organ/internal/mirror))
		if(imp)
			to_chat(usr, "This mirror tool already contains a mirror.")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		imp = I
		user.visible_message("[user] inserts the [I] into the [src].", "You insert the [I] into the [src].")
