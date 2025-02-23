/// this is sent by /mob/living/carbon/proc/set_standing_overlay and /obj/item/proc/render_mob_appearance
// arguments passed in are a list containing:
// key: render key (defined by code/_DEFINES/mobs/rendering.dm)
// overlay_or_list: either an overlay, or a list of overlays
// do_not_update: if the change to standing overlays will cause the actual overlay list to change
#define COMSIG_CARBON_UPDATING_OVERLAY "carbon_updating_overlay"
