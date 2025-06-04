/obj/item/robot_builtin/dog_mirrortool
	name = "Mirror Installation Tool"
	desc = "A tool for the installation and removal of Mirrors"
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/implant/mirror/imp = null

/obj/item/robot_builtin/dog_mirrortool/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return
	if(target_zone == BP_TORSO && imp == null)
		for(var/obj/item/organ/I in H.organs)
			for(var/obj/item/implant/mirror/MI in I.contents)
				if(imp == null)
					H.visible_message("<span class='warning'>[user] is attempting remove [H]'s mirror!</span>")
					user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN)
					user.do_attack_animation(H)
					var/turf/T1 = get_turf(H)
					if (T1 && ((H == user) || do_after(user, 20)))
						if(user && H && (get_turf(H) == T1) && src)
							H.visible_message("<span class='warning'>[user] has removed [H]'s mirror.</span>")
							add_attack_logs(user,H,"Mirror removed by [user]")
							src.imp = MI
							qdel(MI)
	else if (target_zone == BP_TORSO && imp != null)
		if (imp)
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
	else
		to_chat(usr, "You must target the torso.")

/obj/item/robot_builtin/dog_mirrortool/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	var/obj/machinery/computer/transhuman/resleeving/comp = target
	if(!istype(comp))
		return
	comp.active_mr = imp.stored_mind
