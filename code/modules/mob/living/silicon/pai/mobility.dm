/mob/living/silicon/pai/restrained()
	if(src.loc == shell)
		return FALSE
	..()

/mob/living/silicon/pai/proc/close_up_safe()
	/// We can't close up if already inside our shell
	if(src.loc == shell)
		return

	if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE))
		return

	if(istype(shell.loc, /obj/item/holder))
		to_chat(src, "You can't unfold while being held like this.")
		return

	if(!can_action())
		return

	close_up()

	last_special = world.time + 2 SECONDS

/mob/living/silicon/pai/proc/close_up()
	release_vore_contents()

	stop_pulling()

	/// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		H.forceMove(get_turf(src))
		forceMove(get_turf(src))

	/// Move us into the shell and move the shell to the ground.
	transform_component.transform()

	update_perspective()
	set_resting(FALSE)
	set_intentionally_resting(FALSE, TRUE)
	update_mobility()
	update_icon()
	remove_verb(src, /mob/living/silicon/pai/proc/pai_nom)
	update_chassis_actions()

/mob/living/silicon/pai/proc/open_up_safe()
	/// Don't check mobility here because while folded up, you can't move
	if(!can_action())
		return
	/// To fold out the pAI needs to be in the shell
	if(src.loc != shell)
		return

	open_up()

	last_special = world.time + 2 SECONDS

/mob/living/silicon/pai/proc/open_up()
	/// Stops unfolding in hardsuits and vore bellies, if implanted you explode out
	if(istype(shell.loc,/obj/item/hardsuit_module))
		to_chat(src, "There is no room to unfold inside this hardsuit module. You're good and stuck.")
		return FALSE
	else if(istype(shell.loc,/mob))
		var/mob/holder = shell.loc
		var/datum/belly/inside_belly = check_belly(shell)
		if(inside_belly)
			to_chat(src, "<span class='notice'>There is no room to unfold in here. You're good and stuck.</span>")
			return FALSE
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.organs)
				if(shell in affecting.implants)
					affecting.inflict_bodypart_damage(
						brute = rand(30, 50),
					)
					affecting.implants -= shell
					H.visible_message("<span class='danger'>\The [src] explodes out of \the [H]'s [affecting.name] in shower of gore!</span>")
					break
		holder.drop_item_to_ground(shell, INV_OP_FORCE)
	else if(istype(shell.loc,/obj/item/pda))
		var/obj/item/pda/holder = shell.loc
		holder.pai = null

	/// Handle the actual object stuffing via the component, essentially swapping their loc's around
	transform_component.untransform()

	update_perspective()

	var/obj/item/paicard/card = shell
	if(istype(card))
		card.screen_loc = null

	/// Possible to not be on a turf after the object stuffing, so make sure
	var/turf/T = get_turf(src)
	if(istype(T))
		src.forceMove(T)
		T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")

	add_verb(src, /mob/living/silicon/pai/proc/pai_nom)
	card.stop_displaying_hologram()
	update_icon()
	update_chassis_actions()

/// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	var/obj/item/holder/H = ..(grabber, self_drop)
	if(!istype(H))
		return

	H.icon_state = "[chassis]"
	H.update_worn_icon()
	return H

/// Handle movement speed
/mob/living/silicon/pai/movement_delay()
	return ..() + speed

/// This is a general check for if the pAI can do things such as fold in/out or perform other special actions
/// (basically if some condition should be checked upon the use of all mob abilities like closing/opening the shell it goes here instead)
/mob/living/silicon/pai/proc/can_action()
	if(world.time <= last_special)
		return FALSE

	if(is_emitter_dead())
		return FALSE

	return TRUE

/// Space movement (pAI gets one ion burst every 3 seconds)
/mob/living/silicon/pai/Process_Spacemove(movement_dir = NONE)
	. = ..()
	if(!. && src.loc != shell)
		if(world.time >= last_space_movement + 3 SECONDS)
			last_space_movement = world.time
			// place an effect for the movement
			new /obj/effect/temp_visual/pai_ion_burst(get_turf(src))
			return TRUE

/mob/living/silicon/pai/proc/can_change_shell()
	if(istype(src.loc, /mob))
		to_chat(src, "<span class='notice'>You're not able to change your shell while being held.</span>")
		return FALSE
	if(stat != CONSCIOUS)
		return FALSE
	if(!can_action())
		return FALSE
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE))
		return FALSE
	return TRUE

/mob/living/silicon/pai/base_transform(matrix/applying)
	var/matrix/to_apply = ..()

	/// No chassis means pAI is using a hologram
	var/turning_value_to_use = 0
	if(!chassis)
		turning_value_to_use = lying
	/// Handle turning
	to_apply.Turn(turning_value_to_use)

	/// Extremely lazy heuristic to see if we should shift down to appear to be, well, down.
	if(turning_value_to_use < -45 || turning_value_to_use > 45)
		to_apply.Translate(1,-6)

	return to_apply

/mob/living/silicon/pai/apply_transform(matrix/to_apply)
	animate(src, transform = to_apply, time = 1 SECONDS, flags = ANIMATION_PARALLEL)
