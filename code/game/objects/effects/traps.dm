//////////////////////////////
//		Traps Readme
//////////////////////////////
/*
Hello! Below you will find a variety of traps designed for map placement.
Many of these traps were created with a sort of "Tomb" or "Ruins" vibe in mind, but there is always room to expand!

All traps are able to be networked together through the ID variable.
Most traps are designed to work in conjunction with Pressure Plates, which may be located in 'code/game/turfs/flooring/flooring_traps.dm'.
Certain traps, like the Falling Log, are designed to trigger when crossed, instead of relying on a pressure plate system to trip.
Some traps necessarily possess vestigial variables, so make sure to read through them and factor in the nuances of each model!

Traps are split into a couple categories:
 - Pit
 - Launcher
 - Pop-Up
 - Falling

Pit Traps:
An undeniable classic. Pit traps are those traps which cause the floor to give way and drop an unsuspecting victim into a hazard.
Exactly how this works necessarily varies between each form of trap. Acid pits have to replace the entire turf, whereas punji pits simply lay over the floor.
Be sure to take this into consideration when laying out traps. For some undetermined reason, pit traps do not activate simultaneously, either.
That is to say, a pressure plate being tripped will only trigger one trap at a time. This is a bug and I have not yet found a solution.
Pit traps may be temporarily circumvented by laying down wooden planks to form a bridge, but be careful! These planks may not be that sturdy.
Pit traps may be closed over/reset by using floor tiles on them. This system probably needs more refinement, but it is baseline functional.

Launcher Traps:
Another Temple Delver favorite, launcher traps fire projectiles in a set direction when set off by a pressure plate.
These projectiles CAN destroy walls across from them, so be mindful of your placement when designing these, so that they don't undercut other portions of your dungeon.
Launchers may be jammed by shoving rods into the holes, and unjammed/reset by crowbarring out obstructions.
More icon variants for launchers are planned.

Pop-Up Traps:
WARNING! A debug variant exists for pop-up traps. The basic Pop-Up trap (obj/effect/trap/pop_up) is not intended for use.
These traps hide under the floor, and trigger when set off by a pressure plate.
They can be incredibly deadly, and must be destroyed to neutralize their threat. Some may be repaired with a welder.
Some, like the thrower trap, can be jammed with rods, or unjammed with wirecutters. Use throwers to catapult hapless victims into other hazards for maximum carnage!
A way to repair and/or reset every variant of Pop-Up would be nice eventually.

Falling Traps:
WARNING! A debug variant exists for falling traps. The basic Falling trap (obj/effect/trap/falling) is not intended for use.
Remember that scene with the AT-ST in Star Wars Ep. VI? I do! These traps plummet from above to totally ruin your day!
Currently only the falling log exists, but eventually I have plans for wrecking balls, dual logs, pendulum axes, and so on!
These traps not only smack you with damage flat out, but they can throw you in a random direction, allowing you to potentially send victims into other traps!
The falling log (and potentially all falling traps) can be broken by using wirecutters on the ropes, and can be repaired/reset using cables.

That about covers it! If you get an idea for a trap, swing it by me, or try your hand at implementing it yourself! If you have any questions, I'm always happy to answer them!
- Kat

General To-Do/Wants:
Solve pressure plate multi-signal issue for acid pits? Everything else pops correctly.
Make more Launcher sprites - sculpture, recessed holes, etc.
Make Laser sci-fi flavored Launchers - energy beam wall mounts, magical spinning crystals, etc.
Make it so pop-ups can be damaged by weapon attacks, and not just projectiles?
Make it so swinging ropes can be cut by knives/swords, and not just wirecutters.
Add those other swinging traps you mentioned above!
*/


/obj/effect/trap
	name = "strange area"
	desc = "The dust hangs strangely in the air here."
	icon = 'icons/turf/flooring/trap.dmi'
	icon_state = "trap_frame"
	anchored = 1
	density = 0
	//invisibility = INVISIBILITY_MAXIMUM  - Commented this invis variant out due to balancing issues/its blocking of warning text and effect icons.
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT - Commented out for admin QOL and cleanup.
	var/trap_floor_type = /turf/simulated/floor/water/acid
	var/tripped = FALSE
	var/id = "trap_debug_controller"
	var/broken = FALSE

/obj/effect/trap/Initialize(mapload)
	. = ..()
	RegisterSimpleNetwork(id)

/obj/effect/trap/SimpleNetworkReceive(id, message, list/data, datum/sender)
	. = ..()
	trip()

/obj/effect/trap/proc/trip()
	if(tripped)
		return
	if(!tripped)
		tripped = TRUE
		fire()

/obj/effect/trap/proc/fire()
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/slosh.ogg', 100, 1)
	var/turf/deploy_location = get_turf(src)
	deploy_location.ChangeTurf(trap_floor_type)

/obj/effect/trap/proc/Break()
	update_icon()
	broken = TRUE

/obj/effect/trap/proc/Reset()
	update_icon()
	broken = FALSE
	tripped = FALSE

/obj/effect/trap/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_visible"

//////////////////
/// Pit Traps
//////////////////

//Acid Pits
/obj/effect/trap/pit
	name = "strange area"
	desc = "The dust hangs strangely in the air here."

/obj/effect/trap/pit/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/stack/material/wood))
		var/obj/item/stack/material/wood/M = W
		if(M.amount >= 3)
			M.use(3)
			var/turf/T = get_turf(src)
			new /obj/structure/catwalk/plank(T)
			to_chat(user, "<span class='notice'>You carefully lay the planks over the trap, creating a bridge.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need three planks of wood to construct a bridge.</span>")

	else if(istype(W,/obj/item/stack/tile))
		var/obj/item/stack/tile/M = W
		var/rearm_type = /turf/simulated/floor/plating
		if(M.amount >= 2)
			M.use(2)
			var/turf/T = get_turf(src)
			T.ChangeTurf(rearm_type)
			tripped = 0
			update_icon()
			to_chat(user, "<span class='notice'>You patch over the hole, rearming the trap.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need two tiles to rearm the trap.</span>")

/obj/effect/trap/pit/deep
	trap_floor_type = /turf/simulated/floor/water/acid/deep

/obj/effect/trap/pit/blood
	trap_floor_type = /turf/simulated/floor/water/blood

/obj/effect/trap/pit/blood/deep
	trap_floor_type = /turf/simulated/floor/water/blood/deep

//Punji Spear Traps
/obj/effect/trap/pit/punji
	icon_state = "punji"
	trap_floor_type = null
	var/min_damage = 15
	var/max_damage = 25

/obj/effect/trap/pit/punji/fire()
	name = "punji pit"
	desc = "This pit is filled with sharpened punji stakes!"
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/weapons/slice.ogg', 100, 1)

/obj/effect/trap/pit/punji/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.visible_message("<span class='danger'>[M] falls onto a punji stake!</span>", \
						"<span class='userdanger'>You slide onto a punji stake!</span>")

/obj/effect/trap/pit/punji/attackby(obj/item/W, mob/user)
	..()
	if(istype(W,/obj/item/stack/tile))
		var/obj/item/stack/tile/M = W
		if(M.amount >= 2)
			M.use(2)
			tripped = 0
			update_icon()
			to_chat(user, "<span class='notice'>You conceal the pit, rearming the trap.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need two tiles to rearm the trap.</span>")

//Bone Breaking Traps

/obj/effect/trap/pit/bone_breaker
	icon_state = "bone"
	trap_floor_type = null

/obj/effect/trap/pit/bone_breaker/fire(atom/A)
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/bang.ogg', 100, 1)

/obj/effect/trap/pit/bone_breaker/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	if (istype(AM, /mob/living))
		break_legs()
		AM.visible_message("<span class='danger'>[AM] falls into the path of the piston!</span>", \
						"<span class='userdanger'>Your leg is crushed by the piston!</span>")

/obj/effect/trap/pit/bone_breaker/proc/break_legs(mob/victim as mob)
	var/broken_legs = 0
	var/mob/living/carbon/human/target = victim
	var/obj/item/organ/external/left_leg = target.get_organ(BP_L_LEG)
	var/obj/item/organ/external/right_leg = target.get_organ(BP_R_LEG)
	playsound(src, 'sound/effects/bang.ogg', 100, 1)
	if(left_leg && left_leg.fracture())
		broken_legs++
	if(right_leg && right_leg.fracture())
		broken_legs++
	if(!broken_legs)
		return

/obj/effect/trap/pit/bone_breaker/attackby(obj/item/W, mob/user)
	..()
	if(istype(W,/obj/item/stack/tile))
		var/obj/item/stack/tile/M = W
		if(M.amount >= 2)
			M.use(2)
			tripped = 0
			update_icon()
			to_chat(user, "<span class='notice'>You conceal the pit, rearming the trap.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need two tiles to rearm the trap.</span>")

//Pitfall Traps (These are chasms, so only use these if you're okay with permakilling someone for the round.)

//It's currently acting as if chasms don't exist. Investigate.
/*
/obj/effect/trap/pit/chasm
	trap_floor_type = /turf/open/chasm
*/

//Tentacle Pits

/obj/effect/trap/pit/tentacle
	icon_state = "tentacle"
	trap_floor_type = null
	var/min_damage = 15
	var/max_damage = 25

/obj/effect/trap/pit/tentacle/fire(atom/A)
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/blobattack.ogg', 100, 1)

/obj/effect/trap/pit/tentacle/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, TOX)
		M.SetStunned(15)
		M.visible_message("<span class='danger'>[M] falls into a writhing mass of tentacles!</span>", \
						"<span class='userdanger'>You are entwined by a writhing mass of tentacles!</span>")

/obj/effect/trap/pit/tentacle/attackby(obj/item/W, mob/user)
	..()
	if(istype(W,/obj/item/stack/tile))
		var/obj/item/stack/tile/M = W
		if(M.amount >= 2)
			M.use(2)
			tripped = 0
			update_icon()
			to_chat(user, "<span class='notice'>You conceal the pit, rearming the trap.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need two tiles to rearm the trap.</span>")

//////////////////
// Launcher Traps
//////////////////

//Crossbow Launcher
/obj/effect/trap/launcher
	name = "odd sculpture"
	desc = "This sculpture on the wall seems vaguely threatening."
	icon_state = "launcher"
	anchored = 1
	density = 1
	dir = 2
	trap_floor_type = null
	var/projectile_type
	var/projectile_sound
	var/fire_delay = 5
	var/max_burst_delay = 10
	var/min_burst_delay = 2
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0

	var/burst_delay = 2
	var/initial_fire_delay = 5

	//This needs to check dirs, projectiles, accuracy, reload/recharge. It's kinda gonna suck. Consult Turret code.

/obj/effect/trap/launcher/Initialize(mapload)
	. = ..()
	RegisterSimpleNetwork(id)
	START_PROCESSING(SSobj, src)

/obj/effect/trap/launcher/fire()
	update_icon()
	visible_message("<span class='danger'>The sculpture's eyes snap open!</span>")
	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 100, 1)

/obj/effect/trap/launcher/process(delta_time)
	if(!tripped)
		return
	if(broken)
		return
	if(((src.last_shot + src.fire_delay) <= world.time) && (!broken) && (src.tripped))

		src.last_shot = world.time
		if(src.shot_number < burst_shots)
			src.fire_delay = get_burst_delay()
			src.shot_number ++
		else
			src.fire_delay = get_rand_burst_delay()
			src.shot_number = 0

		playsound(src.loc, projectile_sound, 25, 1)

		var/obj/item/projectile/bullet/shotgun/stake/P = get_projectile()
		P.firer = src
		P.fire(dir2angle(dir))

/obj/effect/trap/launcher/proc/get_initial_fire_delay()
	return initial_fire_delay

/obj/effect/trap/launcher/proc/get_rand_burst_delay()
	return rand(min_burst_delay, max_burst_delay)

/obj/effect/trap/launcher/proc/get_burst_delay()
	return burst_delay

/obj/effect/trap/launcher/proc/get_projectile()
	return new projectile_type(get_turf(src))

/obj/effect/trap/launcher/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/rods))
		var/obj/item/stack/rods/M = W
		if(M.amount >= 5)
			M.use(5)
			Break()
			to_chat(user, "<span class='notice'>You slip the rods into the firing mechanism, jamming it.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need five rods to jam the mechanism.</span>")

	if(istype(W,/obj/item/tool/crowbar))
		if(broken)
			Reset()
			to_chat(user, "<span class='notice'>You pry the obstruction out, resetting the trap.</span>")
		else
			to_chat(user, "<span class='warning'>You can't pry this sculpture off of the wall.</span>")

/obj/effect/trap/launcher/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped && !broken)
		icon_state = "[initial(icon_state)]_visible"
	else if (tripped && broken)
		icon_state = "[initial(icon_state)]_jammed"

//Stake Launcher
/obj/effect/trap/launcher/stake
	projectile_type = /obj/item/projectile/bullet/shotgun/stake
	projectile_sound = 'sound/weapons/punchmiss.ogg'

//Dart Launcher
/obj/effect/trap/launcher/dart
	projectile_type = /obj/item/projectile/energy/bolt
	projectile_sound = 'sound/weapons/slice.ogg'

//Fireball Launcher
/obj/effect/trap/launcher/fireball
	projectile_type = /obj/item/projectile/bullet/incendiary/flamethrower/large
	projectile_sound = 'sound/effects/bamf.ogg'

//Heavy Fireball Launcher
/obj/effect/trap/launcher/fireball_aoe
	projectile_type = /obj/item/projectile/magic/aoe/fireball
	projectile_sound = 'sound/weapons/cannon.ogg'

//Web Launcher
/obj/effect/trap/launcher/web
	projectile_type = /obj/item/projectile/webball
	projectile_sound = 'sound/effects/splat.ogg'

//Flesh Launcher
/obj/effect/trap/launcher/flesh
	projectile_type = /obj/item/projectile/bullet/organic
	projectile_sound = 'sound/effects/squelch1.ogg'

//////////////////
// Pop-Up Traps
//////////////////

//Debug
/obj/effect/trap/pop_up
	name = "pop up trap"
	desc = "You shouldn't be seeing this! Contact an admin!"
	icon_state = "popup_spear"
	anchored = 1
	density = 0
	trap_floor_type = null
	var/min_damage = 15
	var/max_damage = 25
	var/health = 200
	var/maxhealth = 200

/obj/effect/trap/pop_up/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/trap/pop_up/attackby(var/obj/item/W, var/mob/user)
	if((health <= 0))
		Break()
		return
	if(W.attack_verb.len)
		src.visible_message("<span class='danger'>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]</span>")
	else
		src.visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			if(health < maxhealth)
				to_chat(user, "<span class='notice'>You begin repairing \the [src.name] with \the [WT].</span>")
			if(do_after(user, 20, src))
				health = maxhealth
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	healthcheck()

/obj/effect/trap/pop_up/proc/healthcheck()
	if((health <= 0))
		Break()

/obj/effect/trap/pop_up/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped && !broken)
		icon_state = "[initial(icon_state)]_visible"
	else if (tripped && broken)
		icon_state = "[initial(icon_state)]_broken"

//Spear Trap

/obj/effect/trap/pop_up/spear
	name = "loose tile"
	desc = "The edges of this tile are angled strangely."
	icon_state = "popup_spear"

/obj/effect/trap/pop_up/spear/fire()
	update_icon()
	visible_message("<span class='danger'>Blades erupt from concealed holes in the floor!</span>")
	playsound(src, 'sound/effects/holster/holsterout.ogg', 100, 1) //Sound is too quiet, same issue as pillar.
	name = "spear trap"
	desc = "These knee-high blades look dangerous!"

/obj/effect/trap/pop_up/spear/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else if(broken)
		return
	else if (!tripped)
		return
	else if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.visible_message("<span class='danger'>[M] is stabbed by the rising spears!</span>", \
						"<span class='userdanger'>You are impaled by a thrusting spear!</span>")

//Spinning Blade Column

/obj/effect/trap/pop_up/pillar
	icon_state = "popup_pillar"
	min_damage = 10
	max_damage = 30

/obj/effect/trap/pop_up/pillar/fire()
	update_icon()
	visible_message("<span class='danger'>A bladed pillar pops up from a concealed pit in the floor!</span>")
	playsound(src, 'sound/effects/holster/holsterout.ogg', 100, 1) //Fix sound. It's the gun draw sound, not the blade draw.
	name = "spinning blade trap"
	desc = "The blades on this waist-high pillar are spinning violently!"

/obj/effect/trap/pop_up/pillar/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else if(broken)
		return
	else if (!tripped)
		return
	else if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.visible_message("<span class='danger'>[M] is slashed by the spinning blades!</span>", \
						"<span class='userdanger'>You are slashed by the spinning blades!</span>")

/* This is all per-tick processing stuff. It isn't working the way I want, so I'm reverting it.

if (istype(AM, /mob/living))
		START_PROCESSING(SSfastprocess, src)
		var/mob/living/M = AM
		M.visible_message("<span class='danger'>[M] is slashed by the spinning blades!</span>", \
						"<span class='userdanger'>You are slashed by the spinning blades!</span>")

/obj/effect/trap/pop_up/pillar/process(atom/AM as mob|obj)
	var/mob/living/M = AM
	var/damage = rand(min_damage, max_damage)
	M.apply_damage(damage, BRUTE)

/obj/effect/trap/pop_up/pillar/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()
*/

//Springtrap Buzzsaw

/obj/effect/trap/pop_up/buzzsaw
	icon_state = "popup_saw"
	min_damage = 25
	max_damage = 45

/obj/effect/trap/pop_up/buzzsaw/fire()
	update_icon()
	visible_message("<span class='danger'>Sawblades erupt from concealed slats in the floor!</span>")
	playsound(src, 'sound/weapons/circsawhit.ogg', 100, 1)
	name = "spinning saw trap"
	desc = "These buzzsaw blades are spinning incredibly quickly!"

/obj/effect/trap/pop_up/buzzsaw/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else if(broken)
		return
	else if (!tripped)
		return
	else if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.visible_message("<span class='danger'>[M] is ripped by the whirling sawblades!</span>", \
						"<span class='userdanger'>You are ripped open by the whirling sawblades!</span>")

//Flame Trap

/obj/effect/trap/pop_up/flame
	icon_state = "popup_flame"
	min_damage = 5
	max_damage = 15

/obj/effect/trap/pop_up/flame/fire()
	update_icon()
	visible_message("<span class='danger'>Flames gush from a hidden nozzle in the floor!</span>")
	playsound(src, 'sound/effects/bamf.ogg', 100, 1)
	name = "flame geyser trap"
	desc = "The flames bursting out of this are extremely hot!"

/obj/effect/trap/pop_up/flame/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else if(broken)
		return
	else if (!tripped)
		return
	else if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BURN)
		M.adjust_fire_stacks(2)
		M.IgniteMob()
		M.visible_message("<span class='danger'>[M] is engulfed in flames!</span>", \
						"<span class='userdanger'>You are engulfed in ravenous flames!</span>")

//Tossing Piston Plate

/obj/effect/trap/pop_up/thrower
	name = "crooked tile"
	desc = "The edges of this tile are lifted slightly."
	icon_state = "thrower"
	trap_floor_type = null

/obj/effect/trap/pop_up/thrower/fire()
	update_icon()
	visible_message("<span class='danger'>The floor tile pistons upwards violently!</span>")
	playsound(src, 'sound/effects/bang.ogg', 100, 1)
	name = "piston trap"
	desc = "This concealed piston rockets upwards with great force."

/obj/effect/trap/pop_up/thrower/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	else if(broken)
		return
	else if (!tripped)
		return
	else if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
		var/turf/T2 = get_step(AM, pick(throw_dirs))
		M.throw_at(T2, 1, 1, src)
		var/head_slot = SLOT_HEAD
		if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
			M.setBrainLoss(2,5)
			M.updatehealth()
		update_icon()
		playsound(src, 'sound/effects/bang.ogg', 100, 1)
		visible_message("<span class='danger'>[src] slams into [M], sending them flying!</span>")
		M.Weaken(12)

/obj/effect/trap/pop_up/thrower/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/rods))
		var/obj/item/stack/rods/M = W
		if(M.amount >= 3)
			M.use(3)
			Break()
			to_chat(user, "<span class='notice'>You slip the rods between the plate and its base, jamming it.</span>")
			user.drop_from_inventory(src)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need three rods to jam the mechanism.</span>")

	if(istype(W,/obj/item/tool/wirecutters))
		if(broken)
			Reset()
			to_chat(user, "<span class='notice'>You slice the rods and remove them, resetting the trap.</span>")
		else
			to_chat(user, "<span class='warning'>You can't disarm the trap this way!</span>")

/obj/effect/trap/pop_up/thrower/Reset()
	update_icon()
	broken = FALSE
	tripped = FALSE
	name = "crooked tile"
	desc = "The edges of this tile are lifted slightly."

/obj/effect/trap/pop_up/thrower/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped && !broken)
		icon_state = "[initial(icon_state)]_visible"
	else if (tripped && broken)
		icon_state = "[initial(icon_state)]_jammed"

//////////////////
// Falling Traps
//////////////////

//Falling Log
/obj/effect/trap/falling
	name = "falling trap"
	desc = "You shouldn't be seeing this! Contact an admin!"
	icon_state = "log"
	trap_floor_type = null
	var/min_damage = 20
	var/max_damage = 40

/obj/effect/trap/falling/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/M = W
		if(M.amount >= 5 && broken)
			M.use(5)
			Reset()
			to_chat(user, "<span class='notice'>You use the coils to raise the [src] back up, resetting it.</span>")
			user.drop_from_inventory(src)
			qdel(src)

	if(istype(W,/obj/item/tool/wirecutters))
		if(!broken)
			Break()
			to_chat(user, "<span class='notice'>You cut the ropes suspending the [src], breaking it.</span>")

/obj/effect/trap/falling/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped && !broken)
		icon_state = "[initial(icon_state)]_visible"
	else if (tripped && broken)
		icon_state = "[initial(icon_state)]_jammed"

//Falling Log
/obj/effect/trap/falling/log
	name = "wavering tile"
	desc = "There's something strange about the lighting around this tile."
	icon_state = "log"
	trap_floor_type = null
	id = "self_triggering"
	min_damage = 20
	max_damage = 40

/obj/effect/trap/falling/log/fire()
	visible_message("<span class='danger'>A log swings down from overhead!</span>")
	tripped = TRUE
	name = "falling log trap"
	desc = "A heavy wooden log suspended by ropes. Primitive, but effective."

/obj/effect/trap/falling/log/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	if(broken)
		return
	if(tripped)
		return
	if(istype(AM, /mob/living))
		fire()
		update_icon()
		var/mob/living/M = AM
		var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
		var/turf/T2 = get_step(AM, pick(throw_dirs))
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.throw_at(T2, 1, 1, src)
		var/head_slot = SLOT_HEAD
		if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
			M.setBrainLoss(2,5)
			M.updatehealth()
		playsound(src, 'sound/effects/bang.ogg', 100, 1)
		visible_message("<span class='danger'>The falling log slams into [M], sending them flying!</span>")
		M.Weaken(12)

/obj/effect/trap/falling/log/Reset()
	update_icon()
	broken = FALSE
	tripped = FALSE
	name = "wavering tile"
	desc = "There's something strange about the lighting around this tile."

/obj/effect/trap/falling/log/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped && !broken)
		icon_state = "[initial(icon_state)]_visible"
	else if (tripped && broken)
		icon_state = "[initial(icon_state)]_jammed"
