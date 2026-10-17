/mob/living/simple_mob/mechanical/derelict/anchor
	name = "anchor"
	desc = "Something that resembles a hovering cylinder. Purple lights flash across every one of its surfaces, forming patterns you do not recognize."

	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/anchor.dmi'
	icon_state = "anchor"
	icon_living = "anchor"


	health = 150
	maxHealth = 150
	movement_base_speed = 10 / 4
	hovering = TRUE


	base_attack_cooldown = 6
	legacy_melee_damage_upper = 0
	legacy_melee_damage_lower = 0

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/inert

/mob/living/simple_mob/mechanical/derelict/anchor/Initialize(mapload)
	. = ..()
	spawn(0)
		apply_area_distortion()

/mob/living/simple_mob/mechanical/derelict/anchor/proc/apply_area_distortion()
	var/wave_filter_id = "area_wave_\ref[src]"
	var/list/wave_filter = list("type" = "wave", "x" = 4, "y" = 4, "size" = 6, "offset" = 4, "flags" = WAVE_BOUNDED)
	var/list/affected_atoms = list()
	var/list/affected_viewers = list()
	while(src)
		var/list/current_atoms = list()
		var/list/current_viewers = list()
		for(var/mob/living/viewer in viewers(src))
			if(!viewer.client || istype(viewer, /mob/living/simple_mob/mechanical/derelict))
				continue
			current_viewers |= viewer
			if(!(viewer in affected_viewers))
				to_chat(viewer, SPAN_BOLDWARNING("The world ripples and warps around you."))
			for(var/atom/screen_atom in viewer.client.screen)
				if(istype(screen_atom, /mob/living/simple_mob/mechanical/derelict))
					continue
				current_atoms |= screen_atom
				if(!(screen_atom in affected_atoms))
					screen_atom.add_filter(wave_filter_id, 11, wave_filter)
			for(var/atom/visible_atom in view(viewer))
				if(istype(visible_atom, /mob/living/simple_mob/mechanical/derelict))
					continue
				current_atoms |= visible_atom
				if(!(visible_atom in affected_atoms))
					visible_atom.add_filter(wave_filter_id, 11, wave_filter)
		for(var/atom/affected_atom in affected_atoms)
			if(!(affected_atom in current_atoms))
				affected_atom.remove_filter(wave_filter_id)
		affected_atoms = current_atoms
		affected_viewers = current_viewers
		sleep(10)
	for(var/atom/affected_atom in affected_atoms)
		affected_atom.remove_filter(wave_filter_id)

/mob/living/simple_mob/mechanical/derelict/anchor/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	visible_message("<span class='warning'>The [proj.name] reflects off of [src]'s shell!</span>", \
					"<span class='warning'>The [proj.name] reflects off of [src]'s shell!</span>")

	var/turf/curloc = get_turf(src)
	var/start_x = proj.starting ? proj.starting.x : curloc.x
	var/start_y = proj.starting ? proj.starting.y : curloc.y
	var/new_x = start_x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
	var/new_y = start_y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)


	proj.legacy_redirect(new_x, new_y, curloc, src)
	proj.reflected = TRUE

	return PROJECTILE_IMPACT_REFLECT
