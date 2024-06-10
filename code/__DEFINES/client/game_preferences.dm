//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Versioning *//

// Migration Directives:
// * prefer append-update instead of change-remove.
//   append-update means write new, changed data instead of overwrite old data
//   this means that reverting a testmerge doesn't cause problems.

// todo: how to do migration in a downstream-friendly way? current
//       would require downstreams to manually edit code.
//       this is bad!

// current version; bump to trigger migrations
#define GAME_PREFERENCES_VERSION_CURRENT 1
// prefs start at this version when legacy
#define GAME_PREFERENCES_VERSION_LEGACY 1
// at or below this, we throw out all data
#define GAME_PREFERENCES_VERSION_DROP 0

//* Misc Keys *//

/// boolean value for if we're in hotkeys mode
#define GAME_PREFERENCE_MISC_KEY_HOTKEY_MODE "hotkey-mode"

//* Category Names

// these are the same due to low entry count

#define GAME_PREFERENCE_CATEGORY_GAME "Game"
#define GAME_PREFERENCE_CATEGORY_GRAPHICS "Game"
