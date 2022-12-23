//! helpers for forming list entries in statpanel_data().
#define STATPANEL_DATA_LINE(line) . += line
#define STATPANEL_DATA_ENTRY(k, v) .[k] = v
#define STATPANEL_DATA_ACT(k, v, a) . += list(list(k, v, a))
