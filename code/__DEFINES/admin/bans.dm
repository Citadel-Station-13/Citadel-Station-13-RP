//? roleban types
/// full server ban - currently just a shim to go to legacy isbanned, eventually just will go to server_ban.dm

#define BAN_ROLE_SERVER "server"
/// OOC + LOOC + deadchat ban
#define BAN_ROLE_OOC "ooc"
/// format job id to roleban ID - the use of a dash is deliberate due to job ids being formatted with underscores.
#define BAN_ROLE_JOB_ID(id) ("job-[id]")

