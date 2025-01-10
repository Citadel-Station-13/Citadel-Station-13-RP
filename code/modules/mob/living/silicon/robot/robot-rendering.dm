/mob/living/silicon/robot/update_icon()
	. = ..()

/mob/living/silicon/robot/updateicon()
	update_icon()

#warn below
/mob/living/silicon/robot/updateicon()
	cut_overlays()

	if (dogborg)
		zmm_flags |= ZMM_LOOKAHEAD
		// Resting dogborgs don't get overlays.
		if (stat == CONSCIOUS && resting)
			if(sitting)
				icon_state = "[module_sprites[icontype]]-sit"
			else if(bellyup)
				icon_state = "[module_sprites[icontype]]-bellyup"
			else
				icon_state = "[module_sprites[icontype]]-rest"
			return
	else
		zmm_flags &= ~ZMM_LOOKAHEAD

	if(stat == CONSCIOUS)
		if(!shell || deployed) // Shell borgs that are not deployed will have no eyes.
			add_overlay(list(
				"eyes-[module_sprites[icontype]]",
				emissive_appearance(icon, "eyes-[module_sprites[icontype]]")
			))

	if(opened)
		var/panelprefix = custom_sprite ? "[src.ckey]-[src.sprite_name]" : "ov"
		if(wiresexposed)
			add_overlay("[panelprefix]-openpanel +w")
		else if(cell)
			add_overlay("[panelprefix]-openpanel +c")
		else
			add_overlay("[panelprefix]-openpanel -c")

	if(has_active_type(/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = locate() in src
		if(shield && shield.active)
			add_overlay("[module_sprites[icontype]]-shield")

	if(modtype == "Combat")
		#warn sigh
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "[module_sprites[icontype]]-roll"
		else
			icon_state = module_sprites[icontype]

	if (dogborg)
		if (stat == CONSCIOUS)
			icon_state = "[module_sprites[icontype]]"
			if(sleeper_g)
				var/state = "[module_sprites[icontype]]-sleeper_g"
				if (icon_exists(icon, state, FALSE))
					add_overlay(state)
				else
					// This one seems to always be present.
					add_overlay("[module_sprites[icontype]]-sleeper_r")
			if(sleeper_r)
				add_overlay("[module_sprites[icontype]]-sleeper_r")

			if(istype(module_active, /obj/item/gun/energy/taser/mounted/cyborg))
				add_overlay("taser")
			else if(istype(module_active, /obj/item/gun/energy/laser/mounted))
				add_overlay("laser")
			else if(istype(module_active, /obj/item/gun/energy/taser/xeno/robot))
				add_overlay("taser")

			if(lights_on)
				add_overlay("eyes-[module_sprites[icontype]]-lights")

		else if (stat == DEAD)
			icon_state = "[module_sprites[icontype]]-wreck"
			add_overlay("wreck-overlay")
