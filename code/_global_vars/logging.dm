/// Base directory at where logs are placed
GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)
/// General game log for anything that doesn't fit elsewhere
GLOBAL_VAR(world_game_log)
GLOBAL_PROTECT(world_game_log)
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
/// datum/controller/subsystem logging in general
GLOBAL_VAR(subsystem_log)
GLOBAL_PROTECT(subsystem_log)
