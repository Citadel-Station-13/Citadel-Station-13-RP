/datum/category_item/catalogue/fauna/gutshank
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
	desc = "These chitinous parasites sport thick, chitinous shells which protect them from the heat and assaults."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "gutshank"
	icon_living = "gutshank"
	icon_dead = "gutshank_dead"
	icon_gib = "syndicate_gib"

	maxHealth = 100
	health = 100
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1

	mob_class = MOB_CLASS_ANIMAL
	movement_cooldown = 6
	movement_sound = 'sound/effects/spider_loop.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list ("bites", "pierces", "mauls")
	attack_sound = 'sound/weapons/bite.ogg'

	exotic_type = /obj/item/stack/material/chitin
	exotic_amount = 5

	faction = "lavaland"
	speak_emote = list("chatters")
	say_list_type = /datum/say_list/gutshank
	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/datum/reagents/shank_gland = null

/datum/say_list/gutshank
	emote_hear = list("rubs its mandibles together.", "skitters around.", "trills.")
	emote_see = list ("clacks its mandibles.", "shudders and jerks.")

/mob/living/simple_mob/animal/gutshank/Initialize(mapload)
	. = ..()
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
	else
		..()

/mob/living/simple_mob/animal/gutshank/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		if(shank_gland && prob(5))
			shank_gland.add_reagent("water", rand(5, 10))
