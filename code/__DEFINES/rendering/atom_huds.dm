
// constant list lookup of hud to icon
GLOBAL_LIST_INIT(hud_icon_files, list(
	BIOLOGY_HUD = 'icons/screen/atom_hud/biology.dmi',
	LIFE_HUD = 'icons/screen/atom_hud/health.dmi',
	WANTED_HUD = 'icons/screen/atom_hud/security.dmi',
	IMPLOYAL_HUD = 'icons/screen/atom_hud/implant.dmi',
	IMPCHEM_HUD = 'icons/screen/atom_hud/implant.dmi',
	IMPTRACK_HUD = 'icons/screen/atom_hud/implant.dmi',
	ANTAG_HUD = 'icons/screen/atom_hud/antag.dmi',
	ID_HUD = 'icons/screen/atom_hud/job.dmi'
))

// constant list lookup of hud to layer
GLOBAL_LIST_INIT(hud_icon_layers, list(
	BIOLOGY_HUD = 1	// render above default
))

//alternate appearance flags
#define AA_TARGET_SEE_APPEARANCE (1<<0)
#define AA_MATCH_TARGET_OVERLAYS (1<<1)
