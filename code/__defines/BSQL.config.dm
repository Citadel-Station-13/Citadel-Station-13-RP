#define BSQL_EXTERNAL_CONFIGURATION

//Modify this if you disagree with byond's GC schemes. Ensure this is called for all connections and operations when they are deleted or they will leak native resources until /world/proc/BSQL_Shutdown() is called
#define BSQL_DEL_PROC(path) ##path/Del()

//The equivalent of calling del() in your codebase
#define BSQL_DEL_CALL(obj) qdel(##obj)

//Returns TRUE if an object is delete
#define BSQL_IS_DELETED(obj) QDELETED(obj)

//Modify this to add protections to the connection and query datums
#define BSQL_PROTECT_DATUM(path) GENERAL_PROTECT_DATUM(path)

//Modify this to change up error handling for the library
#define BSQL_ERROR(message) SSdbcore.ReportError(message)