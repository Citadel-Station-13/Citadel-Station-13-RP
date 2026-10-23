/mob/living/simple_mob/mechanical/derelict/interloper
	name = "Interloper"
	desc = "A lithe machine that hovers over the ground utilizing a method you cannot recognize. Some sort of monochrome 'flame' can be seen emerging from its arms and head."

	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/interloper.dmi'
	icon_state = "interloper"
	icon_living = "interloper"
	icon_dead = "interloper_dead"
	color = "#808080"

	iff_factions = MOB_IFF_FACTION_DERELICT_AUTOMATONS
	health = 300
	maxHealth = 300
	self_rejuvination = TRUE
	movement_base_speed = 10 / 3
	hovering = TRUE

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/inert

/mob/living/simple_mob/mechanical/derelict/interloper/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
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
