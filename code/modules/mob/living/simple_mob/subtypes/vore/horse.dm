/datum/category_item/catalogue/fauna/horse
	name = "Horse"
	desc = "A long-time companion of Humanity, the horse served as the \
	primary method of transportation for pre-industrial Humans for thousands \
	of years. That bond has remained even as technology has rendered the \
	creature obsolete. Kept for sentimentality and niche utility reasons, \
	the horse is still viable on planets where industrialization is not yet \
	possible."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/horse
	name = "horse"
	desc = "Don't look it in the mouth."
	tt_desc = "Equus ferus caballus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/horse)

	icon_state = "horse"
	icon_living = "horse"
	icon_dead = "horse-dead"
	icon = 'icons/mob/animal.dmi'

	faction = "horse"
	maxHealth = 60
	health = 60
	randomized = TRUE
	mod_min = 100
	mod_max = 130

	movement_cooldown = 4 //horses are fast mkay.
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	legacy_melee_damage_lower = 1
	legacy_melee_damage_upper = 5
	attacktext = list("kicked")

	meat_amount = 4
	meat_type = /obj/item/reagent_containers/food/snacks/horsemeat
	bone_amount = 2
	hide_amount = 4
	exotic_amount = 2

	buckle_lying = FALSE
	buckle_max_mobs = 2
	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF

	say_list_type = /datum/say_list/horse
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	var/rideable = 0

/mob/living/simple_mob/horse/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/riding_filter/mob/animal/horse)

/datum/component/riding_filter/mob/animal/horse

/datum/component/riding_handler/horse
	rider_offsets = list(
		list(
			list(0, 8, 0.1, null),
			list(0, 8, 0.1, null),
			list(0, 8, -0.1, null),
			list(0, 8, 0.1, null)
		),
		list(
			list(0, 8, 0.2, null),
			list(-7, 8, 0.2, null),
			list(0, 8, -0.2, null),
			list(7, 8, 0.2, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	riding_handler_flags = CF_RIDING_HANDLER_IS_CONTROLLABLE

/mob/living/simple_mob/horse/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/saddle/horse) && !rideable)
		to_chat(user, "<span class='danger'>You sling the [O] onto the [src]! It may now be ridden safely!</span>")
		rideable = 1
		AddComponent(/datum/component/riding_handler/horse)
		qdel(O)
	if(istype(O, /obj/item/tool/wirecutters) && rideable)
		to_chat(user, "<span class='danger'>You nip the straps of the [O]! It falls off of the [src].</span>")
		rideable = 0
		DelComponent(/datum/component/riding_handler, /datum/component/riding_handler/horse)
		var/turf/T = get_turf(src)
		new /obj/item/saddle/horse(T)
	update_icon()

/mob/living/simple_mob/horse/update_icon()
	if(rideable)
		add_overlay("horse_saddled")
	else if(!rideable)
		cut_overlays()

/datum/say_list/horse
	speak = list("NEHEHEHEHEH","Neh?")
	emote_hear = list("snorts","whinnies")
	emote_see = list("shakes its head", "stamps a hoof", "looks around")
