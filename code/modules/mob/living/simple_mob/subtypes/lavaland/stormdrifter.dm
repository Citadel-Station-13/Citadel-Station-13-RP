//Stormdrifters
/datum/category_item/catalogue/fauna/stormdrifter/stormdrifters
	name = "Stormdrifters"
	desc = "Stormdrifters are a rare sight on the surface of Surt. Where for other native fauna this may have \
	been true due to their subterranean lifestyle, Stormdrifters exist on the opposite side of the spectrum. These \
	floating creatures are typically found in the lower atmosphere of Surt. Travelling in pods of hundreds, Stormdrifters \
	were so named due to their tendency to get caught up in ash storms, which might carry them for hundreds to thousands of \
	miles before dropping them nearby. The arrival of a pod of Stormdrifters is often considered an omen of especially bad \
	weather. Rarely, these creatures may drift down closer to Surt's surface, where Ashlanders will eagerly capture them for \
	unknown purposes."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/stormdrifter)

/datum/category_item/catalogue/fauna/all_stormdrifters
	name = "Collection - Stormdrifters"
	desc = "You have scanned all known variants of Stormdrifter, \
	and therefore you have been granted a fair sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/stormdrifter,
		/datum/category_item/catalogue/fauna/stormdrifter/bull
		)

//Netches! (Expand on this later with more detail.)

/datum/category_item/catalogue/fauna/stormdrifter
	name = "Stormdrifter Polyp"
	desc = "The common Stormdrifter is passive. If provoked, this creature is able to attack with the tendrils which dangle \
	below its body. In a mechanism vaguely similar to Old Earth jellyfish, these tendrils pass on a debilitating pulse of electricity \
	which scrambles the motor control of their assailant. Stormdrifters are very rarely seen being cultivated by Ashlanders, leading \
	to speculation that the Scori may be experimenting with air travel."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/stormdrifter
	name = "stormdrifter polyp"
	desc = "These curious entities are able to fly thanks to the gaseous bags which comprise most of their body. They are generally passive, unless threatened."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "stormdrifter"
	icon_living = "stormdrifter"
	icon_dead = "stormdrifter_dead"
	icon_gib = "syndicate_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/stormdrifter)

	maxHealth = 100
	health = 100
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1
	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE

	mob_class = MOB_CLASS_ANIMAL
	taser_kill = FALSE
	movement_cooldown = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = list ("lashed", "whipped", "stung")
	attack_sound = 'sound/weapons/towelwhip.ogg'

	exotic_type = /obj/item/elderstone
	meat_amount = 0
	bone_amount = 0
	exotic_amount = 1

	faction = "lavaland"
	speak_emote = list("rumbles")
	say_list_type = /datum/say_list/stormdrifter
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/stormdrifter

/datum/say_list/stormdrifter
	emote_hear = list("drifts back and forth.", "gently flails its tendrils about.", "warbles.")
	emote_see = list ("wriggles its tendrils.", "bobs up and down.")

/datum/ai_holder/polaris/simple_mob/stormdrifter
	hostile = FALSE
	retaliate = TRUE
	can_flee = TRUE

/mob/living/simple_mob/animal/stormdrifter/apply_melee_effects(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		L.adjustHalLoss(10)
		to_chat(L, SPAN_DANGER("\The [src] strikes you with a crackling tendril!"))
		playsound(L, 'sound/effects/sparks6.ogg', 75, 1)

//Stormdrifter Bulls!
/datum/category_item/catalogue/fauna/stormdrifter/bull
	name = "Stormdrifter Bull"
	desc = "The hide of a Stormdrifter Bull is much thicker than that of a Polyp. Bulls also possess significantly \
	better developed tendrils. These two factors alone make the Bull a far more formidable opponnent than the simple Polyp. \
	However, Bulls are also far more territorial and aggressive than Polyps, and will attack to protect any threat to the pod, \
	real or perceived."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/stormdrifter/bull
	name = "stormdrifter bull"
	desc = "Unlike the more passive Polyp, Stormdrifter Bulls are hardy and formidable. Fiercely territorial, Bulls will aggressively protect Stormdrifter pods."
	icon_state = "bulldrifter"
	icon_living = "bulldrifter"
	icon_dead = "bulldrifter_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/stormdrifter/bull)

	maxHealth = 200
	health = 200

	movement_cooldown = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_sound = 'sound/weapons/punch2.ogg'

	exotic_type = /obj/item/stack/sinew
	exotic_amount = 5

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/stormdrifter/bull

	buckle_lying = FALSE
	buckle_max_mobs = 2
	buckle_allowed = FALSE
	buckle_flags = BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF|BUCKLING_GROUND_HOIST

	var/neutered = 0
	var/rideable = 0

/datum/ai_holder/polaris/simple_mob/stormdrifter/bull
	hostile = TRUE
	cooperative = TRUE
	can_flee = FALSE

/datum/ai_holder/polaris/simple_mob/stormdrifter/bull_neutered
	hostile = FALSE
	cooperative = FALSE
	can_flee = FALSE

/mob/living/simple_mob/animal/stormdrifter/bull/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/tool/wirecutters) || is_sharp(O))
		to_chat(user, "<span class='danger'>You amputate the [src]'s stingers! It may now be domesticated!</span>")
		neutered = 1
		melee_damage_lower = 5
		melee_damage_upper = 10
		ai_holder_type = /datum/ai_holder/polaris/simple_mob/stormdrifter/bull_neutered

	if(istype(O, /obj/item/saddle/stormdrifter) && !rideable)
		if(!neutered)
			to_chat(user, "<span class='danger'>You decide against approaching the [src] with the [O] while its stingers are intact!</span>")
			return
		else
			to_chat(user, "<span class='danger'>You hang the [O] on the [src]! It may now be ridden safely!</span>")
			rideable = 1
			buckle_allowed = TRUE
			AddComponent(/datum/component/riding_handler/stormdrifter_bull)
			qdel(O)

	if(istype(O, /obj/item/tool/wirecutters || is_sharp(O)) && rideable)
		to_chat(user, "<span class='danger'>You nip the straps of the [O]! It falls off of the [src].</span>")
		rideable = 0
		buckle_allowed = FALSE
		DelComponent(/datum/component/riding_handler, /datum/component/riding_handler/stormdrifter_bull)
		var/turf/T = get_turf(src)
		new /obj/item/saddle/stormdrifter(T)
	if(istype(O, /obj/item/pen/charcoal) && rideable)
		RenameMount()
	update_icon()

/mob/living/simple_mob/animal/stormdrifter/bull/proc/RenameMount()
	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.faction == src.faction)
		to_chat(M, "<span class='notice'>You don't feel familiar enough with this beast to name it.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name your mount?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name this mount [input]. Ride together.")
		return 1

/datum/component/riding_handler/stormdrifter_bull
	rider_offsets = list(
		list(
			list(0, 9, -0.1, null),
			list(9, 10, -0.1, null),
			list(0, 9, -0.1, null),
			list(-7, 10, -0.1, null)
		),
		list(
			list(0, 9, -0.2, null),
			list(-7, 9, -0.2, null),
			list(0, 11, -0.2, null),
			list(7, 10, -0.2, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	riding_handler_flags = CF_RIDING_HANDLER_IS_CONTROLLABLE
	vehicle_move_delay = 2

/mob/living/simple_mob/animal/stormdrifter/bull/update_icon()
	if(neutered)
		icon_state = "bulldrifter_neutered"
	if(rideable)
		icon = 'icons/mob/lavaland/lavaland_mobs32x64.dmi'
		icon_state = "bulldrifter_riding"
		add_overlay("bulldrifter_saddled")
	else if(!rideable)
		icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
		icon_state = "bulldrifter_neutered"
		cut_overlays()
