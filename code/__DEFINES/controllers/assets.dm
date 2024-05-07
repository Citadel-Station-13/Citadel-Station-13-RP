//* asset loaded status

/// not loaded at all
#define ASSET_NOT_LOADED 1
/// loading started, wait
#define ASSET_IS_LOADING 2
/// loading finished, go
#define ASSET_FULLY_LOADED 3

#warn todo

#define ASSET_CROSS_ROUND_CACHE_DIRECTORY "tmp/assets"

/// When sending mutiple assets, how many before we give the client a quaint little sending resources message
#define ASSET_CACHE_TELL_CLIENT_AMOUNT 8
