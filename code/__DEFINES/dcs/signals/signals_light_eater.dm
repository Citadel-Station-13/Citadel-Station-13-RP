/**
 *! ## Light Eater Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! /datum/element/light_eater
/// From base of [/datum/element/light_eater/proc/table_buffet]: (list/light_queue, datum/light_eater)
////#define COMSIG_LIGHT_EATER_QUEUE "light_eater_queue"
/// From base of [/datum/element/light_eater/proc/devour]: (datum/light_eater)
////#define COMSIG_LIGHT_EATER_ACT "light_eater_act"
	///? Prevents the default light eater behavior from running in case of immunity or custom behavior
	////#define COMPONENT_BLOCK_LIGHT_EATER (1<<0)
/// From base of [/datum/element/light_eater/proc/devour]: (atom/eaten_light)
////#define COMSIG_LIGHT_EATER_DEVOUR "light_eater_devour"
