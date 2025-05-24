/mob/living/simple_mob/animal/space/xenomorph
	iff_factions = MOB_IFF_FACTION_XENOMORPH
	randomized = FALSE
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	taser_kill = 0
	attack_sharp = TRUE
	attack_edge = TRUE
	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat

/mob/living/simple_mob/animal/space/xenomorph/breaker/death()
	..()
	visible_message("[src] emits a high pitched roar as its massive body stills, acidic blood pouring from its remains.")
	playsound(src, 'sound/mobs/biomorphs/breaker_death_hiss.ogg', 100, 1)

/mob/living/simple_mob/animal/space/xenomorph/monarch/death()
	..()
	visible_message("[src] lets out a horrifying screech that echoes throughout your mind, it seems like it's finally over... Or is it?")
	playsound(src, 'sound/mobs/biomorphs/monarch_death_hiss.ogg', 100, 1)

/mob/living/simple_mob/animal/space/xenomorph/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/mobs/biomorphs/xenomorph_death_hiss.ogg', 100, 1)


/mob/living/simple_mob/animal/space/xenomorph/warrior
	name = "xenomorph warrior"
	desc = "A tall beast, dotted with reinforced chitin plates and a pair of razor sharp claws. It looks pretty pissed off."
	icon = 'icons/mob/biomorphs/warrior.dmi'
	icon_state = "warrior_animations"
	icon_living = "warrior_animations"
	icon_dead = "warrior_dead"
	icon_gib = "gibbed-a-small"
	icon_rest = "warrior_sleep"
	maxHealth = 450
	health = 450
	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30
	base_attack_cooldown = 9
	attack_armor_pen = 15
	movement_base_speed = 10 / 3
	base_pixel_x = -8
	base_pixel_y = 1
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	attack_sound = 'sound/mobs/biomorphs/warrior_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/warrior_move.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_xenomorph/warrior)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

/mob/living/simple_mob/animal/space/xenomorph/drone
	name = "xenomorph drone"
	icon = 'icons/mob/biomorphs/drone.dmi'
	desc = "A creature that stands a bit taller than the average person. Its body is dotted in some sort of odd chitin, moving with some sort of unknown purpose..."
	icon_state = "drone_animations"
	icon_living = "drone_animations"
	icon_dead = "drone_dead"
	icon_rest = "drone_sleep"
	icon_gib = "gibbed-a-small"
	gib_on_butchery = "gibbed-a-small-corpse"
	maxHealth = 150
	health = 150
	base_pixel_x = -8
	movement_base_speed = 10 / 0.5
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	base_attack_cooldown = 6
	attack_sound =  'sound/mobs/biomorphs/drone_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/drone_move.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_xenomorph/drone)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

/mob/living/simple_mob/animal/space/xenomorph/sprinter
	name = "xenomorph sprinter"
	icon = 'icons/mob/biomorphs/sprinter.dmi'
	desc = "A small dog-like creature which never seems to stay still. Its speed is frightening, but otherwise it doesn't look like it could take too many hits."
	icon_state = "sprinter_animation"
	icon_living = "sprinter_animation"
	icon_dead = "sprinter_dead"
	icon_rest = "sprinter_rest"
	maxHealth = 130
	health = 130
	base_pixel_x = -15
	movement_base_speed = 6.66
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 15
	base_attack_cooldown = 4
	attack_sound =  'sound/mobs/biomorphs/drone_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/drone_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/hunter_spider
	special_attack_min_range = 2
	special_attack_max_range = 5
	special_attack_cooldown = 10 SECONDS
	var/leap_warmup = 0.5 SECOND // How long the leap telegraphing is.


/mob/living/simple_mob/animal/space/xenomorph/neurotoxin_spitter
	name = "xenomorph spitter"
	icon = 'icons/mob/biomorphs/spitter.dmi'
	desc = "A lithe and unarmored creature, its crest and chest cavity seems to be filled with a bubbling substance."
	icon_state = "basic_spitter_walk"
	icon_living = "basic_spitter_walk"
	icon_dead = "basic_spitter_dead"
	icon_rest = "basic_spitter_sleep"
	icon_gib = "gibbed-a-small"
	gib_on_butchery = "gibbed-a-small-corpse"
	maxHealth = 200
	health = 200
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	base_pixel_x = -8
	movement_base_speed = 10 / 3
	projectiletype = /obj/projectile/energy/neurotoxin
	base_attack_cooldown = 9
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound =  'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_xenomorph/spitter)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting

/mob/living/simple_mob/animal/space/xenomorph/acid_spitter
	name = "advanced xenomorph spitter"
	icon = 'icons/mob/biomorphs/spitter.dmi'
	desc = "A large beast, standing well above the average person. Its body is overflowing with a sizzling substance, a large amount dripping from its mouth. Doesn't help that it's covered in armor, too."
	icon_state = "advanced_spitter_walk"
	icon_living = "advanced_spitter_walk"
	icon_dead = "advanced_spitter_dead"
	icon_rest = "advanced_spitter_sleep"
	icon_gib = "gibbed-a-small"
	gib_on_butchery = "gibbed-a-small-corpse"
	maxHealth = 250
	health = 250
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	movement_base_speed = 10 / 2
	base_pixel_x = -8
	base_pixel_y = 1
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	projectiletype = /obj/projectile/energy/acid
	base_attack_cooldown = 12
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_xenomorph/spitter)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting

/mob/living/simple_mob/animal/space/xenomorph/breaker
	name = "xenomorph line breaker"
	icon = 'icons/mob/biomorphs/breaker.dmi'
	desc = "Whatever this is, it resembles more of a truck than any kind of beat you've ever seen. Its crest is large and armored, and its four legs could easily crush anything in its way. Better stay away..."
	icon_living = "breaker_animations"
	icon_state = "breaker_animations"
	icon_dead = "breaker_dead"
	icon_rest = "breaker_sleep"
	icon_gib = "gibbed-a"
	gib_on_butchery = "gibbed-a-corpse"
	health = 800
	maxHealth = 800
	armor_legacy_mob = list(
		"melee" = 50,
		"bullet" = 20,
		"laser" = 30,
		"energy" = 30,
		"bomb" = 15,
		"bio" = 100,
		"rad" = 100,
	)
	legacy_melee_damage_lower = 50
	legacy_melee_damage_upper = 50
	movement_base_speed = 10 / 2
	base_pixel_x = -17
	base_pixel_y = 6
	icon_scale_x = 1.3
	icon_scale_y = 1.3
	attack_sound =  'sound/mobs/biomorphs/breaker_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
	melee_attack_delay = 4
	attack_armor_pen = 40
	special_attack_min_range = 1
	special_attack_max_range = 12 //Normal view range is 7 this can begin charging from outside normal view You may expand it.
	special_attack_cooldown = 10 SECONDS
	var/charging = 0
	var/charging_warning = 1 SECONDS
	var/charge_damage_mode = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP ///You may want to change this
	var/charge_damage_flag = ARMOR_MELEE
	var/charge_damage_tier = 4.5
	var/charge_damage = 60
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/destructive //temporary until we get proper AI for xenomorphs.//

/mob/living/simple_mob/animal/space/xenomorph/berserker
	name = "xenomorph berserker"
	icon = 'icons/mob/biomorphs/berserker.dmi'
	desc = "A hulking red beast with scythes the size of a person. Its hide looks tough and burn proof, it also seems EXCEPTIONALLY pissed off at you."
	icon_state = "berserker_run"
	icon_living = "berserker_run"
	icon_dead = "berserker_dead"
	icon_rest = "berserker_rest"
	health = 600
	maxHealth = 600
	armor_legacy_mob = list(
		"melee" = 40,
		"bullet" = 50,
		"laser" = 30,
		"energy" = 20,
		"bomb" = 0,
		"bio" = 100,
		"rad" = 100,
	)
	legacy_melee_damage_lower = 40
	legacy_melee_damage_upper = 40
	attack_armor_type = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP
	attack_armor_pen = 30
	movement_base_speed = 10 / 2
	base_pixel_x = -16
	base_pixel_y = 2
	icon_scale_x = 1.2
	icon_scale_y = 1.2
	attack_sound = 'sound/mobs/biomorphs/warrior_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

/mob/living/simple_mob/animal/space/xenomorph/vanguard
	name = "xenomorph vanguard"
	icon = 'icons/mob/biomorphs/vanguard.dmi'
	desc = "The Vanguards are a fearsome sight, often spelling doom for many a person. Serving as the Queens personal body-guard, the presence of one usually means the Hives Queen is not far behind. Bristling in armor and standing at a height that would rival even the tallest of Exosuits, they're fit with razor sharp claws and often use their tails to disable or entirely pierce whatever threats the Queen. While they're not as tough as a Breaker, they can certanly deal enough damage to disuade anyone from approaching."
	icon_state = "vanguard_run"
	icon_living = "vanguard_run"
	icon_dead = "vanguard_dead"
	icon_rest = "vanguard_sleep"
	icon_gib = "gibbed-a"
	gib_on_butchery = "gibbed-a-corpse"
	health = 600
	maxHealth = 600
	armor_legacy_mob = list(
		"melee" = 20,
		"bullet" = 50,
		"laser" = 50,
		"energy" = 45,
		"bomb" = 0,
		"bio" = 100,
		"rad" = 100,
	)
	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30
	attack_armor_type = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP
	movement_base_speed = 10 / 3
	base_pixel_x = -18
	base_pixel_y = 2
	icon_scale_x = 1.2
	icon_scale_y = 1.2
	attack_sound =  'sound/mobs/biomorphs/vanguard_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/vanguard_move.ogg'
	projectiletype = /obj/projectile/energy/acid
	projectilesound = 'sound/effects/splat.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_xenomorph/vanguard)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/aggressive/priest

/mob/living/simple_mob/animal/space/xenomorph/monarch
	name = "xenomorph monarch"
	icon = 'icons/mob/biomorphs/monarch.dmi'
	desc = "The perfect organism, and the pinnacle of a Xenomorphs evolution. Monarchs are capable of leading an entire Hive filled with sometimes tens of thousands of Xenomorphs, all linked and under the control of her psychic whim. Usually closely protected by a slew of Vanguards, the Monarch herself is nonetheless capable of putting down any who threaten her. Attempting to kill her without adequate equipment is a death warrant."
	icon_state = "monarch_run"
	icon_living = "monarch_run"
	icon_dead = "monarch_dead"
	icon_rest = "monarch_sleep"
	icon_gib = "gibbed-a"
	gib_on_butchery = "gibbed-a-corpse"
	health = 1500
	maxHealth = 1500
	armor_legacy_mob = list(
		"melee" = 60,
		"bullet" = 50,
		"laser" = 80,
		"energy" = 80,
		"bomb" = 20,
		"bio" = 100,
		"rad" = 100,
	)
	legacy_melee_damage_lower = 70
	legacy_melee_damage_upper = 50
	attack_armor_pen = 60
	movement_base_speed = 10 / 4
	base_pixel_x = -15
	base_pixel_y = 6
	icon_scale_x = 1.5
	icon_scale_y = 1.5
	attack_sound =  'sound/mobs/biomorphs/monarch_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/monarch_move.ogg'
	melee_attack_delay = 4
	projectiletype = /obj/projectile/energy/acid
	projectilesound = 'sound/effects/splat.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/aggressive/priest
	special_attack_min_range = 1
	special_attack_max_range = 12 //Normal view range is 7 this can begin charging from outside normal view You may expand it.
	special_attack_cooldown = 15 SECONDS
	var/charging = 0
	var/charging_warning = 0 SECONDS
	var/charge_damage_mode = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP ///You may want to change this
	var/charge_damage_flag = ARMOR_MELEE
	var/charge_damage_tier = 4.5
	var/charge_damage = 60
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/aggressive/priest

/mob/living/simple_mob/animal/space/xenomorph/special/burrower
	name = "xenomorph burrower"
	icon = 'icons/mob/biomorphs/burrower.dmi'
	desc = "A utter abomination which appears to be some sort of mesh between a spider and a Xenomorph."
	icon_state = "burrow_walk"
	icon_living = "burrow_walk"
	icon_dead = "burrow_dead"
	icon_rest = "burrow_sleep"
	maxHealth = 300
	health = 300
	legacy_melee_damage_lower = 35
	legacy_melee_damage_upper = 40
	movement_base_speed = 6.66
	icon_scale_x = 0.7
	icon_scale_y = 0.7
	base_pixel_x = -16
	base_pixel_y = -5
	attack_sound =  'sound/weapons/bite.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/tunneler
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS
	var/tunnel_warning = 0.5 SECONDS	// How long the dig telegraphing is.
	var/tunnel_tile_speed = 2			// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.

/mob/living/simple_mob/animal/space/xenomorph/special/marksman
	name = "xenomorph marksman"
	icon = 'icons/mob/biomorphs/marksman.dmi'
	desc = "A hulking beast which doesn't resemble any type of Xenomorph you've ever seen. It looks sloppily done, genetic strands grafted onto eachother, but it seems like it can lob acid pretty far."
	icon_state = "marksman_walk"
	icon_living = "marksman_walk"
	icon_dead = "marksman_dead"
	icon_rest = "marksman_sleep"
	icon_gib = "gibbed-a"
	gib_on_butchery = "gibbed-a"
	maxHealth = 250
	health = 250
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	movement_base_speed = 10 / 4
	base_pixel_x = -8
	base_pixel_y = 1
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	projectiletype = /obj/projectile/energy/acid
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_xenomorph/spitter)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/sniper

/mob/living/simple_mob/animal/space/xenomorph/special/burster
	name = "xenomorph burster"
	icon = 'icons/mob/biomorphs/burster.dmi'
	desc = "A peculiar floating amalgamation of different chitin, acid and flesh. It looks like it could burst at any moment! Better stay away."
	icon_state = "burster_run"
	icon_living = "burster_run"
	icon_dead = "burster_dead"
	icon_rest = "burster_rest"
	maxHealth = 200
	health = 200
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 15
	movement_base_speed = 10 / 3
	base_pixel_x = -16
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee
	var/exploded = FALSE
	var/explosion_dev_range		= 1
	var/explosion_heavy_range	= 2
	var/explosion_light_range	= 4
	var/explosion_flash_range	= 6
	var/explosion_delay_lower	= 1 SECOND
	var/explosion_delay_upper	= 2 SECONDS

/mob/living/simple_mob/animal/space/xenomorph/special/inferno
	name = "xenomorph inferno"
	icon = 'icons/mob/biomorphs/inferno.dmi'
	desc = "It's hard to believe this... Thing is real. Its body squirms and writhes with a dedicated purpose, blue flame bursting from every orfice on its body, giving it an intimidating glow."
	icon_state = "inferno_run"
	icon_living = "inferno_run"
	icon_dead = "inferno_dead"
	icon_rest = "inferno_stun"
	maxHealth = 300
	health = 300
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	movement_base_speed = 10 / 3
	base_pixel_x = -16
	base_pixel_y = -3
	icon_scale_x = 0.9
	icon_scale_y = 0.9
	projectiletype = /obj/projectile/potent_fire
	base_attack_cooldown = 10
	projectilesound = 'sound/items/Welder.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting

