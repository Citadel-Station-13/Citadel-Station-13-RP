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

/obj/effect/trap/pit/deep
	trap_floor_type = /turf/simulated/floor/water/acid/deep

/obj/effect/trap/pit/blood
	trap_floor_type = /turf/simulated/floor/water/blood

/obj/effect/trap/pit/blood/deep
	trap_floor_type = /turf/simulated/floor/water/blood/deep

//Punji Spear Traps
/obj/effect/trap/pit/punji
	icon_state = "punji_frame"
	trap_floor_type = null
	var/min_damage = 15
	var/max_damage = 25

/obj/effect/trap/pit/punji/fire()
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

//Bone Breaking Traps

/obj/effect/trap/pit/bone_breaker
	icon_state = "bone_frame"
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
	playsound(src, 'sound/effects/bang.ogg', 100, 1)
	if(left_leg && left_leg.fracture())
		broken_legs++
	var/obj/item/organ/external/right_leg = target.get_organ(BP_R_LEG)
	if(right_leg && right_leg.fracture())
		broken_legs++
	if(!broken_legs)
		return

//Pitfall Traps (These are chasms, so only use these if you're okay with permakilling someone for the round.)

//It's currently acting as if chasms don't exist. Investigate.
/*
/obj/effect/trap/pit/chasm
	trap_floor_type = /turf/open/chasm
*/

//Tentacle Pits

/obj/effect/trap/pit/tentacle
	icon_state = "tentacle_frame"
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


//////////////////
// Launcher Traps
//////////////////

//Crossbow Launcher
/obj/effect/trap/launcher
	name = "odd sculpture"
	desc = "This sculpture on the wall seems vaguely threatening."
	icon_state = "trap_frame" //I'm considering like, a sculpted face with an open mouth.
	anchored = 1
	density = 1
	dir = 2
	trap_floor_type = null

	//This needs to check dirs, projectiles, accuracy, reload/recharge. It's kinda gonna suck. Consult Turret code.

/obj/effect/trap/launcher/Initialize()
	. = ..()
	RegisterSimpleNetwork(id)

/obj/effect/trap/launcher/fire()
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/slosh.ogg', 100, 1)
	var/turf/deploy_location = get_turf(src)
	deploy_location.ChangeTurf(trap_floor_type)

/obj/effect/trap/launcher/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_visible"

//Dart Launcher

//Fireball Launcher


//////////////////
// Pop-Up Traps
//////////////////

//Spinning Blade Column
/obj/effect/trap/pop_up
	name = "loose tile"
	desc = "The edges of this tile are lifted slightly."
	icon_state = "trap_frame"
	anchored = 1
	density = 0
	trap_floor_type = null

	//This set should be kinda easy. We're just spawning an object in that has a spin animation and cuts people up. I'm tired.

/obj/effect/trap/pop_up/fire()
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/slosh.ogg', 100, 1)
	var/turf/deploy_location = get_turf(src)
	deploy_location.ChangeTurf(trap_floor_type)

/obj/effect/trap/pop_up/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_visible"

//Springtrap Buzzsaw

//Falling Log

/*
General to-do:
Make an attack_by for planks that boards over and makes the trap safe.
Same for tiles to reset it.
*/
