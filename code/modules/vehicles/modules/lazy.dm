//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * "i'm too lazy to learn tgui please just let me powercreep science"
 * * for anything more complicated, write your own tgui!!
 */
/obj/item/vehicle_module/lazy
	ui_component = "Lazy"
	var/tmp/list/this_is_just_like_imgui

/**
 * override and call `l_ui_*` to build
 */
/obj/item/vehicle_module/lazy/proc/render_ui()

/obj/item/vehicle_module/lazy/proc/l_ui_html(label, content)
	this_is_just_like_imgui[++this_is_just_like_imgui.len] = list(
		"type" = "html",
		"label" = label,
		"content" = istext(content) ? content : "[content]",
	)

/obj/item/vehicle_module/lazy/proc/l_ui_button(key, label, text, active, disabled, confirm)
	this_is_just_like_imgui[++this_is_just_like_imgui.len] = list(
		"type" = "button",
		"key" = key,
		"label" = label,
		"text" = text,
		"active" = active,
		"disabled" = disabled,
		"confirm" = confirm,
	)

/**
 * * names can be associated to "disabled" as needed
 */
/obj/item/vehicle_module/lazy/proc/l_ui_select(key, label, list/names, selected, confirm)
	this_is_just_like_imgui[++this_is_just_like_imgui.len] = list(
		"type" = "select",
		"key" = key,
		"label" = label,
		"names" = names,
		"selected" = selected,
		"confirm" = confirm,
	)

/**
 * * names can be associated to "disabled" or "active" as needed
 */
/obj/item/vehicle_module/lazy/proc/l_ui_multiselect(key, label, list/names, confirm)
	this_is_just_like_imgui[++this_is_just_like_imgui.len] = list(
		"type" = "multiselect",
		"key" = key,
		"label" = label,
		"names" = names,
		"confirm" = confirm,
	)

/obj/item/vehicle_module/lazy/proc/get_ui_struct()
	this_is_just_like_imgui = list()
	render_ui()
	. = this_is_just_like_imgui
	this_is_just_like_imgui = null

/obj/item/vehicle_module/lazy/proc/on_l_ui_button(datum/event_args/actor/actor, key)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/vehicle_module/lazy/proc/on_l_ui_select(datum/event_args/actor/actor, key, name)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * unlike `on_l_ui_select`, this is called **on change.**
 */
/obj/item/vehicle_module/lazy/proc/on_l_ui_multiselect(datum/event_args/actor/actor, key, name, enabled)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/vehicle_module/lazy/vehicle_ui_module_data()
	. = ..()
	.["imtguiStruct"] = get_ui_struct()

/obj/item/vehicle_module/lazy/vehicle_ui_module_act(action, list/params, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("imtguiButton")
			on_l_ui_button(actor, params["key"])
		if("imtguiSelect")
			on_l_ui_button(actor, params["key"], params["name"])
		if("imtguiMultiselect")
			on_l_ui_button(actor, params["key"], params["name"], params["enabled"])
