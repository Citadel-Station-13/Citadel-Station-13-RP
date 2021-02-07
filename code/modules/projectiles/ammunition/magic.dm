/obj/item/projectile/magic
	name = "bolt of nothing"
	icon_state = "energy"
	damage = 0
	damage_type = OXY
	nodamage = 1
	armor_penetration = 100
	var/magic = TRUE
	var/checks_antimagic = TRUE

/obj/item/projectile/magic/death
	name = "bolt of death"
	icon_state = "pulse1_bl"

/obj/item/projectile/magic/death/on_hit(target, var/mob/living/L)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(L.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			return blocked
		M.death(0)

/obj/item/projectile/magic/resurrection
	name = "bolt of resurrection"
	icon_state = "ion"
	damage = 0
	damage_type = OXY
	nodamage = 1

/obj/item/projectile/magic/resurrection/on_hit(mob/living/carbon/target)
	. = ..()
	if(isliving(target))
		if(target.anti_magic_check())
			target.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			return blocked
		if(target.revive(full_heal = 1))
			to_chat(target, "<span class='notice'>You rise with a start, you're alive!!!</span>")
		else if(target.stat != DEAD)
			to_chat(target, "<span class='notice'>You feel great!</span>")

/obj/item/projectile/magic/teleport
	name = "bolt of teleportation"
	icon_state = "bluespace"
	damage = 0
	damage_type = OXY
	nodamage = 1
	var/inner_tele_radius = 0
	var/outer_tele_radius = 6

/obj/item/projectile/magic/teleport/on_hit(mob/target, var/mob/living/L)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(L.anti_magic_check())
			M.visible_message("<span class='warning'>[src] fizzles on contact with [target]!</span>")
			return blocked
	var/teleammount = 0
	var/teleloc = target
	if(!isturf(target))
		teleloc = target.loc
	for(var/atom/movable/stuff in teleloc)
		if(!stuff.anchored && stuff.loc)
			if(do_teleport(stuff, stuff, 10))
				teleammount++
				var/datum/effect_system/smoke_spread/smoke = new
				smoke.set_up(max(round(4 - teleammount),0), stuff.loc) //Smoke drops off if a lot of stuff is moved for the sake of sanity
				smoke.start()

/obj/item/projectile/magic/door
	name = "bolt of door creation"
	icon_state = "energy"
	damage = 0
	damage_type = OXY
	nodamage = 1
	var/list/door_types = list(/obj/structure/simple_door/wood, /obj/structure/simple_door/iron, /obj/structure/simple_door/silver, /obj/structure/simple_door/gold, /obj/structure/simple_door/uranium, /obj/structure/simple_door/sandstone, /obj/structure/simple_door/phoron, /obj/structure/simple_door/diamond)

/obj/item/projectile/magic/door/on_hit(atom/target)
	. = ..()
	if(istype(target, /obj/machinery/door))
		OpenDoor(target)
	else
		var/turf/T = get_turf(target)
		if(/turf/simulated/wall)
			CreateDoor(T)

/obj/item/projectile/magic/door/proc/CreateDoor(turf/T)
	var/door_type = pick(door_types)
	var/obj/structure/simple_door/D = new door_type(T)
	T.ChangeTurf(/turf/simulated/floor/plating)
	D.Open()

/obj/item/projectile/magic/door/proc/OpenDoor(var/obj/machinery/door/D)
	if(istype(D, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = D
		A.locked = FALSE
		D.open()

/* //Needs more work.
/obj/item/projectile/magic/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = 1

/obj/item/projectile/magic/change/on_hit(atom/change)
	. = ..()
	if(ismob(change))
		var/mob/M = change
		if(M.anti_magic_check())
			M.visible_message("<span class='warning'>[src] fizzles on contact with [M]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	wabbajack(change)
	qdel(src)

/proc/wabbajack(mob/living/M)
	if(!istype(M) || M.stat == DEAD || M.mob_transforming || (GODMODE & M.status_flags))
		return

	M.mob_transforming = TRUE
	M.Paralyze(INFINITY)
	M.icon = null
	M.cut_overlays()
	M.invisibility = INVISIBILITY_ABSTRACT

	var/list/contents = M.contents.Copy()

	if(iscyborg(M))
		var/mob/living/silicon/robot/Robot = M
		if(Robot.mmi)
			qdel(Robot.mmi)
		Robot.notify_ai(NEW_BORG)
	else
		for(var/obj/item/W in contents)
			if(!M.dropItemToGround(W))
				qdel(W)

	var/mob/living/new_mob

	var/randomize = pick("monkey","robot","slime","xeno","humanoid","animal")
	switch(randomize)
		if("monkey")
			new_mob = new /mob/living/carbon/monkey(M.loc)

		if("robot")
			var/robot = pick(200;/mob/living/silicon/robot,
							/mob/living/silicon/robot/modules/syndicate,
							/mob/living/silicon/robot/modules/syndicate/medical,
							/mob/living/silicon/robot/modules/syndicate/saboteur,
							200;/mob/living/simple_animal/drone/polymorphed)
			new_mob = new robot(M.loc)
			if(issilicon(new_mob))
				new_mob.gender = M.gender
				new_mob.invisibility = 0
				new_mob.job = "Cyborg"
				var/mob/living/silicon/robot/Robot = new_mob
				Robot.lawupdate = FALSE
				Robot.connected_ai = null
				Robot.mmi.transfer_identity(M)	//Does not transfer key/client.
				Robot.clear_inherent_laws(0)
				Robot.clear_zeroth_law(0)

		if("slime")
			new_mob = new /mob/living/simple_animal/slime/random(M.loc)

		if("xeno")
			var/Xe
			if(M.ckey)
				Xe = pick(/mob/living/carbon/alien/humanoid/hunter,/mob/living/carbon/alien/humanoid/sentinel)
			else
				Xe = pick(/mob/living/carbon/alien/humanoid/hunter,/mob/living/simple_animal/hostile/alien/sentinel)
			new_mob = new Xe(M.loc)

		if("animal")
			var/path = pick(/mob/living/simple_animal/hostile/carp,
							/mob/living/simple_animal/hostile/bear,
							/mob/living/simple_animal/hostile/mushroom,
							/mob/living/simple_animal/hostile/retaliate/bat,
							/mob/living/simple_animal/hostile/retaliate/goat,
							/mob/living/simple_animal/hostile/killertomato,
							/mob/living/simple_animal/hostile/poison/giant_spider,
							/mob/living/simple_animal/hostile/poison/giant_spider/hunter,
							/mob/living/simple_animal/hostile/blob/blobbernaut/independent,
							/mob/living/simple_animal/hostile/asteroid/basilisk/watcher,
							/mob/living/simple_animal/hostile/asteroid/goliath/beast,
							/mob/living/simple_animal/hostile/morph,
							/mob/living/simple_animal/hostile/stickman,
							/mob/living/simple_animal/hostile/stickman/dog,
							/mob/living/simple_animal/hostile/megafauna/dragon/lesser,
							/mob/living/simple_animal/hostile/gorilla,
							/mob/living/simple_animal/parrot,
							/mob/living/simple_animal/pet/dog/corgi,
							/mob/living/simple_animal/crab,
							/mob/living/simple_animal/pet/dog/pug,
							/mob/living/simple_animal/pet/cat,
							/mob/living/simple_animal/mouse,
							/mob/living/simple_animal/chicken,
							/mob/living/simple_animal/cow,
							/mob/living/simple_animal/hostile/lizard,
							/mob/living/simple_animal/pet/fox,
							/mob/living/simple_animal/butterfly,
							/mob/living/simple_animal/pet/cat/cak,
							/mob/living/simple_animal/chick,
							/mob/living/simple_animal/pickle)
			new_mob = new path(M.loc)

		if("humanoid")
			if(prob(50))
				new_mob = new /mob/living/carbon/human(M.loc)
			else
				var/hooman = pick(subtypesof(/mob/living/carbon/human/species))
				new_mob =new hooman(M.loc)

			var/datum/preferences/A = new()	//Randomize appearance for the human
			A.copy_to(new_mob, FALSE)

			var/mob/living/carbon/human/H = new_mob
			H.update_body()
			H.update_hair()
			H.update_body_parts()
			H.dna.update_dna_identity()

	if(!new_mob)
		return

	// Some forms can still wear some items
	for(var/obj/item/W in contents)
		new_mob.equip_to_appropriate_slot(W)

	M.log_message("became [new_mob.real_name]", LOG_ATTACK, color="orange")

	new_mob.a_intent = INTENT_HARM

	M.wabbajack_act(new_mob)

	to_chat(new_mob, "<span class='warning'>Your form morphs into that of a [randomize].</span>")

	var/poly_msg = CONFIG_GET(keyed_list/policy)["polymorph"]
	if(poly_msg)
		to_chat(new_mob, poly_msg)

	M.transfer_observers_to(new_mob)

	qdel(M)
	return new_mob

/obj/item/projectile/magic/animate
	name = "bolt of animation"
	icon_state = "red_1"
	damage = 0
	damage_type = BURN
	nodamage = 1

/obj/item/projectile/magic/animate/on_hit(atom/target, blocked = FALSE)
	target.animate_atom_living(firer)
	. = ..()

/atom/proc/animate_atom_living(var/mob/living/owner = null)
	if((isitem(src) || isstructure(src)) && !is_type_in_list(src, GLOB.protected_objects))
		if(istype(src, /obj/structure/statue/petrified))
			var/obj/structure/statue/petrified/P = src
			if(P.petrified_mob)
				var/mob/living/L = P.petrified_mob
				var/mob/living/simple_animal/hostile/statue/S = new(P.loc, owner)
				S.name = "statue of [L.name]"
				if(owner)
					S.faction = list("[REF(owner)]")
				S.icon = P.icon
				S.icon_state = P.icon_state
				S.copy_overlays(P, TRUE)
				S.color = P.color
				S.atom_colours = P.atom_colours.Copy()
				if(L.mind)
					L.mind.transfer_to(S)
					if(owner)
						to_chat(S, "<span class='userdanger'>You are an animated statue. You cannot move when monitored, but are nearly invincible and deadly when unobserved! Do not harm [owner], your creator.</span>")
				P.forceMove(S)
				return
		else
			var/obj/O = src
			if(istype(O, /obj/item/gun))
				new /mob/living/simple_animal/hostile/mimic/copy/ranged(loc, src, owner)
			else
				new /mob/living/simple_animal/hostile/mimic/copy(loc, src, owner)

	else if(istype(src, /mob/living/simple_animal/hostile/mimic/copy))
		// Change our allegiance!
		var/mob/living/simple_animal/hostile/mimic/copy/C = src
		if(owner)
			C.ChangeOwner(owner)
*/
/obj/item/projectile/magic/spellblade
	name = "blade energy"
	icon_state = "lavastaff"
	damage = 15
	damage_type = BURN
	sharp = TRUE
	magic = TRUE

/obj/item/projectile/magic/spellblade/on_hit(target, var/mob/living/L)
	if(ismob(target))
		var/mob/M = target
		if(L.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			qdel(src)
			return
	. = ..()

/obj/item/projectile/magic/arcane_barrage
	name = "arcane bolt"
	icon_state = "arcane_barrage"
	damage = 20
	damage_type = BURN
	nodamage = 0
	armor_penetration = 0
	magic = TRUE
	hitsound = 'sound/weapons/barragespellhit.ogg'

/obj/item/projectile/magic/arcane_barrage/on_hit(target, var/mob/living/L)
	if(ismob(target))
		var/mob/M = target
		if(L.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			qdel(src)
			return
	. = ..()


/obj/item/projectile/magic/locker
	name = "locker bolt"
	icon_state = "locker"
	nodamage = TRUE
	magic = TRUE
	var/weld = TRUE
	var/created = FALSE //prevents creation of more then one locker if it has multiple hits
	var/locker_suck = TRUE

/obj/item/projectile/magic/locker/proc/prehit(atom/A, var/mob/living/L)
	if(ismob(A) && locker_suck)
		var/mob/M = A
		if(L.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [A]!</span>")
			qdel(src)
			return
		if(M.anchored)
			return ..()
		M.forceMove(src)
		return FALSE
	return ..()

/obj/item/projectile/magic/locker/on_hit(target)
	if(created)
		return ..()
	var/obj/structure/closet/decay/C = new(get_turf(src))
	if(LAZYLEN(contents))
		for(var/atom/movable/AM in contents)
		C.update_icon()
	created = TRUE
	return ..()

/obj/item/projectile/magic/locker/Destroy()
	locker_suck = FALSE
	for(var/atom/movable/AM in contents)
		AM.forceMove(get_turf(src))
	. = ..()

/obj/structure/closet/decay
	breakout_time = 600
	var/magic_icon = "cursed"
	var/weakened_icon = "decursed"
	var/auto_destroy = TRUE

/obj/structure/closet/decay/Initialize()
	. = ..()
	if(auto_destroy)
		addtimer(CALLBACK(src), 5 MINUTES)
	addtimer(CALLBACK(src), 5)

/obj/structure/closet/decay/proc/decay()
	animate(src, alpha = 0, time = 30)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 30)

/obj/structure/closet/decay/open(mob/living/user)
	. = ..()
	if(.)
		if(icon_state == magic_icon) //check if we used the magic icon at all before giving it the lesser magic icon
			unmagify()
		else
			addtimer(CALLBACK(src, .proc/decay), 15 SECONDS)

/obj/structure/closet/decay/proc/unmagify()
	icon_state = weakened_icon
	update_icon()
	addtimer(CALLBACK(src, .proc/decay), 15 SECONDS)

/obj/item/projectile/magic/aoe
	name = "Area Bolt"
	desc = "What the fuck does this do?!"
	damage = 0
	var/proxdet = TRUE

/obj/item/projectile/magic/aoe/Range()
	if(proxdet)
		for(var/mob/living/L in range(1, get_turf(src)))
			if(L.stat != DEAD && L != firer && !L.anti_magic_check())
				return Bump(L)
	..()


/obj/item/projectile/magic/aoe/lightning
	name = "lightning bolt"
	icon_state = "tesla_projectile"	//Better sprites are REALLY needed and appreciated!~
	damage = 15
	damage_type = BURN
	nodamage = 0
	magic = TRUE

	var/zap_power = 20000
	var/zap_range = 15
	var/chain
	var/mob/living/caster

/obj/item/projectile/magic/aoe/lightning/fire(setAngle)
	if(caster)
		chain = caster.Beam(src, icon_state = "lightning[rand(1, 12)]", time = INFINITY, maxdistance = INFINITY)
	..()

/obj/item/projectile/magic/aoe/lightning/on_hit(target, var/mob/living/L)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(L.anti_magic_check())
			M.visible_message("<span class='warning'>[src] fizzles on contact with [target]!</span>")
			qdel(src)
		return blocked
	tesla_zap(src, zap_range, zap_power)
	qdel(src)

/obj/item/projectile/magic/aoe/lightning/Destroy()
	qdel(chain)
	. = ..()

/obj/item/projectile/magic/aoe/fireball
	name = "bolt of fireball"
	icon_state = "fireball"
	damage = 10
	damage_type = BRUTE
	nodamage = 0

	//explosion values
	var/exp_heavy = 0
	var/exp_light = 2
	var/exp_flash = 3
	var/exp_fire = 2

/obj/item/projectile/magic/aoe/fireball/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message("<span class='warning'>[src] vanishes into smoke on contact with [target]!</span>")
			return
		M.take_overall_damage(0,10) //between this 10 burn, the 10 brute, the explosion brute, and the onfire burn, your at about 65 damage if you stop drop and roll immediately
	var/turf/T = get_turf(target)
	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire)

/obj/item/projectile/magic/aoe/fireball/infernal
	name = "infernal fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 4
	exp_fire= 5

/obj/item/projectile/magic/aoe/fireball/infernal/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			return
	var/turf/T = get_turf(target)
	for(var/i=0, i<50, i+=10)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, T, -1, exp_heavy, exp_light, exp_flash, FALSE, FALSE, exp_fire), i)

/obj/item/projectile/magic/nuclear
	name = "\proper blazing manliness"
	icon_state = "nuclear"
	nodamage = TRUE
	var/mob/living/victim = null
	var/used = 0

/obj/item/projectile/magic/nuclear/on_hit(target)
	if(used)
		return
	if(ismob(target))
		if(target == victim)
			return
		used = 1
		visible_message("<span class='danger'>[victim] slams into [target] with explosive force!</span>")
		explosion(src, 2, 3, 4, -1, TRUE, FALSE, 5)
	else
		used = 1
		victim.take_overall_damage(30,30)
		explosion(src, -1, -1, -1, -1, FALSE, FALSE, 5)
	return

/obj/item/projectile/magic/nuclear/Destroy()
	for(var/atom/movable/AM in contents)
		AM.forceMove(get_turf(src))
	. = ..()

//Spellcards

/obj/item/projectile/spellcard
	name = "enchanted card"
	desc = "A piece of paper enchanted to give it extreme durability and stiffness, along with a very hot burn to anyone unfortunate enough to get hit by a charged one."
	icon_state = "spellcard"
	damage_type = BURN
	damage = 2

/obj/item/projectile/magic/spellcard/book
	nodamage = FALSE
	name = "enchanted page"
	desc = "A piece of paper enchanted to give it extreme durability and stiffness, along with a very hot burn to anyone unfortunate enough to get hit by a charged one."
	icon_state = "spellcard"
	damage_type = BURN
	damage = 12
	magic = TRUE

/obj/item/projectile/magic/spellcard/book/spark
	damage = 4
	var/fire_stacks = 4

/obj/item/projectile/magic/spellcard/book/spark/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/M = target
	if(ismob(target))
		if(M.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			return

	if(iscarbon(target))
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()
		return
	else
		damage = 20 //If we are a simplemob we deal 5x damage

/obj/item/projectile/magic/spellcard/book/shock
	damage = 0
	stutter = 5
	agony = 20
	stun = 10

/* //Still need help on healing procs.
/obj/item/projectile/magic/spellcard/book/heal
	damage = 0
	nodamage  = TRUE

/obj/item/projectile/magic/spellcard/book/heal/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/M = target
	if(ismob(target))
		if(M.anti_magic_check())
			M.visible_message("<span class='warning'>[src] vanishes on contact with [target]!</span>")
			return
	if(iscarbon(target))
		M.visible_message("<span class='warning'>[src] mends [target]!</span>")
		M.adjustBruteLoss(-5) //HEALS
		M.adjustOxyLoss(-5)
		M.adjustBruteLoss(-5)
		M.adjustFireLoss(-5)
		M.adjustToxLoss(-5, TRUE) //heals TOXINLOVERs
		M.adjustCloneLoss(-5)
		M.adjustStaminaLoss(-5)
		return
*/
