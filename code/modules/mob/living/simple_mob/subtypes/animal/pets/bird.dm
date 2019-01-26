// Base bird type.

/mob/living/simple_mob/animal/passive/bird
	name = "bird"
	desc = "A domesticated bird. Tweet tweet!"
	player_msg = "You are able to fly."

	icon = 'icons/mob/birds.dmi'
	icon_state = "parrot"
	item_state = null
	icon_rest = "parrot-held"
	icon_dead = "parrot-dead"

	pass_flags = PASSTABLE

	health = 30
	maxHealth = 30
	melee_damage_lower = 3
	melee_damage_upper = 3

	movement_cooldown = 0
	hovering = TRUE // Birds can fly.
	softfall = TRUE
	parachuting = TRUE

	attacktext = list("claws", "pecks")
	speak_emote = list("chirps", "caws")
	has_langs = list("Bird")
	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"

	ai_holder_type = /datum/ai_holder/passive/bird
	say_list_type = /datum/say_list/bird
	holder_type = /obj/item/weapon/holder/bird

/datum/ai_holder/passive/bird
	speak_chance = 5

/datum/say_list/bird
	speak = list("Chirp!","Caw!","Screech!","Squawk!")
	speak_emote = list("chirps", "caws")
	emote_hear = list("chirps","caws")
	emote_see = list("shakes their head", "ruffles their feathers")

/obj/item/weapon/holder/bird
	name = "bird"
	desc = "It's a bird!"
	icon_state = null
	item_icons = null
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/holder/bird/sync(var/mob/living/simple_mob/SM)
	..()
	icon_state = SM.icon_rest // Looks better if the bird isn't flapping constantly in the UI.

// Subtypes for birbs.

/mob/living/simple_mob/animal/passive/bird/black_bird
	name = "common blackbird"
	desc = "A species of bird, both the males and females are known to be territorial on their breeding grounds."
	icon_state = "commonblackbird"
	icon_dead = "commonblackbird-dead"
	tt_desc = "E Turdus merula"
	icon_scale = 0.5

/mob/living/simple_mob/animal/passive/bird/azure_tit
	name = "azure tit"
	desc = "A species of bird, colored blue and white."
	icon_state = "azuretit"
	icon_dead = "azuretit-dead"
	tt_desc = "E Cyanistes cyanus"
	icon_scale = 0.5

/mob/living/simple_mob/animal/passive/bird/european_robin
	name = "european robin"
	desc = "A species of bird, they have been studied for their sense of magnetoreception."
	icon_state = "europeanrobin"
	icon_dead = "europeanrobin-dead"
	tt_desc = "E Erithacus rubecula"
	icon_scale = 0.5

/mob/living/simple_mob/animal/passive/bird/goldcrest
	name = "goldcrest"
	desc = "A species of bird, they were once called 'king of the birds' in ancient human folklore, for their golden crest. \
	Today, their scientific name still elude towards this, with <i>regulus</i>, meaning petty king."
	icon_state = "goldcrest"
	icon_dead = "goldcrest-dead"
	tt_desc = "E Regulus regulus"
	icon_scale = 0.5

/mob/living/simple_mob/animal/passive/bird/ringneck_dove
	name = "ringneck dove"
	desc = "A species of bird. They are also known as the barbary dove, and have a distinct ring-like shape around the back of their neck."
	icon_state = "ringneckdove"
	icon_dead = "ringneckdove-dead"
	tt_desc = "E Streptopelia risoria" // This is actually disputed IRL but since we can't tell the future it'll stay the same for 500+ years.
	icon_scale = 0.5

//The below is the original vorestation overrides - kevinz000

//Why are these a subclass of cat?
/mob/living/simple_mob/animal/passive/bird
	name = "parrot"
	desc = "A domesticated bird. Tweet tweet!"
	icon = 'icons/mob/birds.dmi'
	icon_state = "parrot-flap"
	item_state = null
	icon_living = "parrot-flap"
	icon_dead = "parrot-dead"

/mob/living/simple_mob/animal/passive/bird/kea
	name = "Kea"
	icon_state = "kea-flap"
	icon_living = "kea-flap"
	icon_dead = "kea-dead"

/mob/living/simple_mob/animal/passive/bird/eclectus
	name = "Eclectus"
	icon_state = "eclectus-flap"
	icon_living = "eclectus-flap"
	icon_dead = "eclectus-dead"

/mob/living/simple_mob/animal/passive/bird/eclectusf
	name = "Eclectus"
	icon_state = "eclectusf-flap"
	icon_living = "eclectusf-flap"
	icon_dead = "eclectusf-dead"

/mob/living/simple_mob/animal/passive/bird/greybird
	name = "Grey Bird"
	icon_state = "agrey-flap"
	icon_living = "agrey-flap"
	icon_dead = "agrey-dead"

/mob/living/simple_mob/animal/passive/bird/blue_caique
	name = "Blue Caique "
	icon_state = "bcaique-flap"
	icon_living = "bcaique-flap"
	icon_dead = "bcaique-dead"

/mob/living/simple_mob/animal/passive/bird/white_caique
	name = "White caique"
	icon_state = "wcaique-flap"
	icon_living = "wcaique-flap"
	icon_dead = "wcaique-dead"

/mob/living/simple_mob/animal/passive/bird/green_budgerigar
	name = "Green Budgerigar"
	icon_state = "gbudge-flap"
	icon_living = "gbudge-flap"
	icon_dead = "gbudge-dead"

/mob/living/simple_mob/animal/passive/bird/blue_Budgerigar
	name = "Blue Budgerigar"
	icon_state = "bbudge-flap"
	icon_living = "bbudge-flap"
	icon_dead = "bbudge-dead"

/mob/living/simple_mob/animal/passive/bird/bluegreen_Budgerigar
	name = "Bluegreen Budgerigar"
	icon_state = "bgbudge-flap"
	icon_living = "bgbudge-flap"
	icon_dead = "bgbudge-dead"

/mob/living/simple_mob/animal/passive/bird/commonblackbird
	name = "Black Bird"
	icon_state = "commonblackbird"
	icon_living = "commonblackbird"
	icon_dead = "commonblackbird-dead"

/mob/living/simple_mob/animal/passive/bird/azuretit
	name = "Azure Tit"
	icon_state = "azuretit"
	icon_living = "azuretit"
	icon_dead = "azuretit-dead"

/mob/living/simple_mob/animal/passive/bird/europeanrobin
	name = "European Robin"
	icon_state = "europeanrobin"
	icon_living = "europeanrobin"
	icon_dead = "europeanrobin-dead"

/mob/living/simple_mob/animal/passive/bird/goldcrest
	name = "Goldcrest"
	icon_state = "goldcrest"
	icon_living = "goldcrest"
	icon_dead = "goldcrest-dead"

/mob/living/simple_mob/animal/passive/bird/ringneckdove
	name = "Ringneck Dove"
	icon_state = "ringneckdove"
	icon_living = "ringneckdove"
	icon_dead = "ringneckdove-dead"

/mob/living/simple_mob/animal/passive/bird/cockatiel
	name = "Cockatiel"
	icon_state = "tiel-flap"
	icon_living = "tiel-flap"
	icon_dead = "tiel-dead"

/mob/living/simple_mob/animal/passive/bird/white_cockatiel
	name = "White Cockatiel"
	icon_state = "wtiel-flap"
	icon_living = "wtiel-flap"
	icon_dead = "wtiel-dead"

/mob/living/simple_mob/animal/passive/bird/yellowish_cockatiel
	name = "Yellowish Cockatiel"
	icon_state = "luttiel-flap"
	icon_living = "luttiel-flap"
	icon_dead = "luttiel-dead"

/mob/living/simple_mob/animal/passive/bird/grey_cockatiel
	name = "Grey Cockatiel"
	icon_state = "blutiel-flap"
	icon_living = "blutiel-flap"
	icon_dead = "blutiel-dead"

/mob/living/simple_mob/animal/passive/bird/too
	name = "Too"
	icon_state = "too-flap"
	icon_living = "too-flap"
	icon_dead = "too-dead"

/mob/living/simple_mob/animal/passive/bird/hooded_too
	name = "Utoo"
	icon_state = "utoo-flap"
	icon_living = "utoo-flap"
	icon_dead = "utoo-dead"

/mob/living/simple_mob/animal/passive/bird/pink_too
	name = "Mtoo"
	icon_state = "mtoo-flap"
	icon_living = "mtoo-flap"
	icon_dead = "mtoo-dead"
