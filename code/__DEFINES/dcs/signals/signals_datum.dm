/**
 *! ## Datum Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! ## /datum signals
/// When a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// Before a component is removed from a datum because of ClearFromParent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// Before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// Just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
/// From datum ui_act (usr, action, list/params, datum/tgui/ui, datum/tgui_module_context/module_context)
#define COMSIG_DATUM_UI_ACT "ui_act"
/// From datum push_ui_data: (mob/user, datum/tgui/ui, list/data)
#define COMSIG_DATUM_PUSH_UI_DATA "push_ui_data"
