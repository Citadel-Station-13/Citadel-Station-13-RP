/obj/item/organ/internal/shadekin
	abstract_type = /obj/item/organ/internal/shadekin

/datum/action/organ_action/shadekin_storage
	name = "Access Storage"
	desc = "Access your dimensional pocket."

/datum/object_system/storage/shadekin
	max_single_weight_class = WEIGHT_CLASS_SMALL
	max_items = 7

/**
 * Shadekin powers come from here.
 */
/obj/item/organ/internal/shadekin/dimensional_cluster
	name = "transient-plane cluster"
	desc = {"
		A strange network reminiscent of the lymphatic systems in mammals. It stretches across the
		body of its host and allows them access to another plane.
	"}
	organ_key = ORGAN_KEY_SHADEKIN_DIMENSIONAL_CLUSTER

	var/dark_energy = 100
	var/max_dark_energy = 100
	var/dark_energy_infinite = FALSE

	organ_actions = list(
		/datum/action/organ_action/shadekin_storage,
	)

/obj/item/organ/internal/shadekin/dimensional_cluster/Initialize(mapload)
	. = ..()
	obj_storage = new /datum/object_system/storage/shadekin(src)
	obj_storage.indirect(src)

/obj/item/organ/internal/shadekin/dimensional_cluster/on_insert(mob/owner, initializing)
	. = ..()
	RegisterSignal(owner, COMSIG_ATOM_REACHABILITY_DIRECTACCESS, PROC_REF(handle_storage_reachability))

/obj/item/organ/internal/shadekin/dimensional_cluster/on_remove(mob/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_ATOM_REACHABILITY_DIRECTACCESS)

/obj/item/organ/internal/shadekin/dimensional_cluster/proc/handle_storage_reachability(atom/source, list/direct_access)
	var/atom/movable/storage_indirection/indirection = locate() in contents
	if(!indirection)
		return
	direct_access += indirection

/obj/item/organ/internal/shadekin/dimensional_cluster/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	obj_storage.show(actor.performer)

/obj/item/organ/internal/shadekin/dimensional_cluster/crewkin
	dark_energy = 50
	max_dark_energy = 50

/obj/item/organ/internal/shadekin/dimensional_cluster/crewkin/damaged
	dark_energy = 25
	max_dark_energy = 25

/obj/item/organ/internal/shadekin/dimensional_cluster/crewkin/heavilydamaged
	dark_energy = 0
	max_dark_energy = 0
