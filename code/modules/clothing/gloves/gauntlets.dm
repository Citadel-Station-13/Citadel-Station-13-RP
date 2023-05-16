/*
 *	WORKS FOR RIGS, NOT AS A STANDALONE RIGHT NOW
 *
 *	TODO: 	FIX QUICK_EQUIP SO IT DOESN'T EQUIP THESE TO YOUR BACK WHEN YOU HAVE NO GLOVES
 *			CHECK SLOWDOWN ON EQUIP/UNEQUIP
 *			ADD SPRITES FOR ANY ACTUAL GAUNTLET ITEMS, THE BASE GLOVE ITEM HAS NO SPRITE, FOR GOOD REASON
 */

/obj/item/clothing/gloves/gauntlets	//Used to cover gloves, otherwise act as gloves.
	name = "gauntlets"
	desc = "These gloves go over regular gloves."
	glove_level = 3
	overgloves = 1
	punch_force = 5
	var/obj/item/clothing/gloves/gloves = null	//Undergloves

/obj/item/clothing/gloves/gauntlets/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	if(slot != SLOT_ID_GLOVES)
		return FALSE

	var/obj/item/clothing/gloves/G = I
	if(!istype(G))
		return FALSE

	return !G.overgloves
