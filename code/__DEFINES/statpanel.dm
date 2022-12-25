//! helpers for forming list entries in statpanel_data().
/// direct text output
#define STATPANEL_DATA_LINE(line) . += line
/// key, value
#define STATPANEL_DATA_ENTRY(k, v) .[k] = v
/// kev, value, target ref; will route to statpanel_click().
#define STATPANEL_DATA_CLICK(k, v, t) . += list(list(k, v, t))

// todo: click with action param instead of just click
