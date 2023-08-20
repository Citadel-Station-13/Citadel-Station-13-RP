/mob/living/silicon/pai/restrained()
	if(src.loc == shell)
		return FALSE
	..()

/mob/living/silicon/pai/proc/close_up()
	// we can't close up if already inside our shell
	if(src.loc == shell)
		return

	// we check mobility here to stop people folding up if they currently cannot move
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE))
		return

	if(istype(shell.loc, /obj/item/holder))
		to_chat(src, "You can't unfold while being held like this.")
		return

	if(!can_action())
		return

	last_special = world.time + 20

	release_vore_contents()

	stop_pulling()

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		H.forceMove(get_turf(src))
		forceMove(get_turf(src))

	// Move us into the shell and move the shell to the ground.
	transform_component.put_in_object()

	update_perspective()
	set_intentionally_resting(FALSE, TRUE)
	update_mobility()
	update_icon()
	remove_verb(src, /mob/living/silicon/pai/proc/pai_nom)

/mob/living/silicon/pai/proc/open_up()
	last_special = world.time + 20

	// stops unfolding in hardsuits and vore bellies, if implanted you explode out
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
					affecting.take_damage(rand(30,50))
					affecting.implants -= shell
					H.visible_message("<span class='danger'>\The [src] explodes out of \the [H]'s [affecting.name] in shower of gore!</span>")
					break
		holder.drop_item_to_ground(shell, INV_OP_FORCE)
	else if(istype(shell.loc,/obj/item/pda))
		var/obj/item/pda/holder = shell.loc
		holder.pai = null

	// handle the actual object stuffing via the component, essentially swapping their loc's around
	transform_component.put_in_mob()

	update_perspective()

	var/obj/item/paicard/card = shell
	if(istype(card))
		card.screen_loc = null

	// we might not actually be on a turf after the object stuffing, so make sure we are
	var/turf/T = get_turf(src)
	if(istype(T))
		src.forceMove(T)
		T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")

	add_verb(src, /mob/living/silicon/pai/proc/pai_nom)
	card.stop_displaying_hologram()
	update_icon()

// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	var/obj/item/holder/H = ..(grabber, self_drop)
	if(!istype(H))
		return

	H.icon_state = "[chassis]"
	grabber.update_inv_l_hand()
	grabber.update_inv_r_hand()
	return H

// handle movement speed
/mob/living/silicon/pai/movement_delay()
	return ..() + speed

// this is a general check for if we can do things such as fold in/out or perform other special actions
// (basically if some condition should be checked upon the use of all mob abilities like closing/opening the shell it goes here instead)
/mob/living/silicon/pai/proc/can_action()
	if(world.time <= last_special)
		return FALSE

	if(is_emitter_dead())
		return FALSE

	return TRUE

// space movement (we get one ion burst every 3 seconds)
/mob/living/silicon/pai/Process_Spacemove(movement_dir = NONE)
	. = ..()
	if(!. && src.loc != shell)
		if(world.time >= last_space_movement + 30)
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

/mob/living/silicon/pai/update_transform(animate = TRUE)
	. = ..()
	var/matrix/M = matrix()
	var/desired_scale_x = size_multiplier * icon_scale_x
	var/desired_scale_y = size_multiplier * icon_scale_y
	M.Scale(desired_scale_x, desired_scale_y)
	M.Translate(0, 16*(desired_scale_y-1))
	// no chassis means we're using a hologram
	var/turning_value_to_use = 0
	if(!chassis)
		turning_value_to_use = lying
	// handle turning
	M.Turn(turning_value_to_use)
	// extremely lazy heuristic to see if we should shift down to appear to be, well, down.
	if(turning_value_to_use < -45 || turning_value_to_use > 45)
		M.Translate(1,-6)

	if(animate)
		animate(src, transform = M, time = 1, flags = ANIMATION_PARALLEL)
	else
		transform = M
