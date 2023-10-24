/obj/item/melee/cultblade
	name = "cult blade"
	desc = "An arcane weapon wielded by the followers of Nar-Sie."
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 1, TECH_ARCANE = 1)
	w_class = ITEMSIZE_LARGE
	damage_force = 30
	throw_force = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	edge = 1
	sharp = 1

/obj/item/melee/cultblade/cultify()
	return

/obj/item/melee/cultblade/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(iscultist(user) && !istype(user, /mob/living/simple_mob/construct))
		return ..()
	if(!isliving(user))
		return ..()
	var/mob/living/L = user

	var/zone = (L.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, "<span class='danger'>An inexplicable force rips through your [affecting.name], tearing the sword from your grasp!</span>")
		//random amount of damage between half of the blade's force and the full force of the blade.
		H.apply_damage(rand(damage_force/2, damage_force), BRUTE, zone, 0, sharp=1, edge=1)
		H.afflict_paralyze(20 * 5)
	else if(!istype(user, /mob/living/simple_mob/construct))
		to_chat(user, "<span class='danger'>An inexplicable force rips through you, tearing the sword from your grasp!</span>")
	else
		to_chat(user, "<span class='critical'>The blade hisses, forcing itself from your manipulators. \The [src] will only allow mortals to wield it against foes, not kin.</span>")

	user.drop_item_to_ground(src)
	throw_at_old(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/melee/cultblade/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	if(!iscultist(user) && !istype(user, /mob/living/simple_mob/construct))
		to_chat(user, "<span class='warning'>An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly.</span>")
		user.make_dizzy(120)
	if(istype(user, /mob/living/simple_mob/construct))
		to_chat(user, "<span class='warning'>\The [src] hisses, as it is discontent with your acquisition of it. It would be wise to return it to a worthy mortal quickly.</span>")

/obj/item/clothing/head/cult
	name = "cult hood"
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "culthood"
	desc = "A hood worn by the followers of Nar-Sie."
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	inv_hide_flags = HIDEFACE
	body_cover_flags = HEAD
	armor_type = /datum/armor/cult/robes
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/cult/cultify()
	return

/obj/item/clothing/head/cult/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	inv_hide_flags = HIDEFACE | BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/cult/alt
	icon_state = "culthoodalt"

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie."
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "cultrobes"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/book/tome,/obj/item/melee/cultblade)
	armor_type = /datum/armor/cult/robes
	inv_hide_flags = HIDEJUMPSUIT
	siemens_coefficient = 0
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/cultrobes/cultify()
	return

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/magus
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie."
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "magusred"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/cultrobes/magus/blue
	icon_state = "magusblue"

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of Nar-Sie."
	icon = 'icons/clothing/suit/armor/cult.dmi'
	icon_state = "culthelm"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	armor_type = /datum/armor/cult/space
	encumbrance = ITEM_ENCUMBRANCE_CULT_VOIDSUIT_HELMET
	weight = ITEM_WEIGHT_CULT_VOIDSUIT_HELMET
	siemens_coefficient = 0
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/helmet/space/cult/cultify()
	return

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	icon = 'icons/clothing/suit/armor/cult.dmi'
	icon_state = "cult"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	desc = "A bulky suit of armour, bristling with spikes. It looks space-worthy."
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/book/tome,/obj/item/melee/cultblade,/obj/item/tank/emergency/oxygen,/obj/item/suit_cooling_unit)
	weight = ITEM_WEIGHT_CULT_VOIDSUIT
	encumbrance = ITEM_ENCUMBRANCE_CULT_VOIDSUIT
	armor_type = /datum/armor/cult/space
	siemens_coefficient = 0
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/space/cult/cultify()
	return
