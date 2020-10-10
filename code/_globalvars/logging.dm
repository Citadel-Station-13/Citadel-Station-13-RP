/// Base directory at where logs are placed
GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)
/// General game log for anything that doesn't fit elsewhere
GLOBAL_VAR(world_game_log)
GLOBAL_PROTECT(world_game_log)
GLOBAL_VAR(world_asset_log)
GLOBAL_PROTECT(world_asset_log)
/// Runtimes go in here
GLOBAL_VAR(world_runtime_log)
GLOBAL_PROTECT(world_runtime_log)
/// qdel() performance logging
GLOBAL_VAR(world_qdel_log)
GLOBAL_PROTECT(world_qdel_log)
/// Attack logs/actions go in here
GLOBAL_VAR(world_attack_log)
GLOBAL_PROTECT(world_attack_log)
/// Href logs go in here
GLOBAL_VAR(world_href_log)
GLOBAL_PROTECT(world_href_log)
/// Current round ID. If unset, logs will use the old timestamp-directory format.
GLOBAL_VAR(round_id)
GLOBAL_PROTECT(round_id)
/// Config loading error/config validation errors
GLOBAL_VAR(config_error_log)
GLOBAL_PROTECT(config_error_log)
/// Map error logging
GLOBAL_VAR(world_map_error_log)
GLOBAL_PROTECT(world_map_error_log)
/// datum/controller/subsystem logging in general
GLOBAL_VAR(subsystem_log)
GLOBAL_PROTECT(subsystem_log)

/////Picture logging
GLOBAL_VAR(picture_log_directory)
GLOBAL_PROTECT(picture_log_directory)

GLOBAL_VAR_INIT(picture_logging_id, 1)
GLOBAL_PROTECT(picture_logging_id)
GLOBAL_VAR(picture_logging_prefix)
GLOBAL_PROTECT(picture_logging_prefix)
/////
