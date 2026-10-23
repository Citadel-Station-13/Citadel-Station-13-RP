// Fragment

/mob/living/simple_mob/animal/eldritch/fragment/Click(mob/user, location, control, params)
	if(invisibility == 25)
		return ..()
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		return
	if(usr && istype(usr, /mob/observer/dead))
		return FALSE
	visible_message("<span class='warning'>[usr.name] stares into empty space.</span>")
	return TRUE

// Entity

/mob/living/simple_mob/animal/eldritch/entity/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	visible_message("<span class='warning'>The [proj.name] reflects off of [src]'s form!</span>", \
					"<span class='warning'>The [proj.name] reflects off of [src]'s form!</span>")

	var/turf/curloc = get_turf(src)
	var/start_x = proj.starting ? proj.starting.x : curloc.x
	var/start_y = proj.starting ? proj.starting.y : curloc.y
	var/new_x = start_x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
	var/new_y = start_y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)


	proj.legacy_redirect(new_x, new_y, curloc, src)
	proj.reflected = TRUE

	return PROJECTILE_IMPACT_REFLECT

/mob/living/simple_mob/animal/eldritch/entity/verb/phase_shift()
	set name = "Shift"
	set category = "Abilities"

	var/list/destinations = list()
	for(var/offset_x = -2, offset_x <= 2, offset_x++)
		for(var/offset_y = -2, offset_y <= 2, offset_y++)
			var/turf/destination = locate(x + offset_x, y + offset_y, z)
			if(destination && !destination.density && !istype(destination, /turf/space) && destination != loc)
				destinations += destination

	if(destinations.len)
		forceMove(pick(destinations))
		playsound(src, 'sound/effects/teleport.ogg', 50, TRUE)
		visible_message("<span class='warning'>[src] flickers out of reality and snaps back into existence.</span>")


/mob/living/simple_mob/animal/eldritch/entity/verb/rift_bolt(mob/target in oview(7))
	set name = "Dislocate"
	set category = "Abilities"

	if(!target)
		return

	visible_message("[src]<span class='hierophant'> reverberates, 'EV'RUIM!'</span>")
	var/obj/item/projectile/eldritch_teleport/P = new(get_turf(src))
	P.firer = src
	P.preparePixelProjectile(target, get_turf(src))
	P.fire()

/mob/living/simple_mob/animal/eldritch/entity/verb/inflict_agony(mob/living/target in oview(7))
	set name = "Agonize"
	set category = "Abilities"

	if(!target)
		return

	visible_message("[src]<span class='hierophant'> reverberates, 'AK'VUN!'</span>")
	target.adjustHalLoss(80)
	target.visible_message("<span class='boldwarning'>[target] convulses in agony!</span>")
	playsound(target, 'sound/weapons/Dissolverray.ogg', 50, TRUE)

/mob/living/simple_mob/animal/eldritch/entity/verb/emp_blast(mob/living/target in oview(7))
	set name = "Disrupt"
	set category = "Abilities"

	if(!target)
		return

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	visible_message("[src]<span class='hierophant'> reverberates, 'IS'PRI!'</span>")
	target.visible_message("<span class='danger'>[target] distorts as they emits a wave of crackling energy!</span>")
	empulse(target_turf, 0, 1, 3, 4, 1)
	target.adjustHalLoss(50)

/mob/living/simple_mob/animal/eldritch/entity/verb/ignite_target(mob/living/target in oview(7))
	set name = "Incinerate"
	set category = "Abilities"

	if(!target)
		return

	visible_message("[src]<span class='hierophant'> reverberates, 'VAO'TRUN!'</span>")
	target.adjustFireLoss(30)
	target.fire_stacks = max(target.fire_stacks, 6)
	target.IgniteMob()
	target.visible_message("<span class='boldwarning'>[target] erupts into a blazing inferno!</span>")



/mob/living/simple_mob/animal/eldritch/entity/verb/chaos_shift()
	set name = "Rebound"
	set category = "Abilities"

	for(var/mob/living/M in range(2, src))
		if(M == src)
			continue

		var/turf/origin = get_turf(M)
		if(!origin)
			continue

		var/list/destinations = list()
		for(var/offset_x = -3, offset_x <= 3, offset_x++)
			for(var/offset_y = -3, offset_y <= 3, offset_y++)
				var/turf/destination = locate(origin.x + offset_x, origin.y + offset_y, origin.z)
				if(!destination || istype(destination, /turf/space) || destination.density || destination == origin)
					continue

				var/blocked_by_dense_atom = FALSE
				for(var/atom/obstacle in destination)
					if(obstacle.density)
						blocked_by_dense_atom = TRUE
						break
				if(blocked_by_dense_atom)
					continue

				if(offset_x && offset_y)
					var/turf/x_step = locate(origin.x + offset_x, origin.y, origin.z)
					var/turf/y_step = locate(origin.x, origin.y + offset_y, origin.z)
					if(!x_step || x_step.density || !y_step || y_step.density)
						continue

				destinations += destination

		if(destinations.len)
			visible_message("[src]<span class='hierophant'> reverberates, 'IKO'VRIA'ESIN!!'</span>")
			M.forceMove(pick(destinations))
			M.visible_message("<span class='warning'>[M] is violently distorted into another location!</span>")
			playsound(M, 'sound/magic/Repulse.ogg', 50, TRUE)

/obj/item/projectile/eldritch_teleport
	name = "rift bolt"
	var/damage = 0
	var/firer = null
	var/atom/target_atom = null

/obj/item/projectile/eldritch_teleport/proc/preparePixelProjectile(atom/target_to_hit, turf/start_turf)
	target_atom = target_to_hit
	if(start_turf)
		forceMove(start_turf)
	return TRUE

/obj/item/projectile/eldritch_teleport/proc/fire()
	if(!target_atom)
		return
	var/atom/shot_target = target_atom
	var/turf/shot_from = get_turf(src)
	if(!shot_from || !get_turf(shot_target))
		return
	on_hit(shot_target)
	qdel(src)

/obj/item/projectile/eldritch_teleport/proc/on_hit(atom/target, blocked = 0)
	if(blocked || !ismob(target))
		return

	var/mob/M = target
	var/turf/origin = get_turf(M)
	if(!origin)
		return

	var/list/destinations = list()
	for(var/offset_x = -3, offset_x <= 3, offset_x++)
		for(var/offset_y = -3, offset_y <= 3, offset_y++)
			var/turf/destination = locate(origin.x + offset_x, origin.y + offset_y, origin.z)
			if(!destination || istype(destination, /turf/space) || destination.density || destination == origin)
				continue

			var/blocked_by_dense_atom = FALSE
			for(var/atom/obstacle in destination)
				if(obstacle.density)
					blocked_by_dense_atom = TRUE
					break
			if(blocked_by_dense_atom)
				continue

			// Block diagonal moves that would cut through a wall corner.
			if(offset_x && offset_y)
				var/turf/x_step = locate(origin.x + offset_x, origin.y, origin.z)
				var/turf/y_step = locate(origin.x, origin.y + offset_y, origin.z)
				if(!x_step || x_step.density || !y_step || y_step.density)
					continue

			destinations += destination

	if(destinations.len)
		M.forceMove(pick(destinations))
		M.visible_message("<span class='warning'>[M] distorts as they suddenly appear somewhere else!</span>")
		playsound(M, 'sound/effects/uncloak.ogg', 50, TRUE)



// Skinstealer


/mob/living/simple_mob/animal/eldritch/skinstealer
	var/shapeshift_original_appearance
	var/shapeshift_original_name
	var/shapeshift_original_desc
	var/shapeshift_original_icon
	var/shapeshift_original_icon_state
	var/shapeshift_original_color
	var/shapeshift_original_alpha
	var/shapeshift_original_dir
	var/shapeshift_original_pixel_x
	var/shapeshift_original_pixel_y
	var/shapeshift_original_transform
	var/list/shapeshift_original_overlays
	var/list/shapeshift_original_underlays
	var/list/shapeshift_original_combat
	var/list/shapeshift_original_verbs
	var/is_shapeshifted = FALSE
	var/list/shapeshift_blacklist = list(
		/mob/living/simple_mob/animal/eldritch/skinstealer,
		/mob/living/simple_mob/animal/roach,
		/mob/living/simple_mob/animal/passive/mouse)

/mob/living/simple_mob/animal/eldritch/skinstealer/proc/is_shapeshift_blacklisted(mob/living/target)
	if(!target)
		return TRUE
	for(var/blacklisted_type in shapeshift_blacklist)
		if(istype(target, blacklisted_type))
			return TRUE
	return FALSE

/mob/living/simple_mob/animal/eldritch/skinstealer/verb/choose_shapeshift()
	set name = "Choose Form"
	set category = "Abilities"

	var/list/available_forms = list()
	for(var/mob/living/simple_mob/simple_target in world)
		if(is_shapeshift_blacklisted(simple_target))
			continue
		if(simple_target == src)
			continue
		available_forms += simple_target

	if(!available_forms.len)
		return

	var/mob/living/simple_mob/selected_form = input(src, "Choose a simple mob form to imitate.", "Choose Form") as null|anything in available_forms
	if(selected_form && selected_form != src)
		shapeshift(selected_form)

/mob/living/simple_mob/animal/eldritch/skinstealer/verb/shapeshift(mob/living/target in view(7))
	set name = "Shapeshift"
	set category = "Abilities"

	if(!target || target == src || is_shapeshift_blacklisted(target))
		return
	if(is_shapeshifted)
		revert_shapeshift()

	shapeshift_original_appearance = appearance
	shapeshift_original_name = name
	shapeshift_original_desc = desc
	shapeshift_original_icon = icon
	shapeshift_original_icon_state = icon_state
	shapeshift_original_color = color
	shapeshift_original_alpha = alpha
	shapeshift_original_dir = dir
	shapeshift_original_pixel_x = pixel_x
	shapeshift_original_pixel_y = pixel_y
	shapeshift_original_transform = transform
	shapeshift_original_overlays = overlays.Copy()
	shapeshift_original_underlays = underlays.Copy()
	// Copy the complete appearance so icon metadata and other appearance-level properties are retained.
	appearance = target.appearance
	icon = target.icon
	icon_state = target.icon_state
	color = target.color
	alpha = target.alpha
	dir = target.dir
	pixel_x = target.pixel_x
	pixel_y = target.pixel_y
	transform = target.transform
	overlays = target.overlays.Copy()
	underlays = target.underlays.Copy()
	name = target.name
	desc = target.desc
	shapeshift_original_verbs = verbs.Copy()
	for(var/verb_path in target.verbs)
		if(!(verb_path in verbs))
			verbs += verb_path

	if(istype(target, /mob/living/simple_mob))
		var/mob/living/simple_mob/simple_target = target
		var/list/combat_properties = list("melee_damage_lower", "melee_damage_upper", "melee_damage_type", "attacktext", "attack_verb", "attack_sound", "attack_sharp", "attack_edge", "attack_armor_pen", "attack_type", "attack_cooldown", "ranged", "ranged_cooldown", "ranged_attack_cooldown", "ranged_attack_damage", "ranged_attack_projectile", "ranged_attack_sound", "ranged_attack_message", "ranged_attack_uses_projectile", "ranged_attack_pixel_projectile", "ranged_attack_speed", "ranged_attack_range", "ranged_attack_delay", "ranged_attack_min", "ranged_attack_max", "special_attack", "special_attack_type", "special_attack_cooldown", "special_attack_damage", "special_attack_range", "special_attack_min", "special_attack_max", "projectiletype")
		shapeshift_original_combat = list()
		for(var/property in combat_properties)
			if(!(property in vars) || !(property in simple_target.vars))
				continue
			shapeshift_original_combat[property] = vars[property]
			vars[property] = simple_target.vars[property]
		// Also copy custom attack, damage, and special-ability settings and their supporting vars.
		for(var/property in simple_target.vars)
			var/property_name = lowertext("[property]")
			if(!(findtext(property_name, "attack") || findtext(property_name, "damage") || findtext(property_name, "ability") || findtext(property_name, "special") || findtext(property_name, "power") || findtext(property_name, "spell") || findtext(property_name, "skill") || findtext(property_name, "cooldown") || findtext(property_name, "projectile") || findtext(property_name, "move") || findtext(property_name, "speed") || findtext(property_name, "sound")))
				continue
			if(!(property in vars) || (property in shapeshift_original_combat))
				continue
			shapeshift_original_combat[property] = vars[property]
			vars[property] = simple_target.vars[property]
	else
		shapeshift_original_combat = list()
		for(var/property in target.vars)
			var/property_name = lowertext("[property]")
			if(!(findtext(property_name, "attack") || findtext(property_name, "damage") || findtext(property_name, "ability") || findtext(property_name, "special") || findtext(property_name, "power") || findtext(property_name, "spell") || findtext(property_name, "skill") || findtext(property_name, "cooldown") || findtext(property_name, "projectile") || findtext(property_name, "move") || findtext(property_name, "speed") || findtext(property_name, "sound")))
				continue
			if(!(property in vars) || (property in shapeshift_original_combat))
				continue
			shapeshift_original_combat[property] = vars[property]
			vars[property] = target.vars[property]

	is_shapeshifted = TRUE
	new /obj/effect/particle_effect/smoke(get_turf(src))
	visible_message("<span class='warning'>[src] destabilizes as it shifts form!</span>")
	playsound(src, 'sound/effects/blobattack.ogg', 50, TRUE)

/mob/living/simple_mob/animal/eldritch/skinstealer/verb/revert_shapeshift()
	set name = "Revert Shapeshift"
	set category = "Abilities"

	if(!is_shapeshifted)
		return

	appearance = shapeshift_original_appearance
	icon = shapeshift_original_icon
	icon_state = shapeshift_original_icon_state
	color = shapeshift_original_color
	alpha = shapeshift_original_alpha
	dir = shapeshift_original_dir
	pixel_x = shapeshift_original_pixel_x
	pixel_y = shapeshift_original_pixel_y
	transform = shapeshift_original_transform
	overlays = shapeshift_original_overlays
	underlays = shapeshift_original_underlays
	name = shapeshift_original_name
	desc = shapeshift_original_desc
	if(shapeshift_original_combat)
		for(var/property in shapeshift_original_combat)
			vars[property] = shapeshift_original_combat[property]
	shapeshift_original_combat = null
	if(shapeshift_original_verbs)
		for(var/verb_path in verbs.Copy())
			if(!(verb_path in shapeshift_original_verbs))
				verbs -= verb_path
	shapeshift_original_verbs = null
	shapeshift_original_appearance = null
	shapeshift_original_name = null
	shapeshift_original_desc = null
	shapeshift_original_icon = null
	shapeshift_original_icon_state = null
	shapeshift_original_color = null
	shapeshift_original_alpha = null
	shapeshift_original_dir = null
	shapeshift_original_pixel_x = null
	shapeshift_original_pixel_y = null
	shapeshift_original_transform = null
	shapeshift_original_overlays = null
	shapeshift_original_underlays = null
	is_shapeshifted = FALSE
	new /obj/effect/particle_effect/smoke(get_turf(src))
	visible_message("<span class='warning'>[src] emits a sickening crack as it returns to its original form!</span>")
	playsound(src, 'sound/effects/blobattack.ogg', 50, TRUE)


