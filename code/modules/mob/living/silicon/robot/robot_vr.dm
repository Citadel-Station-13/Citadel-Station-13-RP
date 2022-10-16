/mob/living/silicon/robot
	var/sleeper_g
	var/sleeper_r
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 40
	var/leap_at
	var/dogborg = FALSE //Dogborg special features (overlays etc.)
	var/wideborg = FALSE //When the borg simply doesn't use standard 32p size.
	var/scrubbing = FALSE //Floor cleaning enabled
	var/datum/matter_synth/water_res = null
	var/notransform
	var/original_icon = 'icons/mob/robots.dmi'
	var/ui_style_vr = FALSE //Do we use our hud icons?
	var/sitting = FALSE
	var/bellyup = FALSE
	var/vr_icons = list(
					   "handy-hydro",
					   "handy-service",
					   "handy-clerk",
					   "handy-janitor",
					   "handy-miner",
					   "handy-standard",
					   "handy-sec",
					   "mechoid-Standard",
					   "mechoid-Medical",
					   "mechoid-Security",
					   "mechoid-Science",
					   "mechoid-Engineering",
					   "mechoid-Miner",
					   "mechoid-Service",
					   "mechoid-Janitor",
					   "mechoid-Combat",
					   "mechoid-Combat-roll",
					   "mechoid-Combat-shield",
					   "Noble-CLN",
					   "Noble-SRV",
					   "Noble-DIG",
					   "Noble-MED",
					   "Noble-SEC",
					   "Noble-ENG",
					   "Noble-STD",
					   "zoomba-standard",
					   "zoomba-clerical",
					   "zoomba-engineering",
					   "zoomba-janitor",
					   "zoomba-medical",
					   "zoomba-crisis",
					   "zoomba-miner",
					   "zoomba-research",
					   "zoomba-security",
					   "zoomba-service",
					   "zoomba-combat",
					   "zoomba-combat-roll",
					   "zoomba-combat-shield"
					   )					//List of all used sprites that are in robots_vr.dmi


/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/robot/proc/rest_style()
	set name = "Switch Rest Style"
	set category = "IC"
	set desc = "Select your resting pose."
	sitting = FALSE
	bellyup = FALSE
	var/choice = alert(src, "Select resting pose", "", "Resting", "Sitting", "Belly up")
	switch(choice)
		if("Resting")
			return 0
		if("Sitting")
			sitting = TRUE
		if("Belly up")
			bellyup = TRUE

/mob/living/silicon/robot/updateicon()
	vr_sprite_check()
	..()
	if(dogborg == TRUE && stat == CONSCIOUS)
		if(sleeper_g == TRUE)
			add_overlay("[module_sprites[icontype]]-sleeper_g")
		if(sleeper_r == TRUE)
			add_overlay("[module_sprites[icontype]]-sleeper_r")
		if(istype(module_active,/obj/item/gun/energy/laser/mounted))
			add_overlay("laser")
		if(istype(module_active,/obj/item/gun/energy/taser/mounted/cyborg))
			add_overlay("taser")
		if(istype(module_active,/obj/item/gun/energy/taser/xeno/robot))
			add_overlay("taser")
		if(lights_on)
			add_overlay("eyes-[module_sprites[icontype]]-lights")
		if(resting)
			cut_overlays() // Hide that gut for it has no ground sprite yo.
			if(sitting)
				icon_state = "[module_sprites[icontype]]-sit"
			if(bellyup)
				icon_state = "[module_sprites[icontype]]-bellyup"
			else if(!sitting && !bellyup)
				icon_state = "[module_sprites[icontype]]-rest"
		else
			icon_state = "[module_sprites[icontype]]"
	if(dogborg == TRUE && stat == DEAD)
		icon_state = "[module_sprites[icontype]]-wreck"
		add_overlay("wreck-overlay")

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()
	if(scrubbing)
		var/datum/matter_synth/water = water_res
		if(water && water.energy >= 1)
			var/turf/tile = loc
			if(isturf(tile))
				water.use_charge(1)
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/T = tile
					T.dirt = 0
				for(var/A in tile)
					if(istype(A,/obj/effect/rune) || istype(A,/obj/effect/debris/cleanable) || istype(A,/obj/effect/overlay))
						qdel(A)
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, "<span class='warning'>[src] cleans your face!</span>")
	return

/mob/living/silicon/robot/proc/vr_sprite_check()
	if(wideborg == TRUE)
		return
	if((!(original_icon == icon)) && (!(icon == 'icons/mob/robots_vr.dmi')))
		original_icon = icon
	if((icon_state in vr_icons) && (icon == 'icons/mob/robots.dmi'))
		icon = 'icons/mob/robots_vr.dmi'
	else if(!(icon_state in vr_icons))
		icon = original_icon

/mob/living/silicon/robot/proc/ex_reserve_refill()
	set name = "Refill Extinguisher"
	set category = "Object"
	var/datum/matter_synth/water = water_res
	for(var/obj/item/extinguisher/E in module.modules)
		if(E.reagents.total_volume < E.max_water)
			if(water && water.energy > 0)
				var/amount = E.max_water - E.reagents.total_volume
				if(water.energy < amount)
					amount = water.energy
				water.use_charge(amount)
				E.reagents.add_reagent("water", amount)
				to_chat(src, "You refill the extinguisher using your water reserves.")
			else
				to_chat(src, "Insufficient water reserves.")

/mob/living/silicon/robot/onTransitZ(old_z, new_z)
	if(shell)
		if(deployed && GLOB.using_map.ai_shell_restricted && !(new_z in GLOB.using_map.ai_shell_allowed_levels))
			to_chat(src,"<span class='warning'>Your connection with the shell is suddenly interrupted!</span>")
			undeploy()
	..()
