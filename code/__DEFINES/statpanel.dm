//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//! helpers for forming list entries in statpanel_data().
/// direct text output - cheaply encode without list, js side will view as string
#define INJECT_STATPANEL_DATA_LINE(INTO_LIST, LINE) INTO_LIST += LINE
/// key, value
#define INJECT_STATPANEL_DATA_ENTRY(INTO_LIST, KEY, VALUE) INTO_LIST += list(list(KEY, VALUE))
/// kev, value, target ref; will route to statpanel_click().
#define INJECT_STATPANEL_DATA_CLICK(INTO_LIST, KEY, VALUE, REF) . += list(list(KEY, VALUE, REF))

// todo: click with action param instead of just click
