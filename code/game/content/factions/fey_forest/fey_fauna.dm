/mob/living/simple_mob/animal/event/fey/crawler
	name = "crawler"
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_fauna.dmi'
	desc = "A spider-like creature that moves on an excessive amount of legs. Its flesh constantly crawls and shifts erratically, like its body can't decide on what form it wants."
	icon_living = "ambusher"
	icon_state = "ambusher"
	maxHealth = 150
	health = 150
	movement_cooldown = 3
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 15
	base_attack_cooldown = 10
	attack_sound = 'sound/mobs/biomorphs/drone_attack.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

/mob/living/simple_mob/animal/event/fey/leaper
	name = "leaper"
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_fauna.dmi'
	desc = "You can't quite tell what this is, considering the fact it looks more like a mouth with legs sloppily strapped onto it... Its flesh constantly shifts and wriggles around erratically. Ew."
	icon_living = "wriggler"
	icon_state = "wriggler"
	maxHealth = 150
	health = 150
	movement_cooldown = 3
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	base_attack_cooldown = 10
	attack_sound = 'sound/mobs/biomorphs/drone_attack.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

/mob/living/simple_mob/animal/event/fey/chameleon
	name = "chameleon"
	icon = 'code/game/content/factions/fey_forest/fey_forest.dmi/fey_fauna.dmi'
	desc = "Its skin looks... Translucent, yet its flesh crawls around like it wants to leave its body."
	icon_living = "chameleon"
	icon_state = "chameleon"
	maxHealth = 100
	health = 100
	alpha = 150
	movement_cooldown = 3
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	base_attack_cooldown = 10
	attack_sound = 'sound/mobs/biomorphs/drone_attack.ogg'
	projectiletype = /obj/projectile/energy/neurotoxin
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/threatening
