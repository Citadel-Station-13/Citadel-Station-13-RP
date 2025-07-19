// Large, nigh unstoppable forces of nature that rule over the wildlands. Each encounter with these are likely to be ones last.


/mob/living/simple_mob/animal/monster/bear
	name = "bear"
	desc = "A large and fearsome bear with grey and black fur. \
	Its claws are easily the side of someones arm and its teeth could tear through metal."
	description_info = "Run."

	icon = 'icons/mob/monsters/bear.dmi'
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	base_pixel_x = -16
	base_pixel_y = 0
	icon_scale_x = 1.3
	icon_scale_y = 1.3


	maxHealth = 700
	health = 700
	armor_legacy_mob = list(
			"melee"		= 40,
			"bullet"	= 50,
			"laser"		= 20,
			"energy"	= 20,
			"bomb"		= 70,
			"bio"		= 20,
			"rad"		= 0
			)

	legacy_melee_damage_lower = 40
	legacy_melee_damage_upper = 45
	attack_armor_pen = 20

	movement_base_speed = 10 / 4

	special_attack_min_range = 3
	special_attack_max_range = 7
	special_attack_cooldown = 15 SECONDS
	var/charging = 0
	var/charging_warning = 3 SECONDS
	var/charge_damage_mode = DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP
	var/charge_damage_flag = ARMOR_MELEE
	var/charge_damage = 40

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/destructive
	iff_factions= MOB_IFF_FACTION_MONSTER_BEAR


/mob/living/simple_mob/animal/monster/bear/do_special_attack(atom/A)
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
	do_windup_animation(A, charge_warmup)
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

/mob/living/simple_mob/animal/monster/bear/Bump(atom/movable/AM)
	if(charging)
		visible_message("<span class='warning'>[src] runs [AM]!</span>")
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			M.afflict_stun(20 * 5)
			M.afflict_paralyze(20 * 3)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at_old(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M)
		else if(isobj(AM))
			AM.inflict_atom_damage(charge_damage, charge_damage_flag, charge_damage_mode, src)
	..()

/mob/living/simple_mob/animal/monster/bear/proc/runOver(var/mob/living/M)
	if(istype(M))
		visible_message("<span class='warning'>[src] runs [M] over!</span>")
		playsound(src, "sound/mobs/biomorphs/breaker_charge_hit.ogg", 50, 1)
		// todo: this ignores charge_damage
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, DAMAGE_TYPE_BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, DAMAGE_TYPE_BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_R_ARM)

/mob/living/simple_mob/animal/monster/bear/apply_melee_effects(atom/A)
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
