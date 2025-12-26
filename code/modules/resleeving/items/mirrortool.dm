// TODO: /mirror_tool
/obj/item/mirrortool
	name = "Mirror Installation Tool"
	desc = "A tool for the installation and removal of Mirrors. The tool has a set of barbs for removing Mirrors from a body, and a slot for depositing it directly into a resleeving console."
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirrortool"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	materials_base = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	var/obj/item/organ/internal/mirror/imp = null

/obj/item/mirrortool/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return
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

/obj/item/mirrortool/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!imp)
		to_chat(usr, "No mirror is loaded.")
	else
		user.put_in_hands_or_drop(imp)
		imp = null
		update_icon()

/obj/item/mirrortool/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		user.put_in_hands_or_drop(imp)
		imp = null
		update_icon()
	. = ..()

/obj/item/mirrortool/update_icon() //uwu
	..()
	if(imp == null)
		icon_state = "mirrortool"
	else
		icon_state = "mirrortool_loaded"

/obj/item/mirrortool/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/organ/internal/mirror))
		if(imp)
			to_chat(usr, "This mirror tool already contains a mirror.")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		imp = I
		user.visible_message("[user] inserts the [I] into the [src].", "You insert the [I] into the [src].")
	update_icon()
	update_worn_icon()
	return
