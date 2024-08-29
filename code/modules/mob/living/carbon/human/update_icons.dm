/**
 * * Global associative list for caching humanoid icons.
 * * Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
 */
GLOBAL_LIST_EMPTY(human_icon_cache)
GLOBAL_LIST_EMPTY(tail_icon_cache)
GLOBAL_LIST_EMPTY(light_overlay_cache)
GLOBAL_LIST_EMPTY(damage_icon_parts)

/mob/living/carbon/human
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	if(QDESTROYING(src))
		return

	stack_trace("CANARY: Old human update_icons was called.")

	update_hud()		//TODO: remove the need for this

	//Do any species specific layering updates, such as when hiding.
	update_icon_special()

/mob/living/carbon/human/update_icons_layers()
	stack_trace("CANARY: Old human update_icons_layers was called.")

/mob/living/carbon/human/update_icons_huds()
	stack_trace("CANARY: Old human update_icons_huds was called.")

//TODO: Carbon procs in my human update_icons??
/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	// todo: this is utterly shitcode and fucking stupid ~silicons
	// todo: the rest of hud code here ain't much better LOL
	var/list/obj/item/relevant = get_equipped_items(TRUE, TRUE)
	if(hud_used)
		for(var/obj/item/I as anything in relevant)
			position_hud_item(I, slot_id_by_item(I))
	if(client)
		client.screen |= relevant

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(hud_used && hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		hud_used.l_hand_hud_object.update_icon()
		hud_used.r_hand_hud_object.update_icon()

/mob/living/carbon/human/update_transform()
	var/matrix/old_matrix = transform
	var/matrix/M = matrix()

	// handle scaling first, we don't want to have massive mobs still shift to align to tile
	// when they're laying down.
	var/desired_scale_x = size_multiplier * icon_scale_x
	var/desired_scale_y = size_multiplier * icon_scale_y
	if(istype(species))
		desired_scale_x *= species.icon_scale_x
		desired_scale_y *= species.icon_scale_y
	M.Scale(desired_scale_x, desired_scale_y)
	M.Translate(0, 16 * (desired_scale_y - 1))

	// Mark atom as wide/long for ZM.
	if (desired_scale_x > 1)
		zmm_flags |= ZMM_LOOKAHEAD
	else
		zmm_flags &= ~ZMM_LOOKAHEAD
	if (desired_scale_y > 1)
		zmm_flags |= ZMM_LOOKBESIDE
	else
		zmm_flags &= ~ZMM_LOOKBESIDE

	// handle turning
	M.Turn(lying)
	// extremely lazy heuristic to see if we should shift down to appear to be, well, down.
	if(lying < -45 || lying > 45)
		M.Translate(1,-6)

	// fall faster if incapacitated
	var/anim_time = CHECK_MOBILITY(src, MOBILITY_CAN_STAND)? 3 : 1

	animate(src, transform = M, time = anim_time, flags = ANIMATION_PARALLEL)
	appearance_flags = fuzzy? (appearance_flags & ~(PIXEL_SCALE)) : (appearance_flags | PIXEL_SCALE)
	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_TRANSFORM, old_matrix, M)
	update_icon_special() //May contain transform-altering things
	update_ssd_overlay()


/* --------------------------------------- */
//Recomputes every icon on the mob. Expensive.
//Useful if the species changed, or there's some
//other drastic body-shape change, but otherwise avoid.
/mob/living/carbon/human/regenerate_icons()
	..()
	update_icons_body()
	update_damage_overlay()
	update_mutations()
	update_skin()
	update_underwear()
	update_hair()
	update_inv_w_uniform()
	update_inv_wear_id()
	update_inv_gloves()
	update_inv_glasses()
	update_inv_ears()
	update_inv_shoes()
	update_inv_s_store()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_wear_suit()
	update_inv_r_hand()
	update_inv_l_hand()
	update_handcuffed()
	update_inv_legcuffed()
	//update_inv_pockets() //Doesn't do anything
	update_fire()
	update_water()
	update_acidsub()
	update_bloodsub()
	update_surgery()

// TODO - Move this to where it should go ~Leshana
/mob/proc/stop_flying()
	if(QDESTROYING(src))
		return
	flying = FALSE
	return 1

/mob/living/carbon/human/stop_flying()
	if((. = ..()))
		render_spriteacc_wings()

//Stolen from bay for shifting equipment by default and not having to resprite it
/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = (PIXEL_SCALE) | flags
	return ret
