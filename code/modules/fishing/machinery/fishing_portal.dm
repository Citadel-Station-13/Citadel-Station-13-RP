/obj/machinery/fishing_portal
	name = "fish-porter 3000"
	desc = "Fish anywhere, any-time! Wait, how does this even work..?"

	icon = 'icons/modules/fishing/fishing_portal.dmi'
	icon_state = "portal_off"

	idle_power_usage = 0
	active_power_usage = 0

	default_unanchor = 3 SECONDS

	anchored = FALSE
	density = TRUE

	var/active = FALSE
	var/fishing_source = /datum/fish_source/portal

/obj/machinery/fishing_portal/interact(mob/user, special_state)
	. = ..()
	if(active)
		deactivate()
	else
		activate()

/obj/machinery/fishing_portal/update_icon_state()
	if(active)
		icon_state = "portal_on"
	else
		icon_state = "portal_off"
	return ..()

/obj/machinery/fishing_portal/proc/activate()
	active = TRUE
	AddComponent(/datum/component/fishing_spot, fishing_source)
	update_icon()

/obj/machinery/fishing_portal/proc/deactivate()
	active = FALSE
	var/datum/component/fishing_spot/fishing_component = GetComponent(/datum/component/fishing_spot)
	if(fishing_component)
		QDEL_NULL(fishing_component)
	update_icon()

/datum/fish_source/portal
	fish_table = list(
		FISHING_DUD = 2.5,
		/obj/item/fish/goldfish = 10,
		/obj/item/fish/guppy = 10,
	)
	catalog_description = "Fish dimension (Fishing portal generator)"
