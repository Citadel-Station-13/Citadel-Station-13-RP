/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

#define ui_entire_screen "LEFT,BOTTOM to RIGHT,TOP"

//Lower left, persistant menu
#define ui_inventory "LEFT:6,BOTTOM:5"

//Lower center, persistant menu
#define ui_sstore1 "LEFT+2:10,BOTTOM:5"
#define ui_id "LEFT+3:12,BOTTOM:5"
#define ui_belt "LEFT+4:14,BOTTOM:5"
#define ui_back "CENTER-2:14,BOTTOM:5"
#define ui_rhand "CENTER-1:16,BOTTOM:5"
#define ui_lhand "CENTER:16,BOTTOM:5"
#define ui_equip "CENTER-1:16,BOTTOM+1:5"
#define ui_swaphand1 "CENTER-1:16,BOTTOM+1:5"
#define ui_swaphand2 "CENTER:16,BOTTOM+1:5"
#define ui_storage1 "CENTER+1:16,BOTTOM:5"
#define ui_storage2 "CENTER+2:16,BOTTOM:5"
#define ui_smallquad "RIGHT-4:18,BOTTOM:4"

///aliens
#define ui_alien_head "CENTER-3:12,BOTTOM:5"
///aliens
#define ui_alien_oclothing "CENTER-2:14,BOTTOM:5"
///borgs
#define ui_inv1 "CENTER-1,BOTTOM:5"
///borgs
#define ui_inv2 "CENTER,BOTTOM:5"
///borgs
#define ui_inv3 "CENTER+1,BOTTOM:5"
///borgs
#define ui_borg_store "CENTER+2,BOTTOM:5"
///borgs
#define ui_borg_inventory "CENTER-2,BOTTOM:5"
///monkey
#define ui_monkey_mask "LEFT+4:14,BOTTOM:5"
///monkey
#define ui_monkey_back "LEFT+5:14,BOTTOM:5"
///same height as humans, hugging the right border
#define ui_construct_health "RIGHT:00,CENTER:15"
#define ui_construct_purge "RIGHT:00,CENTER-1:15"
///above health, slightly to the left
#define ui_construct_fire "RIGHT-1:16,CENTER+1:13"
///above the zone_sel icon
#define ui_construct_pull "RIGHT-1:28,BOTTOM+1:10"
//Lower right, persistant menu
#define ui_dropbutton "RIGHT-4:22,BOTTOM:5"
#define ui_drop_throw "RIGHT-1:28,BOTTOM+1:7"
#define ui_pull_resist "RIGHT-2:26,BOTTOM+1:7"
#define ui_acti "RIGHT-2:26,BOTTOM:5"
#define ui_movi "RIGHT-3:24,BOTTOM:5"
#define ui_zonesel "RIGHT-1:28,BOTTOM:5"
///alternative intent switcher for when the interface is hidden (F12)
#define ui_acti_alt "RIGHT-1:28,BOTTOM:5"
#define ui_borg_pull "RIGHT-3:24,BOTTOM+1:7"
#define ui_borg_module "RIGHT-2:26,BOTTOM+1:7"
#define ui_borg_panel "RIGHT-1:28,BOTTOM+1:7"

#define ui_ai_core "BOTTOM:6,LEFT:16"
#define ui_ai_camera_list "BOTTOM:6,LEFT+1:16"
#define ui_ai_track_with_camera "BOTTOM:6,LEFT+2:16"
#define ui_ai_camera_light "BOTTOM:6,LEFT+3:16"
#define ui_ai_crew_monitor "BOTTOM:6,LEFT+4:16"
#define ui_ai_crew_manifest "BOTTOM:6,LEFT+5:16"
#define ui_ai_alerts "BOTTOM:6,LEFT+6:16"
#define ui_ai_announcement "BOTTOM:6,LEFT+7:16"
#define ui_ai_shuttle "BOTTOM:6,LEFT+8:16"
#define ui_ai_state_laws "BOTTOM:6,LEFT+9:16"
#define ui_ai_pda_send "BOTTOM:6,LEFT+10:16"
#define ui_ai_pda_log "BOTTOM:6,LEFT+11:16"
#define ui_ai_take_picture "BOTTOM:6,LEFT+12:16"
#define ui_ai_view_images "BOTTOM:6,LEFT+13:16"
#define ui_ai_multicam "BOTTOM+1:6,LEFT+11:16"
#define ui_ai_add_multicam "BOTTOM+1:6,LEFT+12:16"
#define ui_ai_updown "BOTTOM+1:6,LEFT+13:16"

//Upper-middle right (alerts)
#define ui_alert1 "RIGHT-1:28,CENTER+5:27"
#define ui_alert2 "RIGHT-1:28,CENTER+4:25"
#define ui_alert3 "RIGHT-1:28,CENTER+3:23"
#define ui_alert4 "RIGHT-1:28,CENTER+2:21"
#define ui_alert5 "RIGHT-1:28,CENTER+1:19"

//Gun buttons
#define ui_gun1 "RIGHT-2:26,BOTTOM+2:7"
#define ui_gun2 "RIGHT-1:28, BOTTOM+3:7"
#define ui_gun3 "RIGHT-2:26,BOTTOM+3:7"
#define ui_gun_select "RIGHT-1:28,BOTTOM+2:7"
#define ui_gun4 "RIGHT-3:24,BOTTOM+2:7"

//Upper-middle right (damage indicators)
#define ui_toxin "RIGHT-1:28,TOP-2:27"
#define ui_fire "RIGHT-1:28,TOP-3:25"
#define ui_oxygen "RIGHT-1:28,TOP-4:23"
#define ui_pressure "RIGHT-1:28,TOP-5:21"

#define ui_alien_toxin "RIGHT-1:28,TOP-2:25"
#define ui_alien_fire "RIGHT-1:28,TOP-3:25"
#define ui_alien_oxygen "RIGHT-1:28,TOP-4:25"

//Middle right (status indicators)
#define ui_nutrition "RIGHT-1:28,CENTER-2:11"
#define ui_nutrition_small "RIGHT-1:28,CENTER-2:24"
#define ui_temp "RIGHT-1:28,CENTER-1:13"
#define ui_health "RIGHT-1:28,CENTER:15"
#define ui_internal "RIGHT-1:28,CENTER+1:17"
									//borgs
///borgs have the health display where humans have the pressure damage indicator.
#define ui_borg_health "RIGHT-1:28,CENTER-1:13"
///aliens have the health display where humans have the pressure damage indicator.
#define ui_alien_health "RIGHT-1:28,CENTER-1:13"
#define ui_ling_chemical_display "RIGHT-1:28,CENTER-3:15"
#define ui_wiz_energy_display "RIGHT-1:28,CENTER-3:15"
//#define ui_wiz_instability_display "RIGHT-2:28,CENTER-3:15"
#define ui_wiz_instability_display "RIGHT-1:28,TOP-2:27"

//Pop-up inventory
#define ui_shoes "LEFT+1:8,BOTTOM:5"

#define ui_iclothing "LEFT:6,BOTTOM+1:7"
#define ui_oclothing "LEFT+1:8,BOTTOM+1:7"
#define ui_gloves "LEFT+2:10,BOTTOM+1:7"

#define ui_glasses "LEFT:6,BOTTOM+2:9"
#define ui_mask "LEFT+1:8,BOTTOM+2:9"
#define ui_l_ear "LEFT+2:10,BOTTOM+2:9"
#define ui_r_ear "LEFT+2:10,BOTTOM+3:11"

#define ui_head "LEFT+1:8,BOTTOM+3:11"

//Intent small buttons
#define ui_help_small "RIGHT-3:8,BOTTOM:1"
#define ui_disarm_small "RIGHT-3:15,BOTTOM:18"
#define ui_grab_small "RIGHT-3:32,BOTTOM:18"
#define ui_harm_small "RIGHT-3:39,BOTTOM:1"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "BOTTOM,8"
#define ui_hand "CENTER-1:14,BOTTOM:5"
#define ui_hstore1 "CENTER-2,CENTER-2"
//#define ui_resist "RIGHT+1,BOTTOM-1"
#define ui_sleep "RIGHT+1, TOP-13"
#define ui_rest "RIGHT+1, TOP-14"


#define ui_iarrowleft "BOTTOM-1,RIGHT-4"
#define ui_iarrowright "BOTTOM-1,RIGHT-2"

#define ui_spell_master "RIGHT-2:16,TOP-1:26"
#define ui_genetic_master "RIGHT-1:16,TOP-3:16"

#define ui_shadekin_display "RIGHT-1:28,CENTER-3:15"
#define ui_xenochimera_danger_display "RIGHT-1:28,CENTER-3:15"

// Ghost ones
#define ui_ghost_returntomenu "BOTTOM:6,CENTER-3:24"
#define ui_ghost_jumptomob "BOTTOM:6,CENTER-2:24"
#define ui_ghost_orbit "BOTTOM:6,CENTER-1:24"
#define ui_ghost_reenter_corpse "BOTTOM:6,CENTER:24"
#define ui_ghost_teleport "BOTTOM:6,CENTER+1:24"
#define ui_ghost_pai "BOTTOM: 6,CENTER+2:24"
#define ui_ghost_updown "BOTTOM: 6,CENTER+3:24"
#define ui_ghost_spawners "BOTTOM: 6,CENTER+4:24"

// Rig panel
#define ui_rig_deco1 "LEFT:-7, BOTTOM+5"
#define ui_rig_deco2 "LEFT:-7, BOTTOM+6"
#define ui_rig_pwr "LEFT+1:-7, BOTTOM+6"
#define ui_rig_health "LEFT+1:-7, BOTTOM+6"
#define ui_rig_air "LEFT+1:-7, BOTTOM+5"
#define ui_rig_airtoggle "LEFT+1:-7, BOTTOM+5"
#define ui_rig_deco1_f "LEFT+2:-7, BOTTOM+5"
#define ui_rig_deco2_f "LEFT+2:-7, BOTTOM+6"

// Mech panel
#define ui_mech_deco1 "LEFT:-7, BOTTOM+8"
#define ui_mech_deco2 "LEFT:-7, BOTTOM+9"
#define ui_mech_pwr "LEFT+1:-7, BOTTOM+9"
#define ui_mech_health "LEFT+1:-7, BOTTOM+9"
#define ui_mech_air "LEFT+1:-7, BOTTOM+8"
#define ui_mech_airtoggle "LEFT+1:-7, BOTTOM+8"
#define ui_mech_deco1_f "LEFT+2:-7, BOTTOM+8"
#define ui_mech_deco2_f "LEFT+2:-7, BOTTOM+9"
