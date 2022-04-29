/**
 *! ## Painting Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! Signals for painting canvases, tools and the /datum/component/palette component
/// From base of /item/proc/set_painting_tool_color(): (chosen_color)
////#define COMSIG_PAINTING_TOOL_SET_COLOR "painting_tool_set_color"

/// From base of /item/canvas/ui_data(): (data)
////#define COMSIG_PAINTING_TOOL_GET_ADDITIONAL_DATA "painting_tool_get_data"
