//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/process_power(dt)


/**
 * use some power from rig cell
 */
/obj/item/rig/proc/draw_power(joules, obj/item/rig_module/maybe_module)

/**
 * gives some power to rig cell
 */
/obj/item/rig/proc/give_power(joules, obj/item/rig_module/maybe_module)

/**
 * * Calling this again to modify is allowed.
 * * Negative values are allowed; that's power generation.
 */
/obj/item/rig/proc/register_module_static_power_draw(obj/item/rig_module/module, watts)

/obj/item/rig/proc/unregister_module_static_power_draw(obj/item/rig_module/module)

#warn fuck

/obj/item/rig/proc/draw_controller_power(joules)

/obj/item/rig/proc/give_controller_power(joules)

/**
 * * Calling this again to modify is allowed.
 * * Negative values are allowed; that's power generation.
 */
/obj/item/rig/proc/register_static_controller_power_draw(text_source, watts)

/obj/item/rig/proc/unregister_static_controller_power_draw(text_source)
