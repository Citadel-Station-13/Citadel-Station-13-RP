// Blob simple_mobs generally get made from the blob random event.
// They're considered slimes for the purposes of attack bonuses from certain weapons.

// Do not spawn, this is a base type.

/datum/category_item/catalogue/fauna/blob
	name = "Blob"
	desc = "Blobs are transient space hazards often encountered on the Frontier. \
	Every Blob starts out as a Seed, which either hosts inside of an unwitting victim, \
	or simply hurtles through space until it collides with an obstacle. Upon impact or \
	'hatching', depending on species, a Blob's seed casing splits open to reveal its gelatinous \
	core. Powerful and dense, Blobs replicate rapidly in most environments, spreading to envelop \
	inorganic and organic matter alike. Blobs are able to produce harvesting factories which pull \
	nutrients out of the air and local enveloped items. They are also able to generate ambulatory \
	spores which can come to aid the Blob Core in its defense. A Blob which successfully reaches \
	critical mass will produce more seeds, and jettison them off blindly into space. Thus the \
	cycle repeats itself."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/blob)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_blobs
	name = "Collection - Blob"
	desc = "You have scanned an array of different types of Blob forms, \
	and therefore you have been granted a moderate sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/blob,
		/datum/category_item/catalogue/fauna/blob/spore
		)

/mob/living/simple_mob/blob
	icon = 'icons/mob/blob.dmi'
	pass_flags = PASSBLOB | PASSTABLE
	faction = "blob"
	catalogue_data = list(/datum/category_item/catalogue/fauna/blob)

	heat_damage_per_tick = 0
	cold_damage_per_tick = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	taser_kill = FALSE

	var/mob/observer/blob/overmind = null
	var/obj/structure/blob/factory/factory = null

	mob_class = MOB_CLASS_SLIME
	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/blob/speech_bubble_appearance()
	return "slime"

/mob/living/simple_mob/blob/update_icons()
	if(overmind)
		color = overmind.blob_type.complementary_color
	else
		color = null
	..()

/mob/living/simple_mob/blob/Destroy()
	if(overmind)
		overmind.blob_mobs -= src
	return ..()

/mob/living/simple_mob/blob/blob_act(obj/structure/blob/B)
	if(!overmind && B.overmind)
		overmind = B.overmind
		update_icon()

	if(stat != DEAD && health < maxHealth)
		adjustBruteLoss(-maxHealth*0.0125)
		adjustFireLoss(-maxHealth*0.0125)

/mob/living/simple_mob/blob/CanAllowThrough(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/blob)) // Don't block blobs from expanding onto a tile occupied by a blob mob.
		return TRUE
	return ..()

/mob/living/simple_mob/blob/Process_Spacemove()
	for(var/obj/structure/blob/B in range(1, src))
		return TRUE
	return ..()
