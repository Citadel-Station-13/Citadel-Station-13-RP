/obj/item/rig_component
	name = "rigsuit component"
	desc = "Some unknown rigsuit component."

	//? binding
	/// hotbound?
	var/bound = FALSE
	/// can bind? tihs is also subject to component type sometimes.
	var/bindable = FALSE

	//? ui
	/// tgui id
	var/tgui_id = ""

	//? zones
	/// rig zones this inhabits
	var/rig_zones = RIG_ZONE_CONTROLLER

/obj/item/rig_component/proc/on_attach(obj/item/rig/controller)

/obj/item/rig_component/proc/on_detach(obj/item/rig/controller)

#warn impl all

