/mob/living/simple_mob/animal/passive/bird/azure_tit/tweeter
	name = "Tweeter"
	desc = "A beautiful little blue and white bird, if only excessively loud for no reason sometimes."
	makes_dirt = FALSE
//Unrandom the Pet
/mob/living/simple_mob/animal/passive/bird/azure_tit/tweeter/Initialize()
    . = ..()
    size_multiplier = 1
    maxHealth = maxHealth
    health = health
    melee_damage_lower = melee_damage_lower
    melee_damage_upper = melee_damage_upper
    movement_cooldown = movement_cooldown
    meat_amount = meat_amount
    update_icons()
