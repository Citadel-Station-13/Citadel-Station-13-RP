//Do not ever touch these unless you know absolutely for sure what you are doing.
#define LOWEST_SUPPORTED_SAVEFILE_VERSION 8
#define SAVEFILE_VERSION_MIGRATION_SYSTEM_INTRODUCTION 12		//Oldest version where the new migration system was in place.
#define SAVEFILE_VERSION_CURRENT 12

#define SAVEFILE_MIGRATION_NOT_NEEDED 0				//don't need it
#define SAVEFILE_MIGRATION_SUCCESSFUL 1				//Fully successful.
#define SAVEFILE_MIGRATION_FAIL 2					//Stuff's likely broken
#define SAVEFILE_MIGRATION_CATASTROPHIC_FAIL 3		//Wipe file, too old
#define SAVEFILE_MIGRATION_NULLFILE_FAIL 4			//Couldn't find file, make a new one

//Paths and keys!

#define PLAYER_SAVE_DIRECTORY_PATH "[SERVER_STATIC_FOLDER_PATH]/player_saves"
#define PLAYER_SAVE_PATH(ckey) "[PLAYER_SAVE_DIRECTORY_PATH]/[copytext(ckey, 1, 2)]/[ckey]"
#define PLAYER_SAVE_FILENAME "preferences.sav"

//METAINFORMATION
#define SAVEFILE_PATH_METAINF "/"
#define SAVEFILE_KEY_METAINF_VERSION "version"
