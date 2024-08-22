/datum/category_item/catalogue/fauna/feral_alien
	name = "Feral Xenomorph"
	desc = "Xenomorphs are a widely recognized and rightfully feared scourge \
	across the Frontier. Some Xenomorph hives lose a connection to the greater \
	Hive structure, and become less coordinated, though no less dangerous. \
	Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/feral_alien)

// Obtained by scanning all Aliens.
/datum/category_item/catalogue/fauna/all_feral_aliens
	name = "Collection - Feral Xenomorphs"
	desc = "You have scanned a large array of different types of Xenomorph, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_SUPERHARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/feral_alien/warrior,
		/datum/category_item/catalogue/fauna/feral_alien/drone,
		/datum/category_item/catalogue/fauna/feral_alien/spitter,
		/datum/category_item/catalogue/fauna/feral_alien/monarch,
		)

/datum/category_item/catalogue/fauna/feral_alien/warrior
	name = "Feral Xenomorph - Warrior"
	desc = "Warriors serve as the primary combat caste within a Hive Structure, while having fewer numbers than the endless drone hordes, they are none-the-less extremely formidable. "
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/space/alien/warrior
	name = "xenomorph warrior"
	desc = "A feral Xenomorph that plays the part of the Hive Structures main fighter. Standing at an even larger stance than a drone, its exoskeleton is fully militarized, intended to take hits from both melee and ranged alike. Its claws can easily tear through armor and flesh, while its acid does the rest."
	icon = 'icons/mob/biomorphs/warrior.dmi'
	icon_state = "warrior_animations"
	icon_living = "warrior_animations"
	icon_dead = "warrior_dead"
	icon_gib = "syndicate_gib"
	icon_rest = "warrior_sleep"
	movement_cooldown = 2
	base_pixel_x = -8
	base_pixel_y = 1
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/warrior)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

	faction = "xeno"

	mob_class = MOB_CLASS_ABERRATION

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	maxHealth = 450
	health = 450
	randomized = FALSE

	harm_intent_damage = 5
	legacy_melee_damage_lower = 35
	legacy_melee_damage_upper = 35
	attack_sharp = TRUE
	attack_edge = TRUE
	taser_kill = 0

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	hide_amount = 2
	hide_type = /obj/item/stack/xenochitin

/datum/category_item/catalogue/fauna/feral_alien/drone
	name = "Feral Xenomorph - Drone"
	desc = "The adult form of the Xenomorph, the drone's iconic \
	morphology and biological traits make it easily identifiable across \
	the Frontier. Feared for its prowess, the Drone is a sign that an even \
	larger threat is present: a Xenomorph Hive. When their connection to the \
	Hive has been disrupted, Drones exhibit less construction activity and \
	revert to a defensive Kill on sight."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/alien/drone
	name = "xenomorph drone"
	icon = 'icons/mob/biomorphs/drone.dmi'
	desc = "A feral Xenomorphic Drone that acts as as a building block for the dedicated Hive Structure. Despite the fact it can very well defend itself and its sisters with pairs of razor sharp claws and a bladed tail along with a reinforced chitinous exoskeleton, they are commonly seen tending to the numerous halls of Resin and tending to the Queens eggs."
	icon_state = "drone_animations"
	icon_living = "drone_animations"
	icon_dead = "drone_dead"
	icon_rest = "drone_sleep"
	maxHealth = 150
	health = 150
	base_pixel_x = -8
	movement_cooldown = -0.2
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	faction = "xeno"
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/drone)
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

/datum/category_item/catalogue/fauna/feral_alien/spitter
	name = "Feral Xenomorph - Spitter"
	desc = "Spitters serve as defensive units for the Hive. Possessing \
	a powerful neurotoxic venom, Spitters are able to spit this toxin at \
	range with alarming accuracy and control. Designed to repel assaults, \
	the Spitter serves the dual purpose of weakening aggressors so they may \
	be more easily collected to host future generations. When disconnected \
	from the Hive, Spitter behavior remains almost exactly the same. Kill \
	on sight."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/space/alien/basic_spitter
	name = "xenomorph spitter"
	icon = 'icons/mob/biomorphs/spitter.dmi'
	desc = "The feral Spitter often uses its minorly developed acidic sacs to spray high velocity acid or neurotoxin at its victims, depending on if the Hive Structure requires new hosts. Fortunately, this Spitter seems to only be a youthful version, rather than a much more developed advanced version."
	icon_state = "basic_spitter_walk"
	icon_living = "basic_spitter_walk"
	icon_dead = "basic_spitter_dead"
	icon_rest = "basic_spitter_sleep"
	maxHealth = 200
	health = 200
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	faction = "xeno"
	base_pixel_x = -8
	movement_cooldown = 3
	projectiletype = /obj/projectile/energy/neurotoxin
	projectilesound = 'sound/effects/splat.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/spitter)
	ai_holder_type = /datum/ai_holder/polaris/hostile/ranged/robust/on_engagement

/mob/living/simple_mob/animal/space/alien/adv_spitter
	name = "advanced xenomorph spitter"
	icon = 'icons/mob/biomorphs/spitter.dmi'
	desc = "It didn't take long for the Hive Structure to evolve a improved version of the basic Spitter caste to fulfill its military requirements. The advanced Spitter is terrifying to meet on the battlefield, standing at the height of the common warrior and lobbing incessant, armor, flesh and metal melting blobs of unfiltered acid at whatever the Hive deems a threat."
	icon_state = "advanced_spitter_walk"
	icon_living = "advanced_spitter_walk"
	icon_dead = "advanced_spitter_dead"
	icon_rest = "advanced_spitter_sleep"
	maxHealth = 350
	health = 350
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	faction = "xeno"
	movement_cooldown = 4
	base_pixel_x = -8
	base_pixel_y = 1
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	projectiletype = /obj/projectile/energy/acid
	projectilesound = 'sound/effects/splat.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/spitter)
	ai_holder_type = /datum/ai_holder/polaris/hostile/ranged/robust/on_engagement

/mob/living/simple_mob/animal/space/alien/breaker
	name = "xenomorph line breaker"
	icon = 'icons/mob/biomorphs/breaker.dmi'
	desc = "Line Breakers, as the name implies are a spearhead caste meant to charge through enemy lines so the smaller and weaker castes can follow. They are heavy armor, and thus can contend with even the most premier exosuits and have been known to shrug off even anti tank weaponry. Seeing one and living to tell the tale is a rarity."
	icon_state = "breaker_animations"
	icon_living = "breaker_animations"
	icon_dead = "breaker_dead"
	icon_rest = "breaker_sleep"
	health = 800
	maxHealth = 800
	armor_legacy_mob = list(
		"melee" = 50,
		"bullet" = 20,
		"laser" = 20,
		"energy" = 10,
		"bomb" = 15,
		"bio" = 100,
		"rad" = 100,
	)
	legacy_melee_damage_lower = 50
	legacy_melee_damage_upper = 50
	faction = "xeno"
	movement_cooldown = 2
	base_pixel_x = -17
	base_pixel_y = 6
	icon_scale_x = 1.3
	icon_scale_y = 1.3
	attack_sound =  'sound/mobs/biomorphs/breaker_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
	melee_attack_delay = 4
	special_attack_min_range = 3
	special_attack_max_range = 12 //Normal view range is 7 this can begin charging from outside normal view You may expand it.
	special_attack_cooldown = 10 SECONDS
	var/charging = 0
	var/charging_warning = 1 SECONDS
	var/charge_damage_mode = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP ///You may want to change this
	var/charge_damage_flag = ARMOR_MELEE
	var/charge_damage_tier = MELEE_TIER_HEAVY
	var/charge_damage = 60
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/destructive //temporary until we get proper AI for xenomorphs.//

/mob/living/simple_mob/animal/space/alien/breaker/update_icon()
	if(charging)
		icon_state = "'breaker_charge'-charge"
	..()

/mob/living/simple_mob/animal/space/alien/breaker/do_special_attack(atom/A)
	var/charge_warmup = 1 SECOND // How long the leap telegraphing is.
	var/charge_sound = 'sound/mobs/biomorphs/breaker_charge.ogg'
	set waitfor = FALSE
	set_AI_busy(TRUE)
	charging = 1
	movement_shake_radius = 5
	movement_sound = 'sound/mobs/biomorphs/breaker_charge.ogg'
	visible_message("<span class='warning'>\The [src] prepares to charge at \the [A]!</span>")
	sleep(charging_warning)
	playsound(src, charge_sound, 75, 1)
	do_windup_animation(A, charge_warmup) ///This was stolen from the Hunter Spiders means you can see them prepare to charge
	sleep(charge_warmup)
	update_icon()
	var/chargeturf = get_turf(A)
	if(!chargeturf)
		return
	var/chargedir = get_dir(src, chargeturf)
	setDir(chargedir)
	var/turf/T = get_ranged_target_turf(chargeturf, chargedir, IS_DIAGONAL(chargedir) ? 1 : 2)
	if(!T)
		charging = 0
		movement_shake_radius = null
		movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
		update_icon()
		visible_message("<span class='warning'>\The [src] desists from charging at \the [A]</span>")
		return
	for(var/distance = get_dist(src.loc, T), src.loc!=T && distance>0, distance--)
		var/movedir = get_dir(src.loc, T)
		var/moveturf = get_step(src.loc, movedir)
		SelfMove(moveturf, movedir, 2)
		sleep(2 * world.tick_lag) //Speed it will move, default is two server ticks. You may want to slow it down a lot.
	sleep((get_dist(src, T) * 2.2))
	charging = 0
	update_icon()
	movement_shake_radius = 0
	movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
	set_AI_busy(FALSE)

/mob/living/simple_mob/animal/space/alien/breaker/Bump(atom/movable/AM)
	if(charging)
		visible_message("<span class='warning'>[src] runs [AM]!</span>")
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			M.afflict_stun(20 * 5)
			M.afflict_paralyze(20 * 3)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at_old(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M) // Actually should not use this, placeholder
		else if(isobj(AM))
			AM.inflict_atom_damage(charge_damage, charge_damage_tier, charge_damage_flag, charge_damage_mode, ATTACK_TYPE_UNARMED, src)
	..()

/mob/living/simple_mob/animal/space/alien/breaker/proc/runOver(var/mob/living/M)
	if(istype(M))
		visible_message("<span class='warning'>[src] runs [M] over!</span>")
		playsound(src, "sound/mobs/biomorphs/breaker_charge_hit.ogg", 50, 1)
		// todo: this ignores charge_damage
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_ARM)
		blood_splatter(src, M, 1)

/mob/living/simple_mob/animal/space/alien/breaker/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their heavy claws!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))


/datum/category_item/catalogue/fauna/feral_alien/sentinel/vanguard
	name = "Feral Xenomorph - Praetorian"
	desc = "The Xenomorph Vanguard is not often seen amongst \
	standard Xeno incursions. Spawned in large Hives to serve as \
	bodyguards to a Monarch, the Vanguard clade are powerful, and \
	nightmarishly effective in close combat. Spotting a Vanguard in \
	the field is often grounds to call for an immediate withdrawal and \
	orbital bombardment. On the rare occasions where Vanguard are \
	cut off from the greater Hive, they remain formidable foes and will \
	die to protect their Monarch. Kill on sight."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/space/alien/vanguard
	name = "xenomorph vanguard"
	icon = 'icons/mob/biomorphs/vanguard.dmi'
	desc = "The Vanguards are a fearsome sight, often spelling doom for many a person. Serving as the Queens personal body-guard, the presence of one usually means the Hives Queen is not far behind. Bristling in armor and standing at a height that would rival even the tallest of Exosuits, they're fit with razor sharp claws and often use their tails to disable or entirely pierce whatever threats the Queen. While they're not as tough as a Breaker, they can certanly deal enough damage to disuade anyone from approaching."
	icon_state = "vanguard_run"
	icon_living = "vanguard_run"
	icon_dead = "vanguard_dead"
	icon_rest = "vanguard_sleep"
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
	legacy_melee_damage_lower = 40
	legacy_melee_damage_upper = 40
	attack_armor_type = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP
	faction = "xeno"
	movement_cooldown = 3
	base_pixel_x = -18
	base_pixel_y = 2
	icon_scale_x = 1.2
	icon_scale_y = 1.2
	attack_sound =  'sound/mobs/biomorphs/vanguard_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/vanguard_move.ogg'
	projectiletype = /obj/projectile/energy/acid
	projectilesound = 'sound/effects/splat.ogg'
	/datum/ai_holder/polaris/simple_mob/ranged/aggressive

/datum/category_item/catalogue/fauna/feral_alien/monarch
	name = "Feral Xenomorph - Monarch"
	desc = "When a Drone reaches a certain level of maturity, she may \
	evolve into a Monarch, if there is no functioning Hive nearby. The Monarch \
	is erroneously considered the ultimate end point of Xenomorph evolution. \
	The Monarch is responsible for laying eggs, which will spawn more Facehuggers, \
	and therefore eventually more Xenomorphs. As such, she bears a significant \
	strategic value to the Hive, and will be defended ferociously. Monarchs are \
	imbued with substantial psionic power which lets them direct their Hive, but \
	when they are cut off from the larger Xenomorph Hivemind, they may experience \
	a form of shock which reverts them into a Drone's mindstate. Kill on sight. "
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/animal/space/alien/monarch
	name = "xenomorph monarch"
	icon = 'icons/mob/biomorphs/monarch.dmi'
	desc = "The perfect organism, and the pinnacle of a Xenomorphs evolution. Monarchs are capable of leading an entire Hive filled with sometimes tens of thousands of Xenomorphs, all linked and under the control of her psychic whim. Usually closely protected by a slew of Vanguards, the Monarch herself is nonetheless capable of putting down any who threaten her. Attempting to kill her without adequate equipment is a death warrant."
	icon_state = "monarch_run"
	icon_living = "monarch_run"
	icon_dead = "monarch_dead"
	icon_rest = "monarch_sleep"
	health = 1500
	maxHealth = 1500
	armor_legacy_mob = list(
		"melee" = 50,
		"bullet" = 50,
		"laser" = 60,
		"energy" = 70,
		"bomb" = 20,
		"bio" = 100,
		"rad" = 100,
	)
	legacy_melee_damage_lower = 70
	legacy_melee_damage_upper = 50
	faction = "xeno"
	movement_cooldown = 4
	base_pixel_x = -15
	base_pixel_y = 6
	icon_scale_x = 1.5
	icon_scale_y = 1.5
	attack_sound =  'sound/mobs/biomorphs/monarch_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/monarch_move.ogg'
	melee_attack_delay = 4
	/datum/ai_holder/polaris/simple_mob/ranged/aggressive
	special_attack_min_range = 3
	special_attack_max_range = 12 //Normal view range is 7 this can begin charging from outside normal view You may expand it.
	special_attack_cooldown = 15 SECONDS
	var/charging = 0
	var/charging_warning = 0 SECONDS
	var/charge_damage_mode = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP ///You may want to change this
	var/charge_damage_flag = ARMOR_MELEE
	var/charge_damage_tier = MELEE_TIER_HEAVY
	var/charge_damage = 80
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/aggressive/priest

/mob/living/simple_mob/animal/space/alien/breaker/update_icon()
	if(charging)
		icon_state = "monarch_charge-charge"
	..()

/mob/living/simple_mob/animal/space/alien/monarch/do_special_attack(atom/A)
	var/charge_warmup = 0 SECOND // How long the leap telegraphing is.
	var/charge_sound = 'sound/mobs/biomorphs/monarch_charge.ogg'
	set waitfor = FALSE
	set_AI_busy(TRUE)
	charging = 1
	movement_shake_radius = 5
	movement_sound = 'sound/mobs/biomorphs/monarch_charge.ogg'
	visible_message("<span class='warning'>\The [src] prepares to charge at \the [A]!</span>")
	sleep(charging_warning)
	playsound(src, charge_sound, 75, 1)
	do_windup_animation(A, charge_warmup) ///This was stolen from the Hunter Spiders means you can see them prepare to charge
	sleep(charge_warmup)
	update_icon()
	var/chargeturf = get_turf(A)
	if(!chargeturf)
		return
	var/chargedir = get_dir(src, chargeturf)
	setDir(chargedir)
	var/turf/T = get_ranged_target_turf(chargeturf, chargedir, IS_DIAGONAL(chargedir) ? 1 : 2)
	if(!T)
		charging = 0
		movement_shake_radius = null
		movement_sound = 'sound/mobs/biomorphs/monarch_move.ogg'
		update_icon()
		visible_message("<span class='warning'>\The [src] desists from charging at \the [A]</span>")
		return
	for(var/distance = get_dist(src.loc, T), src.loc!=T && distance>0, distance--)
		var/movedir = get_dir(src.loc, T)
		var/moveturf = get_step(src.loc, movedir)
		SelfMove(moveturf, movedir, 2)
		sleep(2 * world.tick_lag) //Speed it will move, default is two server ticks. You may want to slow it down a lot.
	sleep((get_dist(src, T) * 2.2))
	charging = 0
	update_icon()
	movement_shake_radius = 0
	movement_sound = 'sound/mobs/biomorphs/monarch_move.ogg'
	set_AI_busy(FALSE)

/mob/living/simple_mob/animal/space/alien/monarch/Bump(atom/movable/AM)
	if(charging)
		visible_message("<span class='warning'>[src] runs [AM]!</span>")
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			M.afflict_stun(20 * 5)
			M.afflict_paralyze(20 * 3)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at_old(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M) // Actually should not use this, placeholder
		else if(isobj(AM))
			AM.inflict_atom_damage(charge_damage, charge_damage_tier, charge_damage_flag, charge_damage_mode, ATTACK_TYPE_UNARMED, src)
	..()

/mob/living/simple_mob/animal/space/alien/monarch/proc/runOver(var/mob/living/M)
	if(istype(M))
		visible_message("<span class='warning'>[src] runs [M] over!</span>")
		playsound(src, "sound/mobs/biomorphs/monarch_charge.ogg", 50, 1)
		// todo: this ignores charge_damage
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_ARM)
		blood_splatter(src, M, 1)

/mob/living/simple_mob/animal/space/alien/monarch/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their heavy claws!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))

/mob/living/simple_mob/animal/space/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)
