/obj/item/deadringer
	name = "silver pocket watch"
	desc = "A fancy silver-plated digital pocket watch. Looks expensive."
	icon = 'icons/obj/deadringer.dmi'
	icon_state = "deadringer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_TIE
	origin_tech = list(TECH_ILLEGAL = 3)
	var/activated = 0
	var/timer = 0
	var/bruteloss_prev = 999999
	var/fireloss_prev = 999999
	var/mob/living/carbon/human/corpse = null
	var/mob/living/carbon/human/watchowner = null

/obj/item/deadringer/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/deadringer/Destroy() //just in case some smartass tries to stay invisible by destroying the watch
	reveal()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/deadringer/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(timer > 20)
		reveal()
		watchowner = null

/obj/item/deadringer/attack_self(var/mob/living/user as mob)
	var/mob/living/H = src.loc
	if (!istype(H, /mob/living/carbon/human))
		to_chat(H,"<font color=#4F49AF>You have no clue what to do with this thing.</font>")
		return
	if(!activated)
		if(timer == 0)
			to_chat(H, "<font color=#4F49AF>You press a small button on [src]'s side. It starts to hum quietly.</font>")
			bruteloss_prev = H.getBruteLoss()
			fireloss_prev = H.getFireLoss()
			activated = 1
			return
		else
			to_chat(H,"<font color=#4F49AF>You press a small button on [src]'s side. It buzzes a little.</font>")
			return
	if(activated)
		to_chat(H,"<font color=#4F49AF>You press a small button on [src]'s side. It stops humming.</font>")
		activated = 0
		return

/obj/item/deadringer/process(delta_time)
	if(activated)
		if (ismob(src.loc))
			var/mob/living/carbon/human/H = src.loc
			watchowner = H
			if(H.getBruteLoss() > bruteloss_prev || H.getFireLoss() > fireloss_prev)
				deathprevent()
				activated = 0
				if(watchowner.isSynthetic())
					to_chat(watchowner, "<font color=#4F49AF>You fade into nothingness! [src]'s screen blinks, being unable to copy your synthetic body!</font>")
				else
					to_chat(watchowner, "<font color=#4F49AF>You fade into nothingness, leaving behind a fake body!</font>")
				icon_state = "deadringer_cd"
				timer = 50
				return
	if(timer > 0)
		timer--
	if(timer == 20)
		reveal()
		if(corpse)
			new /obj/effect/particle_effect/smoke/chem(corpse.loc)
			qdel(corpse)
	if(timer == 0)
		icon_state = "deadringer"
	return

/obj/item/deadringer/proc/deathprevent()
	for(var/mob/living/simple_mob/D in oviewers(7, src))
		if(!D.has_AI())
			continue
		D.ai_holder.lose_target()

	watchowner.emote("deathgasp")
	watchowner.alpha = 15
	makeacorpse(watchowner)
	return

/obj/item/deadringer/proc/reveal()
	if(watchowner)
		watchowner.alpha = 255
		playsound(get_turf(src), 'sound/effects/uncloak.ogg', 35, 1, -1)
	return

/obj/item/deadringer/proc/makeacorpse(var/mob/living/carbon/human/H)
	if(H.isSynthetic())
		return
	corpse = new /mob/living/carbon/human(H.loc)
	corpse.setDNA(H.dna.Clone())
	corpse.death(1) //Kills the new mob
	var/obj/item/clothing/temp = null
	if(H.item_by_slot(SLOT_ID_UNIFORM))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/under/chameleon/changeling(corpse), SLOT_ID_UNIFORM)
		temp = corpse.item_by_slot(SLOT_ID_UNIFORM)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_UNIFORM)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_SUIT))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/suit/chameleon/changeling(corpse), SLOT_ID_SUIT)
		temp = corpse.item_by_slot(SLOT_ID_SUIT)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_SUIT)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_SHOES))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/shoes/chameleon/changeling(corpse), SLOT_ID_SHOES)
		temp = corpse.item_by_slot(SLOT_ID_SHOES)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_SHOES)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_GLOVES))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/gloves/chameleon/changeling(corpse), SLOT_ID_GLOVES)
		temp = corpse.item_by_slot(SLOT_ID_GLOVES)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_GLOVES)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_LEFT_EAR))
		temp = H.item_by_slot(SLOT_ID_LEFT_EAR)
		corpse.equip_to_slot_or_del(new temp.type(corpse), SLOT_ID_LEFT_EAR)
		temp = corpse.item_by_slot(SLOT_ID_LEFT_EAR)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_GLASSES))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/glasses/chameleon/changeling(corpse), SLOT_ID_GLASSES)
		temp = corpse.item_by_slot(SLOT_ID_GLASSES)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_GLASSES)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_MASK))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/mask/chameleon/changeling(corpse), SLOT_ID_MASK)
		temp = corpse.item_by_slot(SLOT_ID_MASK)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_MASK)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_HEAD))
		corpse.equip_to_slot_or_del(new /obj/item/clothing/head/chameleon/changeling(corpse), SLOT_ID_HEAD)
		temp = corpse.item_by_slot(SLOT_ID_HEAD)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_HEAD)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_BELT))
		corpse.equip_to_slot_or_del(new /obj/item/storage/belt/chameleon/changeling(corpse), SLOT_ID_BELT)
		temp = corpse.item_by_slot(SLOT_ID_BELT)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_BELT)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	if(H.item_by_slot(SLOT_ID_BACK))
		corpse.equip_to_slot_or_del(new /obj/item/storage/backpack/chameleon/changeling(corpse), SLOT_ID_BACK)
		temp = corpse.item_by_slot(SLOT_ID_BACK)
		var/obj/item/clothing/c_type = H.item_by_slot(SLOT_ID_BACK)
		temp.disguise(c_type.type)
		ADD_TRAIT(temp, TRAIT_ITEM_NODROP, HOLOGRAM_TRAIT)
	corpse.identifying_gender = H.identifying_gender
	corpse.flavor_texts = H.flavor_texts.Copy()
	corpse.real_name = H.real_name
	corpse.name = H.name
	corpse.set_species(corpse.dna.species)
	corpse.change_hair(H.h_style)
	corpse.change_facial_hair(H.f_style)
	corpse.change_hair_color(H.r_hair, H.g_hair, H.b_hair)
	corpse.change_facial_hair_color(H.r_facial, H.g_facial, H.b_facial)
	corpse.change_skin_color(H.r_skin, H.g_skin, H.b_skin)
	corpse.adjustFireLoss(H.getFireLoss())
	corpse.adjustBruteLoss(H.getBruteLoss())
	corpse.UpdateAppearance()
	corpse.regenerate_icons()
	for(var/obj/item/organ/internal/I in corpse.internal_organs)
		var/obj/item/organ/internal/G = I
		G.Destroy()
	return
