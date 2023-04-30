//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_gloves.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_gloves.dmi',
		)
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.9
	blood_sprite_state = "bloodyhands"
	material_weight_factor = 0
	var/wired = 0
	var/obj/item/cell/cell = 0
	var/fingerprint_chance = 0	//How likely the glove is to let fingerprints through
	var/glove_level = 2			//What "layer" the glove is on
	var/overgloves = 0			//Used by gauntlets and arm_guards
	var/punch_force = 0			//How much damage do these gloves add to a punch?
	var/punch_damtype = BRUTE	//What type of damage does this make fists be?
	body_cover_flags = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	drop_sound = 'sound/items/drop/gloves.ogg'
// todo: this is an awful way to do it but it works
	unequip_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/*/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	if(W.is_wirecutter() || istype(W, /obj/item/scalpel))
		if (clipped)
			to_chat(user, "<span class='notice'>The [src] have already been clipped!</span>")
			update_icon()
			return

		playsound(src.loc, W.tool_sound, 50, 1)
		user.visible_message("<font color='red'>[user] cuts the fingertips off of the [src].</font>","<font color='red'>You cut the fingertips off of the [src].</font>")

		clipped = 1
		name = "modified [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."
		if("exclude" in species_restricted)
			species_restricted -= SPECIES_UNATHI
			species_restricted -= SPECIES_TAJ
		return
*/

/obj/item/clothing/gloves/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	if(slot != SLOT_ID_GLOVES)
		return FALSE

	var/obj/item/clothing/gloves/G = I
	if(!istype(G))
		return FALSE

	return G.glove_level < glove_level

/obj/item/clothing/gloves/equip_on_worn_over_insert(mob/M, slot, mob/user, obj/item/I, flags)
	. = ..()

	if(!istype(I, /obj/item/clothing/gloves))
		return FALSE

	if(clothing_flags & THICKMATERIAL)
		return FALSE

	var/obj/item/clothing/gloves/G = I

	punch_force += G.punch_force

/obj/item/clothing/gloves/equip_on_worn_over_remove(mob/M, slot, mob/user, obj/item/I, flags)
	. = ..()

	if(!istype(I, /obj/item/clothing/gloves))
		return FALSE

	if(clothing_flags & THICKMATERIAL)
		return FALSE

	var/obj/item/clothing/gloves/G = I

	punch_force -= G.punch_force

/obj/item/clothing/gloves
	var/datum/unarmed_attack/special_attack = null //do the gloves have a special unarmed attack?
	var/special_attack_type = null

/obj/item/clothing/gloves/Initialize(mapload)
	. = ..()
	if(special_attack_type && ispath(special_attack_type))
		special_attack = new special_attack_type
