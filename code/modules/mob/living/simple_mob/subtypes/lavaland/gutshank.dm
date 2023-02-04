/datum/category_item/catalogue/fauna/shank/shanks
	name = "Shanks"
	desc = "The Shank is a species of parasite endemic to KT-943 which exhibits a uniquely interesting life cycle. \
	Hatching from eggs into their larval form - the common Gutshank, these hardy tick-like creatures feed on the blood \
	of larger beasts like Goliaths. Able to wriggle into the dorsal folds with ease, their hard carapaces protect \
	Gutshanks from retaliation until they have attached to their host. Over time, Gutshanks will naturally molt and \
	develop into Shanks. Pictographic evidence found in ancient Scorian archaeological sites suggests the existence \
	of an even larger developmental form beyond Shanks, though this has yet to be confirmed."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/shank)

/datum/category_item/catalogue/fauna/all_shanks
	name = "Collection - Shanks"
	desc = "You have scanned Shanks at different parts of their life cycle, \
	and therefore you have been granted a fair sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/shank,
		/datum/category_item/catalogue/fauna/shank/gutshank
		)

//Notes for later development. ~Cap
//Gutshanks are actually the immature stage of the Shank. Larger Shanks are able to be mounted and ridden by Ashlanders.
//Gutshanks parasitize until they reach maturity and molt. They continue to feed primarily on blood, but at this stage they begin to process silt and rocks in their diet as well.
//Shanks mature even further into something like Silt Striders, which can be used as pack animals and safe transit over lava floes.

/datum/category_item/catalogue/fauna/shank/gutshank
	name = "Gutshank"
	desc = "Gutshanks are rather frightening pests. Parasitic by nature, the Gutshank feeds on warm blood to \
	sustain itself. Although they will typically feed on Goliaths, these creatures have been observed drinking \
	from Ashlanders and injured Miners. For unknown reasons, they are able to process blood from any species \
	without issue. Some of this blood is processed through a special gland the Gutshank possesses, which filters \
	it into water. For this reason, Ashlanders have been observed farming the parasites to use as a source of \
	potable drinking water."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/gutshank
	name = "gutshank"
	desc = "These dog-sized parasites sport thick, chitinous shells which protect them from both attacks and the heat."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "gutshank"
	icon_living = "gutshank"
	icon_dead = "gutshank_dead"
	icon_gib = "syndicate_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shank/gutshank)

	maxHealth = 100
	health = 100
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1

	mob_class = MOB_CLASS_ANIMAL
	taser_kill = FALSE
	movement_cooldown = 6
	movement_sound = 'sound/effects/spider_loop.ogg'
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = list ("bitten", "pierced", "mauled")
	attack_sound = 'sound/weapons/bite.ogg'

	exotic_type = /obj/item/stack/material/chitin
	exotic_amount = 5

	faction = "lavaland"
	speak_emote = list("chatters")
	say_list_type = /datum/say_list/gutshank
	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/datum/reagents/shank_gland = null
	var/growing = 0
	var/amount_grown = 1
	var/list/grow_as = list(/mob/living/simple_mob/animal/shank)

/datum/say_list/gutshank
	emote_hear = list("rubs its mandibles together.", "skitters around.", "trills.")
	emote_see = list ("clacks its mandibles.", "shudders and jerks.")

/mob/living/simple_mob/animal/gutshank/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	shank_gland = new(50)
	shank_gland.my_atom = src

/mob/living/simple_mob/animal/gutshank/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = shank_gland.trans_id_to(G, "water", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<font color='red'>The [O] is full.</font>")
		if(!transfered)
			to_chat(user, "<font color='red'>The gland is dry. Wait a bit longer...</font>")
	else if(istype(O, /obj/item/seeds) && !growing)
		to_chat(user, "<span class='danger'>You feed the [O] to [src]! Its carapace begins to harden and split!</span>")
		growing = 1
		qdel(O)
	else
		..()

/mob/living/simple_mob/animal/gutshank/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		if(shank_gland && prob(5))
			shank_gland.add_reagent("water", rand(5, 10))

/mob/living/simple_mob/animal/gutshank/process(delta_time)
	if(growing)
		if(amount_grown >= 0)
			amount_grown += rand(0,2)
		if(amount_grown >= 150)
			mature()
	else
		return

/mob/living/simple_mob/animal/gutshank/proc/mature()
	var/spawn_type = pick(grow_as)
	new spawn_type(src.loc, src)
	qdel(src)

//It would make more sense for this creature to inject a soporific and then drain blood after it detects the user is unconscious.
//However, this would be very brutal for solo miners to contend with, so it just draws blood instead.
/mob/living/simple_mob/animal/gutshank/apply_melee_effects(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				blood_drink(L, target_zone)

/mob/living/simple_mob/animal/gutshank/proc/blood_drink(var/mob/living/carbon/human/M)
	if(istype(M))
		to_chat(M, "<span class='warning'>The [src] pierces your flesh! You feel a sickening suction!</span>")
		M.vessel.remove_reagent("blood",rand(10,20))

/mob/living/simple_mob/animal/gutshank/death()
	STOP_PROCESSING(SSobj, src)
	return ..()

//This is the Shank. It's the mature form of the Gutshank.
//It's intended to be used like a horse by Ashlanders, and won't have the same farming utility (water collection) its younger form does.
//To help navigate lava floes, I am considering giving it a flea-like jump ability, but I'm unsure how this combines with the riding system.

/datum/category_item/catalogue/fauna/shank
	name = "Shank"
	desc = "When allowed to mature, the common Gutshank transforms into a lightweight creature. Although still \
	subsiting primarily on a diet of blood, the Shank begins to also consume silt and loose rocks commonly found \
	in KT-943's soil. Shanks were originally believed to be an unrelated creature, due to the significian morphological \
	differences they display compared to their younger forms. However, since the return of Scorians to the surface, \
	evidence of these beasts being cultivated to serve as mounts and pack animals has confirmed this curious maturation cycle."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/shank
	name = "shank"
	desc = "This agile insectoid beast uses its maneuverability and flexible carapace to protect it when running down its prey."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "shank"
	icon_living = "shank"
	icon_dead = "shank_dead"
	icon_gib = "syndicate_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shank)

	maxHealth = 150
	health = 150
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1

	mob_class = MOB_CLASS_ANIMAL
	taser_kill = FALSE
	movement_cooldown = 4
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list ("bitten", "pierced", "mauled")
	attack_sound = 'sound/weapons/bite.ogg'

	exotic_type = /obj/item/stack/material/chitin
	exotic_amount = 5

	faction = "lavaland"
	speak_emote = list("chatters")
	say_list_type = /datum/say_list/gutshank
	//I changed the ai_holder from simple/melee to retaliate/coop because when riding a Shank, it would override user inputs to charge non-faction mobs. Which is annoying.
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

	buckle_lying = FALSE
	buckle_max_mobs = 1
	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF|BUCKLING_GROUND_HOIST

	var/rideable = 0

/mob/living/simple_mob/animal/shank/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/saddle/shank) && !rideable)
		to_chat(user, "<span class='danger'>You sling the [O] onto the [src]! It may now be ridden safely!</span>")
		rideable = 1
		AddComponent(/datum/component/riding_handler/shank)
		qdel(O)
	if(istype(O, /obj/item/tool/wirecutters) && rideable)
		to_chat(user, "<span class='danger'>You nip the straps of the [O]! It falls off of the [src].</span>")
		rideable = 0
		DelComponent(/datum/component/riding_handler/shank)
		var/turf/T = get_turf(src)
		new /obj/item/saddle/shank(T)
	if(istype(O, /obj/item/pen/charcoal) && rideable)
		RenameMount()
	update_icon()

/mob/living/simple_mob/animal/shank/proc/RenameMount()
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

/datum/component/riding_handler/shank
	rider_offsets = list(0, 11, 1, null)
	riding_handler_flags = CF_RIDING_HANDLER_IS_CONTROLLABLE

/mob/living/simple_mob/animal/shank/apply_melee_effects(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				blood_drink(L, target_zone)

/mob/living/simple_mob/animal/shank/proc/blood_drink(var/mob/living/carbon/human/M)
	if(istype(M))
		to_chat(M, "<span class='warning'>The [src] pierces your flesh! You feel a sickening suction!</span>")
		M.vessel.remove_reagent("blood",rand(20,25))

/mob/living/simple_mob/animal/shank/update_icon()
	if(rideable)
		add_overlay("shank_saddled")
	else if(!rideable)
		cut_overlays()
