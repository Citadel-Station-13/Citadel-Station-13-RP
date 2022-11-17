GLOBAL_LIST_EMPTY(auxtools_initialized)

#define AUXTOOLS_CHECK(LIB)\
	if (!GLOB.auxtools_initialized[LIB]) {\
		if (fexists(LIB)) {\
			var/string = call(LIB,"auxtools_init")();\
			if(findtext(string, "SUCCESS")) {\
				GLOB.auxtools_initialized[LIB] = TRUE;\
			} else {\
				CRASH(string);\
			}\
		} else {\
			CRASH("No file named [LIB] found!")\
		}\
	}\

#define AUXTOOLS_SHUTDOWN(LIB)\
	if (GLOB.auxtools_initialized[LIB] && fexists(LIB)){\
		call(LIB,"auxtools_shutdown")();\
		GLOB.auxtools_initialized[LIB] = FALSE;\
	}\

// #define AUXTOOLS_YAML (world.system_type == MS_WINDOWS? "auxyaml.dll" : null)

// /proc/yaml_encode(content)
// 	CRASH("auxtools didn't hook this")

// /proc/yaml_decode(content)
// 	CRASH("auxtools didn't hook this")
