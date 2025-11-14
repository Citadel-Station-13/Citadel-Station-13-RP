
/obj/item/organ/internal/nano/refactory
	name = "refactory module"
	desc = "A miniature metal processing unit and nanite factory."
	icon = 'icons/mob/clothing/species/protean/protean.dmi'
	icon_state = "refactory"
	organ_tag = O_FACT
	parent_organ = BP_TORSO

	var/list/stored_materials = list(MAT_STEEL = 0)
	var/max_storage = 10000
	var/processingbuffs = FALSE

/obj/item/organ/internal/nano/refactory/proc/get_stored_material(var/material)
	if(status & ORGAN_DEAD)
		return 0
	return stored_materials[material] || 0

/obj/item/organ/internal/nano/refactory/proc/add_stored_material(var/material,var/amt)
	if(status & ORGAN_DEAD)
		return 0
	var/increase = min(amt,max(max_storage-stored_materials[material],0))
	if(isnum(stored_materials[material]))
		stored_materials[material] += increase
	else
		stored_materials[material] = increase

	return increase

/obj/item/organ/internal/nano/refactory/proc/use_stored_material(var/material,var/amt)
	if(status & ORGAN_DEAD)
		return 0

	var/available = stored_materials[material]

	//Success
	if(available >= amt)
		var/new_amt = available-amt
		if(new_amt == 0)
			stored_materials -= material
		else
			stored_materials[material] = new_amt
		return amt

	//Failure
	return 0

/obj/item/organ/internal/nano/refactory/loaded
	stored_materials = list(
		MAT_STEEL = /obj/item/organ/internal/nano/refactory::max_storage,
	)
