/mob/living/simple_mob/animal/horing
	name = "Horing"
	desc = "An intimidatingly large white-furred creature with a single massive horn on its forehead."
	tt_desc = "Dominus Albus"
	icon = 'icons/mob/muriki64x64.dmi'
	icon_state = "thrumbo"
	icon_living = "thrumbo"
	icon_dead = "thrumbo_dead"
	icon_rest = "thrumbo_rest"
	maxHealth = 500
	health = 500
	faction = "horing"
	pixel_x = -16
	special_attack_min_range = 3
	special_attack_max_range = 8
	special_attack_cooldown = 10 SECONDS
	var/charging = 0
	var/charging_warning = 1 SECONDS
	minbodytemp = 0
	min_oxy = 0
	attack_sharp = 1
	melee_damage_lower = 30
	melee_damage_upper = 50
	attack_armor_pen = 30 //That huge horn cleaves through armor.
	attack_sharp = TRUE //It is a pretty sharp horn.
	attack_edge = TRUE
	meat_amount = 20
	meat_type = /obj/item/reagent_containers/food/snacks/horsemeat
	butchery_loot = list(/obj/item/stack/animalhide = 6)

	ai_holder_type = /datum/ai_holder/simple_mob/horing

/mob/living/simple_mob/animal/horing/update_icon()
	if(charging)
		icon_state = "[icon_living]-charge"
	..()
 //TODO - Sprites for the charge

/datum/category_item/catalogue/fauna/horing
	name = "Horing"
	desc = "Horing are a form of life endemic to Lythios 43c. Somewhat rare, it is theorized \
	that Horing were originally pack animals not dissimilar to Terran ungulates. Tall and muscular, Horing \
	are covered in a dense white wool. Most noticeably, Horing possess an incredibly hard horn not dissimilar to a glaive. \
	Capable of cutting clean through a human being, these vicious protrusions are most commonly used in a defensive capacity. \
	Horing are not generally aggressive, and may sometimes be domesticated for their wool. Their territorial nature can \
	sometimes lead to hostilities if the stock lack adequate space. Unfortunately, their horns are valuable on the black market, \
	making Horing a common target for poachers."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/horing/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)
	charging = 1
	movement_shake_radius = 3
	movement_sound = 'sound/effects/mob_effects/snowbull_charge.ogg'
	visible_message("<span class='warning'>\The [src] prepares to charge at \the [A]!</span>")
	update_icon()
	sleep(charging_warning)
	var/chargeturf = get_turf(A)
	if(!chargeturf)
		return
	var/chargedir = get_dir(src, chargeturf)
	setDir(chargedir)
	var/turf/T = get_ranged_target_turf(chargeturf, chargedir, IS_DIAGONAL(chargedir) ? 1 : 2)
	if(!T)
		charging = 0
		movement_shake_radius = null
		movement_sound = null
		update_icon()
		visible_message("<span class='warning'>\The [src] desists from charging at \the [A]</span>")
		return
	for(var/distance = get_dist(src.loc, T), src.loc!=T && distance>0, distance--)
		var/movedir = get_dir(src.loc, T)
		var/moveturf = get_step(src.loc, movedir)
		SelfMove(moveturf, movedir, 2)
		sleep(2 * world.tick_lag) //Speed it will move, default is two server ticks
	sleep((get_dist(src, T) * 2.2))
	charging = 0
	update_icon()
	movement_shake_radius = 0
	movement_sound = null
	set_AI_busy(FALSE)

/mob/living/simple_mob/animal/horing/Bump(atom/movable/AM)
	if(charging)
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			visible_message("<span class='warning'>[src] rams [AM]!</span>")
			M.Stun(5)
			M.Weaken(3)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at_old(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M) // Actually should not use this, placeholder
		if(istype(AM, /obj/structure))
			if(istype(AM, /obj/structure/window))
				var/obj/structure/window/window = AM
				window.hit(80) //Shatters reinforced windows
			else if(istype(AM, /obj/structure/table))
				var/obj/structure/table/table = AM
				var/tableflipdir = pick(turn(dir, 90), turn(dir, -90))
				if(!table.flip(tableflipdir)) //If table don't gets flipped just generic attack it
					AM.attack_generic(src, 20, "rams")
			else if(istype(AM, /obj/structure/closet))
				var/obj/structure/closet/closet = AM
				closet.throw_at_random(0, 2, 2)
				closet.break_open() //Lets not destroy closets that easily, instead just open it
			else
				AM.attack_generic(src, 20, "rams") // Otherwise just attack_generic that structure
		if(istype(AM, /turf/simulated/wall))
			var/turf/simulated/wall/wall = AM
			wall.take_damage(20)
		if(istype(AM, /obj/machinery))
			var/obj/machinery/machinery = AM
			machinery.attack_generic(src, 20)
	..()

/mob/living/simple_mob/animal/horing/proc/runOver(var/mob/living/M)
	if(istype(M))
		visible_message("<span class='warning'>[src] rams [M] over!</span>")
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, BRUTE, BP_R_ARM)
		blood_splatter(src, M, 1)

/mob/living/simple_mob/animal/horing/handle_special()
	if(ai_holder)
		if(istype(ai_holder, /datum/ai_holder/simple_mob/horing))
			var/datum/ai_holder/simple_mob/horing/changedAI = ai_holder
			var/mobtension = 0
			mobtension = get_tension() //Check for their tension, based on dangerous mobs and allies nearby
			if(mobtension > 170)
				changedAI.untrusting = TRUE
			if(mobtension > 270)
				changedAI.untrusting = 2
			if(mobtension < 170)
				changedAI.untrusting = FALSE
	var/beforehealth = icon_living
	var/healthpercent = health/maxHealth
	switch(healthpercent)
		if(0.25 to 0)
			icon_living = "thrumbo-25"
		if(0.50 to 0.26)
			icon_living = "thrumbo-50"
		if(0.75 to 0.51)
			icon_living = "thrumbo-75"
		if(0.76 to INFINITY)
			icon_living = "thrumbo-100"
	if(beforehealth != icon_living)
		update_icon()

/datum/ai_holder/simple_mob/horing
	hostile = TRUE //Not actually hostile but neede for a check otherwise it won't work
	retaliate = TRUE
	cooperative = TRUE
	wander_delay = 12
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	lose_target_timeout = 240 SECONDS //How much time till they forget who attacked them.
	var/untrusting = FALSE //This will make the mob check other mobs if they're very dangerous or has intent to harm them.
	threaten = TRUE //Threaten to attack the enemy.
	threaten_delay = 7 SECONDS
	threaten_timeout = 0 SECONDS //we don't want to attack immediately when they get back, only if they don't behave after we warn
	can_flee = FALSE //No, we don't flee, we attack back.

/datum/ai_holder/simple_mob/horing/find_target(list/possible_targets, has_targets_list)
	ai_log("find_target() : Entered.", AI_LOG_TRACE)
	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	for(var/possible_target in possible_targets)
		var/target_threatlevel
		if(istype(possible_target, /atom/movable)) //Test
			var/atom/movable/threatener = possible_target
			target_threatlevel = threatener.get_threat(holder)
		if(checkthreatened(possible_target, target_threatlevel)) //won't attack anything that ain't a big threat
			if(can_attack(possible_target)) // Can we attack it?
				. += possible_target
	var/new_target = pick_target(.)
	give_target(new_target)
	return new_target

/datum/ai_holder/simple_mob/horing/proc/checkthreatened(var/possible_target, var/target_threatlevel = 0)
	if(check_attacker(possible_target))
		return TRUE
	if(untrusting == 1 && target_threatlevel > 130 && (possible_target in range(5)))
		return TRUE
	if(untrusting > 1 && target_threatlevel > 100)
		return TRUE
	else
		return FALSE

/datum/ai_holder/simple_mob/horing/threaten_target()
	holder.face_atom(target) // Constantly face the target.

	if(!threatening) // First tick.
		threatening = TRUE
		last_threaten_time = world.time
		holder.visible_emote("<span class='warning'>huffs, reacting to the threat of [target]!</span>")
		//playsound(holder, holder.say_list.threaten_sound, 50, 1) // We do this twice to make the sound -very- noticable to the target.
		//playsound(target, holder.say_list.threaten_sound, 50, 1) // Actual aim-mode also does that so at least it's consistant.
	else // Otherwise we are waiting for them to go away or to wait long enough for escalate.
		var/threatlevel = target.get_threat(holder)
		if(target in list_targets() && checkthreatened(target, threatlevel)) // Are they still visible and threatening ?
			var/should_escalate = FALSE

			if(threaten_delay && last_threaten_time + threaten_delay < world.time) // Waited too long.
				should_escalate = TRUE

			if(should_escalate)
				threatening = FALSE
				set_stance(STANCE_APPROACH)
				if(holder.say_list)
					holder.visible_emote("<span class='notice'>gets irritated, going after [target]!</span>")
			else
				return // Wait a bit.

		else // They left, or so we think.
			if(last_threaten_time + threaten_timeout < world.time)	// They've been gone long enough, probably safe to stand down
				threatening = FALSE
			set_stance(STANCE_IDLE)
			holder.visible_emote("<span class='notice'>calms down, lowering its horn</span>")
			if(holder.say_list)
				holder.ISay(SAFEPICK(holder.say_list.say_stand_down))
				playsound(holder, holder.say_list.stand_down_sound, 50, 1) // We do this twice to make the sound -very- noticable to the target.
				playsound(target, holder.say_list.stand_down_sound, 50, 1) // Actual aim-mode also does that so at least it's consistant.
