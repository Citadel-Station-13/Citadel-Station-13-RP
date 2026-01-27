//* ui_status
/// Green eye; fully interactive
#define UI_INTERACTIVE 2
/// Orange eye; updates but is not interactive
#define UI_UPDATE 1
/// Red eye; disabled, does not update
#define UI_DISABLED 0
/// UI Should close
#define UI_CLOSE -1

//* refreshing var
/// no refresh queued
#define UI_NOT_REFRESHING 0
/// soft refreshing - can show a status, won't block viewport
#define UI_SOFT_REFRESHING 1
/// hard refreshing - completely block the ui while it is queued
#define UI_HARD_REFRESHING 2

/// Maximum number of windows that can be suspended/reused
#define TGUI_WINDOW_SOFT_LIMIT 5
/// Maximum number of open windows
#define TGUI_WINDOW_HARD_LIMIT 9

/// Maximum ping timeout allowed to detect zombie windows
#define TGUI_PING_TIMEOUT 4 SECONDS
/// Used for rate-limiting to prevent DoS by excessively refreshing a TGUI window
#define TGUI_REFRESH_FULL_UPDATE_COOLDOWN 2 SECONDS

/// Window does not exist
#define TGUI_WINDOW_CLOSED 0
/// Window was just opened, but is still not ready to be sent data
#define TGUI_WINDOW_LOADING 1
/// Window is free and ready to receive data
#define TGUI_WINDOW_READY 2

/// Though not the maximum renderable ByondUis within tgui, this is the maximum that the server will manage per-UI
#define TGUI_MANAGED_BYONDUI_LIMIT 10

// These are defines instead of being inline, as they're being sent over
// from tgui-core, so can't be easily played with
#define TGUI_MANAGED_BYONDUI_TYPE_RENDER "renderByondUi"
#define TGUI_MANAGED_BYONDUI_TYPE_UNMOUNT "unmountByondUi"

#define TGUI_MANAGED_BYONDUI_PAYLOAD_ID "renderByondUi"

/// Get a window id based on the provided pool index
#define TGUI_WINDOW_ID(index) "tgui-window-[index]"
/// Get a pool index of the provided window id
#define TGUI_WINDOW_INDEX(window_id) text2num(copytext(window_id, 13))

/// Creates a message packet for sending via output()
// This is {"type":type,"payload":payload}, but pre-encoded. This is much faster
// than doing it the normal way.
// To ensure this is correct, this is unit tested in tgui_create_message.
#define TGUI_CREATE_MESSAGE(type, payload) ( \
	"%7b%22type%22%3a%22[type]%22%2c%22payload%22%3a[url_encode(json_encode(payload))]%7d" \
)

/**
 * Gets a ui_state that checks to see if the user has specific admin permissions.
 *
 * Arguments:
 * * required_perms: Which admin permission flags to check the user for, such as [R_ADMIN]
 */
#define ADMIN_STATE(required_perms) (GLOB.admin_states["[required_perms]"] ||= new /datum/ui_state/admin_state(required_perms))

//* Legacy Modal Stuff

/// Max length for Modal Input
#define UI_MODAL_INPUT_MAX_LENGTH 1024
/// Max length for Modal Input for names
/// Names for generally anything don't go past 32, let alone 64.
#define UI_MODAL_INPUT_MAX_LENGTH_NAME 64
#define UI_MODAL_OPEN 1
#define UI_MODAL_DELEGATE 2
#define UI_MODAL_ANSWER 3
#define UI_MODAL_CLOSE 4

//* tgui dynamic input
//* all constraints must be specified if it is included.

#define TGUI_INPUT_DATA_TYPE "type"
#define TGUI_INPUT_DATA_DESC "desc"
#define TGUI_INPUT_DATA_NAME "name"
#define TGUI_INPUT_DATA_CONSTRAINTS "constraints"
#define TGUI_INPUT_DATA_DEFAULT "default"

/// constraints: [maxlength]
#define TGUI_INPUT_DATATYPE_TEXT "text"
/// constraints: [min, max, round]
#define TGUI_INPUT_DATATYPE_NUM "num"
/// constraints (required): [str1, str2, ...]
#define TGUI_INPUT_DATATYPE_LIST_PICK "list_single"
/// constraints: nothing
#define TGUI_INPUT_DATATYPE_TOGGLE "bool"

//* TGUI Themes - keep in sync.

#define TGUI_THEME_ABDUCTOR "abductor"
#define TGUI_THEME_ABSTRACT "abstract"
#define TGUI_THEME_ADMIN "admin"
#define TGUI_THEME_CARDTABLE "cardtable"
#define TGUI_THEME_CITADEL "citadel"
#define TGUI_THEME_CLOCKCULT "clockcult"
#define TGUI_THEME_HACKERMAN "hackerman"
#define TGUI_THEME_MALFUNCTION "malfunction"
#define TGUI_THEME_NEUTRAL "neutral"
#define TGUI_THEME_NTOS "ntos"
#define TGUI_THEME_PAPER "paper"
#define TGUI_THEME_PDA_RETRO "pda-retro"
#define TGUI_THEME_RETRO "retro"
#define TGUI_THEME_SPOOKYCONSOLE "spookyconsole"
#define TGUI_THEME_SYNDICATE "syndicate"
#define TGUI_THEME_WIZARD "wizard"

/**
 * real global because lack of modification need
 */
GLOBAL_REAL_LIST(all_tgui_themes) = list(
	TGUI_THEME_ABDUCTOR,
	TGUI_THEME_ABSTRACT,
	TGUI_THEME_ADMIN,
	TGUI_THEME_CARDTABLE,
	TGUI_THEME_CITADEL,
	TGUI_THEME_CLOCKCULT,
	TGUI_THEME_HACKERMAN,
	TGUI_THEME_MALFUNCTION,
	TGUI_THEME_NEUTRAL,
	TGUI_THEME_NTOS,
	TGUI_THEME_PAPER,
	TGUI_THEME_PDA_RETRO,
	TGUI_THEME_RETRO,
	TGUI_THEME_SPOOKYCONSOLE,
	TGUI_THEME_SYNDICATE,
	TGUI_THEME_WIZARD,
)
