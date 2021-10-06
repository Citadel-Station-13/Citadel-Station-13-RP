/datum/category_item/catalogue/fauna/goose
	name = "Planetary Fauna - Geese"
	desc = "Another Avian species, geese are sometimes utilized as a \
	food source, but are generally too aggressive and temperamental to \
	domesticate. Especially when compared to other, more viable options."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/space/goose
	name = "goose"
	desc = "It looks pretty angry!"
	tt_desc = "E Branta canadensis" //that iconstate is just a regular goose
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/goose)

	faction = "geese"
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 5
	attacktext = list("pecked")
	attack_sound = 'sound/weapons/bite.ogg'

	has_langs = list("Bird")

	meat_type = /obj/item/reagent_containers/food/snacks/meat

//Randomization Code
/mob/living/simple_mob/animal/space/goose/Initialize()
	. = ..()
	var/mod = rand(50,150)/100
	size_multiplier = mod
	maxHealth = round(30*mod)
	health = round(30*mod)
	melee_damage_lower = round(5*mod)
	melee_damage_upper = round(5*mod)
	movement_cooldown = round(5*mod)
	update_icons()

/datum/say_list/goose
	speak = list("HONK!")
	emote_hear = list("honks loudly!")
	say_maybe_target = list("Honk?")
	say_got_target = list("HONK!!!")

/mob/living/simple_mob/animal/space/goose/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

/mob/living/simple_mob/animal/space/goose/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)

/mob/living/simple_mob/animal/space/goose/virgo3b
	faction = "virgo3b"
