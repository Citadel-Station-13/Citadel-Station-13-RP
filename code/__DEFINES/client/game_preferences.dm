//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#define GAME_PREFERENCE_TOGGLE_VERB_DECLARE(NAME, TOGGLEPATH)
#warn impl that

#warn below
// current version; bump to trigger migrations
#define GAME_PREFERENCES_VERSION_CURRENT 1
// prefs start at this version
#define GAME_PREFERENCES_VERSION_CREATED 1
// below this, we throw out all data
#define GAME_PREFERENCES_VERSION_DROP 0
