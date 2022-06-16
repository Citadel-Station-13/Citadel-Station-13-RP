// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list
// note: if you add more HUDs, even for non-human atoms, make sure to use unique numbers for the defines!
// /datum/atom_hud expects these to be unique
// these need to be strings in order to make them associative lists
/// dead, alive, sick, health status
#define STATUS_HUD		"1"
/// a simple line rounding the mob's number health
#define LIFE_HUD		"2"
/// the job asigned to your ID
#define ID_HUD			"3"
/// wanted, released, parroled, security status
#define WANTED_HUD		"4"
/// loyality implant
#define IMPLOYAL_HUD	"5"
/// chemical implant
#define IMPCHEM_HUD		"6"
/// tracking implant
#define IMPTRACK_HUD	"7"
/// antag icon
#define ANTAG_HUD		"8"
/// animal alt appearance
#define WORLD_BENDER_ANIMAL_HUD					"9"
// todo: datum hud icons

// constant list lookup of hud to icon
GLOBAL_LIST_INIT(hud_icon_files, list(
	STATUS_HUD = 'icons/screen/atom_hud/status.dmi',
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
	STATUS_HUD = 1	// render above default
))

//by default everything in the hud_list of an atom is an image
//a value in hud_list with one of these will change that behavior
#define HUD_LIST_LIST 1

//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_SECURITY_BASIC			1
#define DATA_HUD_SECURITY_ADVANCED		2
#define DATA_HUD_MEDICAL				3
#define DATA_HUD_ID_JOB					4

#define HUD_ANTAG						5

#define WORLD_BENDER_HUD_ANIMALS		6

///cooldown for being shown the images for any particular data hud
#define ADD_HUD_TO_COOLDOWN 20
