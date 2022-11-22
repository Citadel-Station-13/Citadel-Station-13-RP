/**
 * * Global associative list for caching humanoid icons.
 * * Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
 */
GLOBAL_LIST_EMPTY(human_icon_cache)
GLOBAL_LIST_EMPTY(tail_icon_cache)
GLOBAL_LIST_EMPTY(light_overlay_cache)
GLOBAL_LIST_EMPTY(damage_icon_parts)

////////////////////////////////////////////////////////////////////////////////////////////////
// # Human Icon Updating System
//
// This system takes care of the "icon" for human mobs.  Of course humans don't just have a single
// icon+icon_state, but a combination of dozens of little sprites including including the body,
// clothing, equipment, in-universe HUD images, etc.
//
// # Basic Operation
// Whenever you do something that should update the on-mob appearance of a worn or held item, You
// will need to call the relevant update_inv_* proc. All of these are named after the variable they
// update from. They are defined at the /mob level so you don't even need to cast to carbon/human.
//
// The new system leverages SSoverlays to actually add/remove the overlays from mob.overlays
// Since SSoverlays already manages batching updates to reduce apperance churn etc, we don't need
// to worry about that.  (In short, you can call add/cut overlay as many times as you want, it will
// only get assigned to the mob once per tick.)
// As a corrolary, this means users of this system do NOT need to tell the system when you're done
// making changes.
//
// There are also these special cases:
//  update_icons_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
//  UpdateDamageIcon()	//Handles damage overlays for brute/burn damage //(will rename this when I geta round to it) ~Carn
//  update_skin()		//Handles updating skin for species that have a skin overlay.
//  update_bloodied()	//Handles adding/clearing the blood overlays for hands & feet.  Call when bloodied or cleaned.
//  update_underwear()	//Handles updating the sprite for underwear.
//  update_hair()		//Handles updating your hair and eyes overlay
//  update_mutations()	//Handles updating your appearance for certain mutations.  e.g MUTATION_TELEKINESIS head-glows
//  update_fire()		//Handles overlay from being on fire.
//  update_water()		//Handles overlay from being submerged.
//  update_surgery()	//Handles overlays from open external organs.
//
// # History (i.e. I'm used to the old way, what is different?)
// You used to have to call update_icons(FALSE) if you planned to make more changes, and call update_icons(TRUE)
// on the final update.  All that is gone, just call update_inv_whatever() and it handles the rest.
//
////////////////////////////////////////////////////////////////////////////////////////////////

//Add an entry to overlays, assuming it exists
/mob/living/carbon/human/proc/apply_layer(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)

//Remove an entry from overlays, and from the list
/mob/living/carbon/human/proc/remove_layer(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null

/**
 * applies a layer while cutting the old one
 *
 * overlays can be a single overlay or a list.
 */
/mob/living/carbon/human/proc/render_layer(cache_index, overlays)
	if(overlays_standing[cache_index])
		cut_overlay(overlays_standing[cache_index])
	overlays_standing[cache_index] = overlays
	if(!overlays)
		return
	add_overlay(overlays_standing[cache_index])

/**
 * applies a layer while cutting the old one
 * you are responsible for making sure emissive renderer exists
 *
 * overlays can be a single overlay or a list.
 */
/mob/living/carbon/human/proc/render_emissive_layer(cache_index, overlays)
	if(overlays_standing[cache_index])
		em_render?.cut_overlay(overlays_standing[cache_index])
	overlays_standing[cache_index] = overlays
	if(!overlays)
		return
	em_render?.add_overlay(overlays_standing[cache_index])

/mob/living/carbon/human
	var/list/overlays_standing[HUMAN_OVERLAY_TOTAL]
	var/list/emissives_standing[HUMAN_OVERLAY_TOTAL]
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

/mob/living/carbon/human/update_transform()
	var/desired_scale_x = size_multiplier * icon_scale_x
	var/desired_scale_y = size_multiplier * icon_scale_y
	if(istype(species))
		desired_scale_x *= species.icon_scale_x
		desired_scale_y *= species.icon_scale_y

	var/matrix/M = matrix()
	var/anim_time = 3

	//Due to some involuntary means, you're laying now
	if(lying && !resting && !sleeping)
		anim_time = 1 //Thud

	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		var/randn = rand(1, 2)
		if(randn <= 1) // randomly choose a rotation
			M.Turn(-90)
		else
			M.Turn(90)
		M.Scale(desired_scale_y, desired_scale_x)
		M.Translate(1,-6)
		set_base_layer(MOB_LAYER - 0.01)
	else
		M.Scale(desired_scale_x, desired_scale_y)
		M.Translate(0, 16*(desired_scale_y-1))
		set_base_layer(MOB_LAYER)

	animate(src, transform = M, time = anim_time)
	update_icon_special() //May contain transform-altering things

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_DAMAGE)

	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/image/standing_image = image(icon = species.damage_overlays, icon_state = "00", layer = BODY_LAYER+DAMAGE_LAYER)

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.get_blood_colour(src)]/[species.get_bodytype_legacy(src)]"
		if(GLOB.damage_icon_parts[cache_index] == null)
			DI = icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.get_blood_colour(src), ICON_MULTIPLY)
			GLOB.damage_icon_parts[cache_index] = DI
		else
			DI = GLOB.damage_icon_parts[cache_index]

		standing_image.overlays += DI

	overlays_standing[HUMAN_OVERLAY_DAMAGE]	= standing_image
	apply_layer(HUMAN_OVERLAY_DAMAGE)

//BASE MOB SPRITE
/mob/living/carbon/human/update_icons_body()
	if(QDESTROYING(src) || !(flags & INITIALIZED))
		return

	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (MUTATION_HUSK in src.mutations)
	var/fat = (MUTATION_FAT in src.mutations)
	var/hulk = (MUTATION_HULK in src.mutations)
	var/skeleton = (MUTATION_SKELETON in src.mutations)

	robolimb_count = 0 //TODO, here, really tho?
	robobody_count = 0

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	var/icon/stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")

	var/g = gender == FEMALE ? "f" : "m"
	/* 	This was the prior code before the above line. It was faulty and has been commented out.
	var/g = "male"
	if(gender == FEMALE)
		g = "female"
	*/

	var/icon_key = "[species.get_race_key(src)][g][s_tone][r_skin][g_skin][b_skin]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "[r_eyes], [g_eyes], [b_eyes]"

	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	if(head)
		if(!istype(head, /obj/item/organ/external/stump))
			icon_key += "[head.eye_icon]"
	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		// Allowing tails to prevent bodyparts rendering, granting more spriter freedom for taur/digitigrade stuff.
		if(isnull(part) || part.is_stump() || part.is_hidden_by_tail())
			icon_key += "0"
			continue
		if(part)
			icon_key += "[part.species.get_race_key(part.owner)]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			icon_key += "[part.s_tone]"
			if(part.s_col && part.s_col.len >= 3)
				icon_key += "[rgb(part.s_col[1],part.s_col[2],part.s_col[3])]"
			if(part.body_hair && part.h_col && part.h_col.len >= 3)
				icon_key += "[rgb(part.h_col[1],part.h_col[2],part.h_col[3])]"
				if(species.color_force_greyscale)
					icon_key += "_ags"
				if(species.color_mult)
					icon_key += "[ICON_MULTIPLY]"
				else
					icon_key += "[ICON_ADD]"
			else
				icon_key += "#000000"
			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]["color"]]"

			if(part.robotic >= ORGAN_ROBOT)
				icon_key += "2[part.model ? "-[part.model]": ""]"
				robolimb_count++
				if((part.robotic == ORGAN_ROBOT || part.robotic == ORGAN_LIFELIKE) && (part.organ_tag == BP_HEAD || part.organ_tag == BP_TORSO || part.organ_tag == BP_GROIN))
					robobody_count ++
			else if(part.status & ORGAN_DEAD)
				icon_key += "3"
			else
				icon_key += "1"
			if(part.transparent)
				icon_key += "_t"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0]"

	var/icon/base_icon
	if(GLOB.human_icon_cache[icon_key])
		base_icon = GLOB.human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_TORSO)
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in organs)
			if(isnull(part) || part.is_stump() || part.is_hidden_by_tail())
				continue
			var/icon/temp = part.get_icon(skeleton)
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position & (LEFT | RIGHT))
				var/icon/temp2 = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")
				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else if(part.icon_position & UNDER)
				base_icon.Blend(temp, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		// Handle husk overlay.
		if(husk)
			var/husk_icon = species.get_husk_icon(src)
			if(husk_icon)
				var/icon/mask = new(base_icon)
				var/icon/husk_over = new(species.husk_icon,"")
				mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
				husk_over.Blend(mask, ICON_ADD)
				base_icon.Blend(husk_over, ICON_OVERLAY)

		GLOB.human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)
	icon = stand_icon

	//tail
	update_tail_showing()
	update_wing_showing()

/mob/living/carbon/human/proc/update_skin()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_SKIN)

	var/image/skin = species.update_skin(src)
	if(skin)
		skin.layer = BODY_LAYER+SKIN_LAYER
		overlays_standing[HUMAN_OVERLAY_SKIN] = skin
		apply_layer(HUMAN_OVERLAY_SKIN)

/mob/living/carbon/human/proc/update_bloodied()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_BLOOD)
	if(!blood_DNA && !feet_blood_DNA)
		return

	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = BODY_LAYER+BLOOD_LAYER)

	//Bloody hands
	if(blood_DNA)
		var/image/bloodsies	= image(icon = species.get_blood_mask(src), icon_state = "bloodyhands", layer = BODY_LAYER+BLOOD_LAYER)
		bloodsies.color = hand_blood_color
		both.add_overlay(bloodsies)

	//Bloody feet
	if(feet_blood_DNA)
		var/image/bloodsies = image(icon = species.get_blood_mask(src), icon_state = "shoeblood", layer = BODY_LAYER+BLOOD_LAYER)
		bloodsies.color = feet_blood_color
		both.add_overlay(bloodsies)

	overlays_standing[HUMAN_OVERLAY_BLOOD] = both

	apply_layer(HUMAN_OVERLAY_BLOOD)

//UNDERWEAR OVERLAY
/mob/living/carbon/human/proc/update_underwear()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_UNDERWEAR)

	if(species.species_appearance_flags & HAS_UNDERWEAR)
		overlays_standing[HUMAN_OVERLAY_UNDERWEAR] = list()
		for(var/category in all_underwear)
			if(hide_underwear[category])
				continue
			var/datum/category_item/underwear/UWI = all_underwear[category]
			var/image/wear = UWI.generate_image(all_underwear_metadata[category], layer = BODY_LAYER+UNDERWEAR_LAYER)
			overlays_standing[HUMAN_OVERLAY_UNDERWEAR] += wear

		apply_layer(HUMAN_OVERLAY_UNDERWEAR)

/mob/living/carbon/human/update_eyes()
	if(QDESTROYING(src))
		return

	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		eyes.update_colour()
		update_icons_body()

	//Reset our eyes
	remove_layer(HUMAN_OVERLAY_EYES)

	//TODO: Probably redo this. I know I wrote it, but...

	//This is ONLY for glowing eyes for now. Boring flat eyes are done by the head's own proc.
	if(!species.has_glowing_eyes)
		return

	//Our glowy eyes should be hidden if some equipment hides them.
	if(!should_have_organ(O_EYES) || (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		return

	//Get the head, we'll need it later.
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		return

	//The eyes store the color themselves, funny enough.
	if(!head_organ.eye_icon)
		return

	#warn emissives this shit
	var/icon/eyes_icon = new/icon(head_organ.eye_icon_location, head_organ.eye_icon)
	if(eyes)
		eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
	else
		eyes_icon.Blend(rgb(128,0,0), ICON_ADD)

	var/image/eyes_image = image(eyes_icon)
	eyes_image.plane = ABOVE_LIGHTING_PLANE

	overlays_standing[HUMAN_OVERLAY_EYES] = eyes_image
	apply_layer(HUMAN_OVERLAY_EYES)

/mob/living/carbon/human/update_mutations()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_MUTATIONS)

	if(!LAZYLEN(mutations))
		return //No mutations, no icons.

	//TODO: THIS PROC???
	var/fat
	if(MUTATION_FAT in mutations)
		fat = "fat"

	var/image/standing	= image(icon = 'icons/effects/genetics.dmi', layer = BODY_LAYER+MUTATIONS_LAYER)
	var/g = gender == FEMALE ? "f" : "m"

	for(var/datum/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay = gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay

	for(var/mut in mutations)
		if(mut == MUTATION_LASER)
			standing.overlays += "lasereyes_s" //TODO

	overlays_standing[HUMAN_OVERLAY_MUTATIONS]	= standing
	apply_layer(HUMAN_OVERLAY_MUTATIONS)

/* --------------------------------------- */
//Recomputes every icon on the mob. Expensive.
//Useful if the species changed, or there's some
//other drastic body-shape change, but otherwise avoid.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(transforming || QDELETED(src))
		return

	update_icons_body()
	UpdateDamageIcon()
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

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_UNIFORM)

	//Shoes can be affected by uniform being drawn onto them
	update_inv_shoes()

	if(!w_uniform)
		return

	if(wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT) && !istype(wear_suit, /obj/item/clothing/suit/space/rig))
		return //Wearing a suit that prevents uniform rendering

	//Build a uniform sprite
	var/icon/c_mask = peek_sprite_accessory_tail()?.accessory.clip_mask
	if(c_mask)
		var/obj/item/clothing/suit/S = wear_suit
		if((wear_suit?.flags_inv & HIDETAIL) || (istype(S) && S.taurized)) // Reasons to not mask: 1. If you're wearing a suit that hides the tail or if you're wearing a taurized suit.
			c_mask = null
	var/list/MA_or_list = w_uniform.render_mob_appearance(src, SLOT_ID_UNIFORM, species.get_effective_bodytype(src, w_uniform, SLOT_ID_UNIFORM))

	if(c_mask)
		if(islist(MA_or_list))
			for(var/mutable_appearance/MA2 as anything in MA_or_list)
				MA2.filters += filter(type = "alpha", icon = c_mask)
		else
			var/mutable_appearance/MA = MA_or_list
			MA.filters += filter(type = "alpha", icon = c_mask)
	overlays_standing[HUMAN_OVERLAY_UNIFORM] = MA_or_list

	apply_layer(HUMAN_OVERLAY_UNIFORM)

/mob/living/carbon/human/update_inv_wear_id()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_ID)

	if(!wear_id)
		return //Not wearing an ID

	//Only draw the ID on the mob if the uniform allows for it
	if(w_uniform && istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(U.displays_id)
			overlays_standing[HUMAN_OVERLAY_ID] = wear_id.render_mob_appearance(src, SLOT_ID_WORN_ID, species.get_effective_bodytype(src, wear_id, SLOT_ID_WORN_ID))

	apply_layer(HUMAN_OVERLAY_ID)

/mob/living/carbon/human/update_inv_gloves()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_GLOVES)

	if(!gloves)
		return //No gloves, no reason to be here.

	overlays_standing[HUMAN_OVERLAY_GLOVES]	= gloves.render_mob_appearance(src, SLOT_ID_GLOVES, species.get_effective_bodytype(src, gloves, SLOT_ID_GLOVES))

	apply_layer(HUMAN_OVERLAY_GLOVES)

/mob/living/carbon/human/update_inv_glasses()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_GLASSES)

	if(!glasses)
		return //Not wearing glasses, no need to update anything.

	overlays_standing[HUMAN_OVERLAY_GLASSES] = glasses.render_mob_appearance(src, SLOT_ID_GLASSES, species.get_effective_bodytype(src, glasses, SLOT_ID_GLASSES))

	apply_layer(HUMAN_OVERLAY_GLASSES)

/mob/living/carbon/human/update_inv_ears()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_EARS)

	if((head && head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)) || (wear_mask && wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)))
		return //Ears are blocked (by hair being blocked, overloaded)

	if(!l_ear && !r_ear)
		return //Why bother, if no ear sprites

	// Blank image upon which to layer left & right overlays.
	var/list/mutable_appearance/both = list()
	if(l_ear)
		both += l_ear.render_mob_appearance(src, SLOT_ID_LEFT_EAR, species.get_effective_bodytype(src, l_ear, SLOT_ID_LEFT_EAR))
	if(r_ear)
		both += r_ear.render_mob_appearance(src, SLOT_ID_RIGHT_EAR, species.get_effective_bodytype(src, r_ear, SLOT_ID_RIGHT_EAR))

	overlays_standing[HUMAN_OVERLAY_EARS] = both
	apply_layer(HUMAN_OVERLAY_EARS)

/mob/living/carbon/human/update_inv_shoes()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_SHOES)

	if(!shoes || (wear_suit && wear_suit.flags_inv & HIDESHOES) || (w_uniform && w_uniform.flags_inv & HIDESHOES))
		return //Either nothing to draw, or it'd be hidden.

	for(var/f in list(BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/foot/foot = get_organ(f)
		if(istype(foot) && foot.is_hidden_by_tail()) //If either foot is hidden by the tail, don't render footwear.
			return

	//NB: the use of a var for the layer on this one
	overlays_standing[HUMAN_OVERLAY_SHOES] = shoes.render_mob_appearance(src, SLOT_ID_SHOES, species.get_effective_bodytype(src, shoes, SLOT_ID_SHOES))

	apply_layer(HUMAN_OVERLAY_SHOES)

/mob/living/carbon/human/update_inv_s_store()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_SUIT_STORE)

	if(!s_store)
		return //Why bother, nothing there.

	//TODO, this is unlike the rest of the things
	//Basically has no variety in slot icon choices at all. WHY SPECIES ONLY??
	var/t_state = s_store.item_state
	if(!t_state)
		t_state = s_store.icon_state
	overlays_standing[HUMAN_OVERLAY_SUIT_STORE]	= image(icon = species.suit_storage_icon, icon_state = t_state, layer = BODY_LAYER+SUIT_STORE_LAYER)

	apply_layer(HUMAN_OVERLAY_SUIT_STORE)

/mob/living/carbon/human/update_inv_head()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_HEAD)

	if(!head)
		return //No head item, why bother.

	overlays_standing[HUMAN_OVERLAY_HEAD] = head.render_mob_appearance(src, SLOT_ID_HEAD, species.get_effective_bodytype(src, head, SLOT_ID_HEAD))

	apply_layer(HUMAN_OVERLAY_HEAD)

/mob/living/carbon/human/update_inv_belt()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_BELT)

	if(!belt)
		return //No belt, why bother.

	//NB: this uses a var from above
	overlays_standing[HUMAN_OVERLAY_BELT] = belt.render_mob_appearance(src, SLOT_ID_BELT, species.get_effective_bodytype(src, belt, SLOT_ID_BELT))

	apply_layer(HUMAN_OVERLAY_BELT)

/mob/living/carbon/human/update_inv_wear_suit()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_SUIT)

	//Hide/show other layers if necessary
	update_inv_w_uniform()
	update_inv_shoes()
	update_tail_showing()
	update_wing_showing()

	if(!wear_suit)
		return //No point, no suit.

	// Part of splitting the suit sprites up

	var/icon/c_mask = null
	var/tail_is_rendered = (overlays_standing[TAIL_LAYER] || overlays_standing[TAIL_LAYER_ALT])
	var/valid_clip_mask = peek_sprite_accessory_tail()?.accessory.clip_mask

	var/obj/item/clothing/suit/S = wear_suit
	if(tail_is_rendered && valid_clip_mask && !(istype(S) && S.taurized)) //Clip the lower half of the suit off using the tail's clip mask for taurs since taur bodies aren't hidden.
		c_mask = valid_clip_mask
	var/list/MA_or_list = wear_suit.render_mob_appearance(src, SLOT_ID_SUIT, species.get_effective_bodytype(src, wear_suit, SLOT_ID_SUIT))
	if(c_mask)
		if(islist(MA_or_list))
			for(var/mutable_appearance/MA2 as anything in MA_or_list)
				MA2.filters += filter(type = "alpha", icon = c_mask)
		else
			var/mutable_appearance/MA = MA_or_list
			MA.filters += filter(type = "alpha", icon = c_mask)
	overlays_standing[HUMAN_OVERLAY_SUIT] = MA_or_list

	apply_layer(HUMAN_OVERLAY_SUIT)

/mob/living/carbon/human/update_inv_wear_mask()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_MASK)

	if(!wear_mask || (head && head.flags_inv & HIDEMASK))
		return //Why bother, nothing in mask slot.

	overlays_standing[HUMAN_OVERLAY_MASK] = wear_mask.render_mob_appearance(src, SLOT_ID_MASK, species.get_effective_bodytype(src, wear_mask, SLOT_ID_MASK))

	apply_layer(HUMAN_OVERLAY_MASK)

/mob/living/carbon/human/update_inv_back()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_BACK)

	if(!back)
		return //Why do anything

	overlays_standing[HUMAN_OVERLAY_BACK] = back.render_mob_appearance(src, SLOT_ID_BACK, species.get_effective_bodytype(src, back, SLOT_ID_BACK))

	apply_layer(HUMAN_OVERLAY_BACK)

//TODO: Carbon procs in my human update_icons??
/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(QDESTROYING(src))
		return
	// todo: this is utterly shitcode and fucking stupid ~silicons
	// todo: the rest of hud code here ain't much better LOL
	var/list/obj/item/relevant = get_equipped_items(TRUE, TRUE)
	if(hud_used)
		for(var/obj/item/I as anything in relevant)
			position_hud_item(I, slot_by_item(I))
	if(client)
		client.screen |= relevant

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(QDESTROYING(src))
		return

	if(hud_used && hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		hud_used.l_hand_hud_object.update_icon()
		hud_used.r_hand_hud_object.update_icon()

/mob/living/carbon/human/update_handcuffed()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_HANDCUFFS)
	update_hud_handcuffed() //TODO

	if(!handcuffed)
		return //Not cuffed, why bother

	overlays_standing[HUMAN_OVERLAY_HANDCUFFS] = handcuffed.render_mob_appearance(src, SLOT_ID_HANDCUFFED, species.get_effective_bodytype(src, handcuffed, SLOT_ID_HANDCUFFED))

	apply_layer(HUMAN_OVERLAY_HANDCUFFS)

/mob/living/carbon/human/update_inv_legcuffed()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_LEGCUFFS)

	if(!legcuffed)
		return //Not legcuffed, why bother.

	overlays_standing[HUMAN_OVERLAY_LEGCUFFS] = legcuffed.render_mob_appearance(src, SLOT_ID_LEGCUFFED, species.get_effective_bodytype(src, legcuffed, SLOT_ID_LEGCUFFED))

	apply_layer(HUMAN_OVERLAY_LEGCUFFS)

/mob/living/carbon/human/update_inv_r_hand()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_R_HAND)

	if(!r_hand)
		return //No hand, no bother.

	overlays_standing[HUMAN_OVERLAY_R_HAND] = r_hand.render_mob_appearance(src, 2, BODYTYPE_DEFAULT)

	apply_layer(HUMAN_OVERLAY_R_HAND)

/mob/living/carbon/human/update_inv_l_hand()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_L_HAND)

	if(!l_hand)
		return //No hand, no bother.

	overlays_standing[HUMAN_OVERLAY_L_HAND] = l_hand.render_mob_appearance(src, 1, BODYTYPE_DEFAULT)

	apply_layer(HUMAN_OVERLAY_L_HAND)

/mob/living/carbon/human/update_modifier_visuals()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_MODIFIER_EFFECTS)

	if(!LAZYLEN(modifiers))
		return //No modifiers, no effects.

	var/image/effects = new()
	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image(icon = 'icons/mob/modifier_effects.dmi', icon_state = M.mob_overlay_state)
			effects.overlays += I //TODO, this compositing is annoying.

	overlays_standing[HUMAN_OVERLAY_MODIFIER_EFFECTS] = effects

	apply_layer(HUMAN_OVERLAY_MODIFIER_EFFECTS)

/mob/living/carbon/human/update_fire()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_FIRE)

	if(!on_fire)
		return

	overlays_standing[HUMAN_OVERLAY_FIRE] = image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state(), layer = BODY_LAYER+FIRE_LAYER)

	apply_layer(HUMAN_OVERLAY_FIRE)

/mob/living/carbon/human/update_water()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_WATER)

	var/depth = check_submerged()
	if(!depth || lying)
		return
	if(depth < 3)
		overlays_standing[HUMAN_OVERLAY_WATER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "human_swimming_[depth]", layer = BODY_LAYER+MOB_WATER_LAYER) //TODO: Improve
		apply_layer(HUMAN_OVERLAY_WATER)
	if(depth == 4)
		overlays_standing[HUMAN_OVERLAY_WATER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "hacid_1", layer = BODY_LAYER+MOB_WATER_LAYER)
		apply_layer(HUMAN_OVERLAY_WATER)
	if(depth == 5)
		overlays_standing[HUMAN_OVERLAY_WATER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "hacid_2", layer = BODY_LAYER+MOB_WATER_LAYER)
		apply_layer(HUMAN_OVERLAY_WATER)
	if(depth == 6)
		overlays_standing[HUMAN_OVERLAY_WATER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "hblood_1", layer = BODY_LAYER+MOB_WATER_LAYER)
		apply_layer(HUMAN_OVERLAY_WATER)
	if(depth == 7)
		overlays_standing[HUMAN_OVERLAY_WATER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "hblood_2", layer = BODY_LAYER+MOB_WATER_LAYER)
		apply_layer(HUMAN_OVERLAY_WATER)

/mob/living/carbon/human/proc/update_surgery()
	if(QDESTROYING(src))
		return

	remove_layer(HUMAN_OVERLAY_SURGERY)

	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image(icon = 'icons/mob/surgery.dmi',  icon_state = "[E.icon_name][round(E.open)]", layer = BODY_LAYER+SURGERY_LAYER)
			total.overlays += I //TODO: This compositing is annoying

	if(total.overlays.len)
		overlays_standing[HUMAN_OVERLAY_SURGERY] = total
		apply_layer(HUMAN_OVERLAY_SURGERY)

// TODO - Move this to where it should go ~Leshana
/mob/proc/stop_flying()
	if(QDESTROYING(src))
		return
	flying = FALSE
	return 1

/mob/living/carbon/human/stop_flying()
	if((. = ..()))
		update_wing_showing()

//Stolen from bay for shifting equipment by default and not having to resprite it
/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = (PIXEL_SCALE) | flags
	return ret

//! new wip overlay system ; elevate to /mob someday maybe if it isn't replaced
/**
 * you are responsible for storing what to cut
 */
/mob/living/carbon/human/proc/cut_render_overlays(overlays)
	cut_overlay(overlays)

/**
 * you are responsible for cutting it later; we do not store it.
 */
/mob/living/carbon/human/proc/add_render_overlays(overlays)
	add_overlay(overlays)

/**
 * you are responsible for making sure em render is there
 * you are responsible for storing what to cut
 */
/mob/living/carbon/human/proc/cut_emissive_overlays(overlays)
	em_render?.cut_overlay(overlays)

/**
 * you are responsible for making sure em render is there
 * you are responsible for cutting it later; we do not store it.
 */
/mob/living/carbon/human/proc/add_emissive_overlays(overlays)
	em_render?.add_overlay(overlays)

/**
 * checks if we have em render
 * if we don't, add it and regen icons
 */
/mob/living/carbon/human/proc/emissive_assert_relevance()
	if(em_render)
		return
	add_emissive_render()
	regenerate_icons()

//! sprite accessories
/mob/living/carbon/human/update_hair()
	var/datum/sprite_accessory_data/data = peek_sprite_accessory_hair()
	if(cache_hair_overlays)
		cut_render_overlays(cache_hair_overlays)
	if(cache_hair_emissives)
		cut_emissive_overlays(cache_hair_emissives)
	if(!data)
		return
	var/list/normal = data.render_mob_appearance(src)
	var/list/emissives = data.render_mob_emissives(src)
	if(normal)
		add_render_overlays(normal)
		cache_hair_overlays = emissives
	if(emissives)
		add_emissive_overlays(emissives)
		cache_hair_emissives = emissives

/mob/living/carbon/human/update_facial_hair()
	var/datum/sprite_accessory_data/data = peek_sprite_accessory_facial_hair()
	if(cache_facial_hair_overlays)
		cut_render_overlays(cache_facial_hair_overlays)
	if(cache_facial_hair_emissives)
		cut_emissive_overlays(cache_facial_hair_emissives)
	if(!data)
		return
	var/list/normal = data.render_mob_appearance(src)
	var/list/emissives = data.render_mob_emissives(src)
	if(normal)
		add_render_overlays(normal)
		cache_facial_hair_overlays = emissives
	if(emissives)
		add_emissive_overlays(emissives)
		cache_facial_hair_emissives = emissives

/mob/living/carbon/human/update_tail()
	var/datum/sprite_accessory_data/data = peek_sprite_accessory_tail()
	if(cache_tail_overlays)
		cut_render_overlays(cache_tail_overlays)
	if(cache_tail_emissives)
		cut_emissive_overlays(cache_tail_emissives)
	if(!data)
		return
	var/list/normal = data.render_mob_appearance(src)
	var/list/emissives = data.render_mob_emissives(src)
	if(normal)
		add_render_overlays(normal)
		cache_tail_overlays = emissives
	if(emissives)
		add_emissive_overlays(emissives)
		cache_tail_emissives = emissives

/mob/living/carbon/human/update_ears()
	var/datum/sprite_accessory_data/data1 = peek_sprite_accessory_ears_1()
	var/datum/sprite_accessory_data/data2 = peek_sprite_accessory_ears_2()
	if(cache_ears_1_overlays)
		cut_render_overlays(cache_ears_1_overlays)
	if(cache_ears_2_overlays)
		cut_render_overlays(cache_ears_2_overlays)
	if(cache_ears_1_emissives)
		cut_emissive_overlays(cache_ears_1_emissives)
	if(cache_ears_2_emissives)
		cut_emissive_overlays(cache_ears_2_emissives)
	if(data1)
		var/list/normal = data1.render_mob_appearance(src)
		var/list/emissives = data1.render_mob_emissives(src)
		if(normal)
			add_render_overlays(normal)
			cache_ears_1_overlays = normal
		if(emissives)
			add_render_overlays(emissives)
			cache_ears_1_emissives = emissives
	if(data2)
		var/list/normal = data2.render_mob_appearance(src)
		var/list/emissives = data2.render_mob_emissives(src)
		if(normal)
			add_render_overlays(normal)
			cache_ears_2_overlays = normal
		if(emissives)
			add_render_overlays(emissives)
			cache_ears_2_emissives = emissives

/mob/living/carbon/human/update_wings()
	var/datum/sprite_accessory_data/data = peek_sprite_accessory_wings()
	if(cache_wing_overlays)
		cut_render_overlays(cache_wing_overlays)
	if(cache_wing_emissives)
		cut_emissive_overlays(cache_wing_emissives)
	if(!data)
		return
	var/list/normal = data.render_mob_appearance(src)
	var/list/emissives = data.render_mob_emissives(src)
	if(normal)
		add_render_overlays(normal)
		cache_wing_overlays = emissives
	if(emissives)
		add_emissive_overlays(emissives)
		cache_wing_emissives = emissives

/mob/living/carbon/human/update_markings()
	update_icons_body()
