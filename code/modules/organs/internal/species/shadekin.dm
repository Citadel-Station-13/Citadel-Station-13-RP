/obj/item/organ/internal/brain/shadekin
	can_assist = FALSE

	var/dark_energy = 100
	var/max_dark_energy = 100
	var/dark_energy_infinite = FALSE

	organ_actions = list(
		/datum/action/organ_action/shadekin_storage,
	)

/datum/action/organ_action/shadekin_storage
	name = "Access Storage"
	desc = "Access your dimensional pocket."

/obj/item/organ/internal/brain/shadekin/Initialize(mapload)
	. = ..()
	obj_storage = new /datum/object_system/storage/shadekin(src)
	obj_storage.indirect(src)

/obj/item/organ/internal/brain/shadekin/on_insert(mob/owner, initializing)
	. = ..()
	RegisterSignal(owner, COMSIG_ATOM_REACHABILITY_DIRECTACCESS, PROC_REF(handle_storage_reachability))

/obj/item/organ/internal/brain/shadekin/on_remove(mob/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_ATOM_REACHABILITY_DIRECTACCESS)

/obj/item/organ/internal/brain/shadekin/proc/handle_storage_reachability(atom/source, list/direct_access)
	var/atom/movable/storage_indirection/indirection = locate() in contents
	if(!indirection)
		return
	direct_access += indirection

/obj/item/organ/internal/brain/shadekin/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	obj_storage.show(actor.performer)

/datum/object_system/storage/shadekin
	max_single_weight_class = WEIGHT_CLASS_SMALL
	max_items = 7

/obj/item/organ/internal/brain/shadekin/crewkin
	dark_energy = 50
	max_dark_energy = 50

/obj/item/organ/internal/brain/shadekin/crewkin/damaged
	dark_energy = 25
	max_dark_energy = 25

/obj/item/organ/internal/brain/shadekin/crewkin/heavilydamaged
	dark_energy = 0
	max_dark_energy = 0
