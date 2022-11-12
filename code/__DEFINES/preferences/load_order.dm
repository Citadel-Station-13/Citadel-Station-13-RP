// basically everything depends on this
#define PREFERENCE_LOAD_ORDER_REAL_SPECIES -1000
// basically everything depends on this but it needs to load after real for fallback
#define PREFERENCE_LOAD_ORDER_CHAR_SPECIES -999
// default
#define PREFERENCE_LOAD_ORDER_DEFAULT 0
// lore/fluff is unimportant and can load later
#define PREFERENCE_LOAD_ORDER_LORE 50
// faction depends on origin/citizenship
#define PREFERENCE_LOAD_ORDER_LORE_FACTION 55
// language loads last as intrinsincs need to load first
#define PREFERENCE_LOAD_ORDER_LANGUAGE 60
