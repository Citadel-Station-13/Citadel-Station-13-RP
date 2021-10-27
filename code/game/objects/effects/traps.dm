//Place traps here. Crossbow trap as basis?

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

/obj/effect/trap/Initialize()
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

/obj/effect/trap/launcher/Initialize()
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
	if(((src.last_shot + src.fire_delay) <= world.time) && (src.tripped))

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

//Set up the Crossed for these.
/obj/effect/trap/pop_up
	name = "loose tile"
	desc = "The edges of this tile are lifted slightly."
	icon_state = "popup_spear"
	anchored = 1
	density = 0
	trap_floor_type = null
	var/min_damage = 15
	var/max_damage = 25
	var/health = 200
	var/maxhealth = 200
	var/broken

/obj/effect/trap/pop_up/fire()
	update_icon()
	visible_message("<span class='danger'>Blades erupt from concealed holes in the floor!</span>")
	playsound(src, 'sound/effects/holster/holsterout.ogg', 100, 1)
	name = "spear trap"
	desc = "These knee-high blades look dangerous!"

/obj/effect/trap/pop_up/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	if(broken)
		return
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.visible_message("<span class='danger'>[M] is stabbed by the rising spears!</span>", \
						"<span class='userdanger'>You are impaled by a thrusting spear!</span>")

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

/obj/effect/trap/pop_up/proc/Break()
	update_icon()
	broken = TRUE

/obj/effect/trap/pop_up/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_visible"
	else if (broken)
		icon_state = "[initial(icon_state)]_broken"

//Spinning Blade Column

/obj/effect/trap/pop_up/pillar
	name = "loose tile"
	desc = "The edges of this tile are lifted slightly."
	icon_state = "popup_pillar"
	min_damage = 10
	max_damage = 30

/obj/effect/trap/pop_up/pillar/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/trap/pop_up/pillar/Break()
	update_icon()
	Destroy()
	broken = TRUE

/obj/effect/trap/pop_up/pillar/fire()
	update_icon()
	visible_message("<span class='danger'>A bladed pillar pops up from a concealed pit in the floor!</span>")
	playsound(src, 'sound/effects/holster/holsterout.ogg', 100, 1)
	name = "spinning blade trap"
	desc = "The blades on this waist-high pillar are spinning violently!"

/obj/effect/trap/pop_up/pillar/Crossed(atom/AM as mob|obj)
	. = ..()
	if(AM.is_incorporeal())
		return
	if(broken)
		return
	if (istype(AM, /mob/living))
		START_PROCESSING(SSfastprocess, src)
		var/mob/living/M = AM
		M.visible_message("<span class='danger'>[M] is slashed by the spinning blades!</span>", \
						"<span class='userdanger'>You are slashed by the spinning blades!</span>")

/obj/effect/trap/pop_up/pillar/process(atom/AM as mob|obj)
	var/mob/living/M = AM
	var/damage = rand(min_damage, max_damage)
	M.apply_damage(damage, BRUTE)

//Springtrap Buzzsaw

/obj/effect/trap/pop_up/buzzsaw
	name = "loose tile"
	desc = "The edges of this tile are lifted slightly."
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
	if(broken)
		return
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		var/damage = rand(min_damage, max_damage)
		M.apply_damage(damage, BRUTE)
		M.visible_message("<span class='danger'>[M] is ripped by the whirling sawblades!</span>", \
						"<span class='userdanger'>You are ripped open by the whirling sawblades!</span>")

//Falling Log
//Have this throw on impact like with skateboards.

/*
General to-do:
Plank bridges aren't taking damage/updating. Investigate.
Test trap breakages. - Consult with Ursa on breaks not popping.
Solve pressure plate multi-signal issue.
*/
